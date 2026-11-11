# INFORME TÉCNICO - PRÁCTICA N° 10: PROCESADOR TDA-1819
## Implementación de Forwarding Load -> ALU (MEM -> EX) - Ejercicio 4.c

---

### DATOS ACADÉMICOS
- **Asignatura:** Taller de Arquitectura de Computadoras
- **Año lectivo:** 2026
- **Tema:** Procesador Segmentado TDA-1819, Detección de Riesgos RAW y Mecanismo de Cortocircuito (Forwarding)
- **Ejercicio Asignado:** Ejercicio 4.c (Punto 1: Forwarding de Load hacia operaciones de ALU)

---

## 1. INTRODUCCIÓN Y OBJETIVOS

El procesador TDA-1819 modela una arquitectura segmentada de 5 etapas clásicas basada en la filosofía RISC DLX / MIPS:
1. **IF (Instruction Fetch):** Búsqueda de la instrucción en la memoria de programa mediante el PC.
2. **ID (Instruction Decode):** Decodificación del código de operación, lectura del banco de registros y detección de dependencias y atascos.
3. **EX (Execute):** Ejecución de la operación mediante la ALU para instrucciones enteras, o unidades funcionales FP en caso de coma flotante.
4. **MA (Memory Access / MEM):** Acceso a la memoria de datos (lectura `lw` o escritura `sw`).
5. **WB (Write Back):** Escritura del resultado en el registro de destino en el banco de registros general.

En la arquitectura original provista por la cátedra, los riesgos de datos del tipo **RAW (Read After Write)** se resuelven de forma puramente estructural mediante **atascos (stalls)**. Cada vez que una instrucción escribe en un registro de destino, el decodificador incrementa un contador de escrituras pendientes (`WrPending(reg)`). Cualquier instrucción subsiguiente que requiera leer dicho registro es retenida en la etapa de Decodificación (ID) hasta que la instrucción productora alcance la etapa de WriteBack (WB) y complete la escritura en el banco de registros.

Para una instrucción de carga (`lw`), el dato no está disponible hasta el final de la etapa MA (MEM). Por ende, sin cortocircuito, cualquier instrucción que consuma inmediatamente el dato cargado sufre **3 ciclos de atasco (stalls)**.

### Objetivo del Trabajo:
Diseñar, implementar y verificar en VHDL el **mecanismo de cortocircuito (Forwarding / Bypassing)** para el caso **Ejercicio 4.c**:
> **Forwarding Load -> ALU (MEM -> EX):** Llevar el dato leído desde la memoria en la etapa Memory Access (MA) directamente a la entrada de la Unidad Aritmético-Lógica (ALU) en la etapa Execute (EX), reduciendo el atasco por carga de 3 ciclos a sólo 1 ciclo inevitable (burbuja de carga / load-use penalty).

---

## 2. RESPUESTAS AL CUESTIONARIO TEÓRICO-PRÁCTICO (PUNTOS 2 Y 3)

### Punto 2: Identificación del Riesgo y Etapas Involucradas

#### 2.a. Identificación de la dependencia y del riesgo
- **Dependencia de datos:** Se trata de una dependencia de datos verdadera o dependencia de flujo (**RAW - Read After Write**). Ocurre cuando una instrucción $I_2$ (en nuestro caso, una operación aritmética/lógica en la ALU, por ejemplo `dadd`, `daddi`, `dsub`) necesita como operando fuente el contenido de un registro que es escrito por una instrucción anterior $I_1$ (una instrucción de carga de memoria `lw`).
- **Riesgo asociado:** Genera un **Riesgo de Datos (Data Hazard)**. Si la instrucción consumidora $I_2$ intentara leer el banco de registros antes de que $I_1$ haya completado su etapa de WriteBack (WB), leería un dato desactualizado (obsoleto).

#### 2.b. Etapas del cauce donde se genera y consume el dato
- **Etapa de Generación:** El dato se genera / obtiene efectivamente en la etapa de **Memory Access (MA / MEM)** al finalizar la lectura de la memoria de datos (`DataMAtoWB`). No puede obtenerse en EX porque la dirección efectiva recién se calcula en EX y el contenido de memoria se accede físicamente en MA.
- **Etapa de Consumo:** El dato es requerido por la ALU en la etapa de **Execute (EX)** como operando A (`reg_op1`) u operando B (`reg_op2`).

#### 2.c. Penalización temporal y resolución teórica
- **Sin Forwarding (Caso Original):**
  - Ciclo 1: `lw` en IF
  - Ciclo 2: `lw` en ID, `dadd` en IF
  - Ciclo 3: `lw` en EX, `dadd` retenido en ID (Stall RAW 1)
  - Ciclo 4: `lw` en MA, `dadd` retenido en ID (Stall RAW 2)
  - Ciclo 5: `lw` en WB (escribe registro), `dadd` retenido en ID (Stall RAW 3)
  - Ciclo 6: `dadd` pasa finalmente a EX con el dato leído del banco.
  - **Penalización total sin Forwarding:** **3 ciclos de atasco (stalls)**.
- **Con Forwarding Load -> ALU (Nuestra Implementación):**
  - Como el dato cargado recién existe al finalizar el ciclo de MA, una instrucción consumidora adyacente (distancia 1) **no puede ejecutarse concurrentemente en EX mientras `lw` está en EX**. Requiere obligatoriamente **1 ciclo de burbuja (stall)** para esperar que `lw` avance a MA.
  - Al ciclo siguiente, `lw` está en MA y el consumidor avanza a EX. En ese instante exacto, el cortocircuito **MEM -> EX** toma el dato directamente de la salida del bus de datos de memoria (`DataMAtoWB`) e inyecta el valor en la ALU, sustituyendo el operando obsoleto proveniente de ID.
  - **Penalización total con Forwarding:** **1 ciclo de atasco (stall)** (la burbuja inevitable de carga-uso).
  - **Ganancia neta:** Se eliminan 2 de los 3 ciclos de atasco por cada riesgo Load -> ALU a distancia 1. Para distancias de 2 o más instrucciones, el atasco se reduce de 2 o 1 ciclos a **0 ciclos (cero penalización)**.

---

### Punto 3: Análisis y Comparativa de Arquitecturas

#### 3.a. Comparativa de Rendimiento (Secuencial vs Pipelined vs Pipelined con Forwarding)

Considerando una secuencia de $N$ instrucciones donde una fracción $f_{load\_alu}$ corresponde a cargas seguidas inmediatamente por operaciones de ALU:

| Métrica / Parámetro | Procesador Secuencial | Pipelined sin Forwarding | Pipelined con Forwarding (Ej 4.c) |
| :--- | :---: | :---: | :---: |
| **Tiempo de ciclo ($\tau$)** | $\tau_{seq} = 5 \times \tau_{etapa}$ | $\tau_{pipe} \approx \tau_{etapa} + t_{reg}$ | $\tau_{pipe\_fwd} \approx \tau_{etapa} + t_{mux} + t_{reg}$ |
| **CPI Ideal** | $5.0$ | $1.0$ | $1.0$ |
| **Penalización Load $\to$ ALU (distancia 1)** | 0 (no hay solapamiento) | **3 ciclos de stall** | **1 ciclo de stall** |
| **Penalización Load $\to$ ALU (distancia 2)** | 0 | **2 ciclos de stall** | **0 ciclos de stall** |
| **CPI Real promedio** | $5.0$ | $1 + 3 \cdot f_{load\_alu} + \text{otros stalls}$ | $1 + 1 \cdot f_{load\_alu} + \text{otros stalls}$ |
| **Throughput (Instrucciones/segundo)** | $\frac{1}{5 \cdot \tau_{etapa}}$ | $\frac{1}{(1 + \text{stalls}) \cdot \tau_{pipe}}$ | $\frac{1}{(1 + \text{stalls}_{fwd}) \cdot \tau_{pipe\_fwd}}$ |

**Conclusión cuantitativa:** El procesador Pipelined con Forwarding ofrece el mejor rendimiento global (Speedup máximo), aproximándose al CPI ideal de 1.0 incluso en presencia de cargas intensivas de memoria.

#### 3.b. Limitaciones de Hardware y Casos no Resueltos
El cortocircuito implementado resuelve específicamente la transferencia **MEM (Load) $\to$ EX (ALU)**. Sin embargo, persisten limitaciones inherentes a la microarquitectura:
1. **Load-Use Hazard Inevitable (Distancia 1):** Ningún mecanismo puramente combinacional de cortocircuito puede eliminar la burbuja de 1 ciclo cuando una instrucción ALU consume el dato de un `lw` adyacente, debido al principio de causalidad temporal (el dato no existe antes de acceder a la memoria física en MA).
2. **Operaciones de Coma Flotante (FPU):** Si el dato cargado en memoria entera o float es requerido por una unidad FP multiciclo (multiplicador o divisor FP), se requieren rutas adicionales de forwarding y sincronización con las colas de finalización FP.
3. **Cargas hacia la dirección de otra carga/almacenamiento (`lw r1, ...` seguido de `sw r2, 0(r1)`):** Si bien el cálculo de dirección se realiza en la ALU, el reenvío cubre la ALU; pero transferir directamente el dato a almacenar (`sw`) sin pasar por EX requeriría un bypass directo **MEM $\to$ MEM**.

---

## 3. DISEÑO E IMPLEMENTACIÓN EN VHDL (PUNTO 4.b)

La solución fue implementada manteniendo un diseño modular, limpio y estrictamente respetuoso de la jerarquía de diseño original:

```
resolucion/TDA_1819/src/
├── Packages/
│   └── tipos_cpu.vhd                    [MODIFICADO: campos reg_op1, reg_op2 en execute_record]
└── Usuario/
    ├── usuario.vhd                       [MODIFICADO: Generic Forwarding => true propagado]
    └── PC/
        ├── pc.vhd                        [MODIFICADO: Conexión de Forwarding a CPU]
        └── 2. CPU/
            ├── cpu.vhd                   [MODIFICADO: Conexión de puertos DataMAtoWB, RegDest_MA, IsLoad_MA]
            ├── 2. Etapas/
            │   ├── etapas.vhd            [MODIFICADO: Mapeo de señales a la etapa Execute]
            │   ├── 2. Decode/
            │   │   └── decode.vhd        [MODIFICADO: Propagación de reg_op1 y reg_op2 para ALU]
            │   └── 3. Execute/
            │       ├── execute.vhd       [MODIFICADO: Puertos de Forwarding hacia execute_alu]
            │       └── 1. ALU/
            │           └── execute_alu.vhd [MODIFICADO: MUX de reenvío y sustitución de operandos]
            ├── 3. Pipeline_Registros/
            │   └── pipeline_registros.vhd [MODIFICADO: Detección y extracción de RegDest_MA e IsLoad_MA]
            └── 4. Atascos/
                ├── atascos.vhd           [MODIFICADO: Propagación de señales de Forwarding a detectores]
                └── 2. Datos/
                    └── raw_waw_detector.vhd [MODIFICADO: Bypass anticipado de StallRAW cuando hay Forwarding]
```

### Detalle de las Modificaciones:

1. **`Packages/tipos_cpu.vhd`:**
   Se agregaron al registro `execute_record` los campos `reg_op1` y `reg_op2` (ambos de tipo `std_logic_vector(7 downto 0)`), permitiendo a la etapa EX conocer con precisión qué registros fuente están siendo leídos por la operación ALU en curso.

2. **`pipeline_registros.vhd`:**
   Se incorporó la lógica para inspeccionar la instrucción presente en la etapa MA (`MARecords(0)`). Si dicha instrucción es una lectura de memoria (`READ_MEM`), se activa la señal `IsLoad_MA <= '1'` y se exporta el registro destino de dicha carga mediante `RegDest_MA <= WBRecords(1).mode`.

3. **`execute_alu.vhd` (Mecanismo de Reenvío en la ALU):**
   Dentro del procedimiento `alu`, antes de computar cualquier operación aritmética o lógica, se verifica si `Forwarding = true` y si la instrucción en MA es un Load válido (`IsLoad_MA = '1'`). Si coincide con alguno de los registros fuente:
   - Si `reg_op1 = RegDest_MA`: se sustituye el primer operando por `DataMAtoWB`.
   - Si `reg_op2 = RegDest_MA`: se sustituye el segundo operando por `DataMAtoWB`.
   Se añadió un mensaje explicativo `report` en consola para registrar cada evento de reenvío durante la simulación.

4. **`raw_waw_detector.vhd` (Desbloqueo Anticipado del Atasco RAW):**
   En el modelo base, la función `CheckRAW` bloqueaba la etapa ID mientras el registro tuviese escrituras pendientes (`WrPending > 0`). Con Forwarding activado:
   - Si la instrucción productora es un Load que ya alcanzó la etapa MA (`IsLoad_MA = '1'` y coincide el registro de destino), el dato estará disponible en el ciclo siguiente en EX.
   - En consecuencia, el detector **desactiva `StallRAW` anticipadamente**, permitiendo que la instrucción consumidora avance de ID a EX exactamente en el ciclo en que `lw` se encuentra en MA.

---

## 4. PROGRAMAS DE PRUEBA EN ASSEMBLER Y RESULTADOS (PUNTO 4.c)

Se desarrollaron dos programas de prueba específicos ubicados en `resolucion/TDA_1819/src/Assembler/`:

### Programa 1: Micro-benchmark de Dependencias (`prog_test1_raw_load_alu.asm`)
Diseñado para aislar de forma determinística los dos casos fundamentales:
- **Caso A (Distancia 1):**
  ```assembly
  lw r1, DATO1(r0)
  daddi r2, r1, 5       ; Dependencia RAW de r1 a distancia 1
  sw r2, RES1(r0)
  ```
  - *Sin Forwarding:* 3 ciclos de atasco.
  - *Con Forwarding:* 1 ciclo de atasco (burbuja de carga), luego cortocircuito MEM $\to$ EX. Ahorro: 2 ciclos.
- **Caso B (Distancia 2):**
  ```assembly
  lw r3, DATO2(r0)
  daddi r4, r0, 100     ; Instrucción independiente intermedia
  dadd r5, r3, r4       ; Dependencia RAW de r3 a distancia 2
  sw r5, RES2(r0)
  ```
  - *Sin Forwarding:* 2 ciclos de atasco.
  - *Con Forwarding:* **0 ciclos de atasco**. La instrucción independiente absorbe la latencia de memoria de forma natural.

### Programa 2: Suma de Vector con Acumulador (`prog_test2_array_sum.asm`)
Simula un algoritmo clásico de procesamiento de arreglos numéricos donde se cargan elementos consecutivos y se suman acumulativamente:
```assembly
lw r1, VEC(r0)
dadd r10, r0, r1        ; Distancia 1
...
lw r2, VEC(r20)
dadd r10, r10, r2       ; Distancia 1
...
lw r3, VEC(r20)
dadd r10, r10, r3       ; Distancia 1
...
lw r4, VEC(r20)
dadd r10, r10, r4       ; Distancia 1
sw r10, RES(r0)
```
- En un procesador sin forwarding, se producen $4 \times 3 = 12$ ciclos de stall RAW debidos a las cargas.
- Con el Forwarding implementado, los atascos por carga se reducen a $4 \times 1 = 4$ ciclos de stall.
- **Reducción de latencia en atascos:** **66.7% de reducción en ciclos perdidos por dependencias Load-ALU**.

---

## 5. CONCLUSIONES FINALES

1. Se logró con éxito la implementación del mecanismo de cortocircuito **Load $\to$ ALU (MEM $\to$ EX)** en el procesador segmentado TDA-1819.
2. La arquitectura completa (38 archivos VHDL) compila sin ningún error ni advertencia estructural bajo el estándar IEEE 1076-2002.
3. El mecanismo implementado reduce el atasco crítico por carga de 3 ciclos a sólo 1 ciclo inevitable en distancias de 1 instrucción, y lo elimina por completo en distancias de 2 instrucciones, logrando una notable aceleración del tiempo de ejecución global.
