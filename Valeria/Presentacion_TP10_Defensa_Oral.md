# GUÍA DE PRESENTACIÓN Y DEFENSA ORAL - TP10 (TDA-1819)
## Ejercicio 4.c: Implementación de Forwarding Load -> ALU (MEM -> EX)

---

### ESTRUCTURA DE LA PRESENTACIÓN (Para 4 a 6 integrantes)
Esta guía organiza la exposición oral en 5 diapositivas / bloques temáticos, asignables a cada miembro del grupo.

---

### DIAPOSITIVA 1: INTRODUCCIÓN Y CONTEXTO ARQUITECTÓNICO
- **Expositor sugerido:** Integrante 1 (o Integrantes 1 y 2)
- **Título de la Diapositiva:** El Procesador TDA-1819 y el Problema de los Riesgos RAW
- **Puntos Clave a Explicar:**
  1. **Arquitectura:** Procesador RISC de 5 etapas clásicas: IF (Búsqueda), ID (Decodificación y Registros), EX (Ejecución ALU/FP), MA (Acceso a Memoria) y WB (Escritura en Registros).
  2. **El Problema en el diseño original:** La CPU resuelve dependencias RAW mediante atascos (stalls) en la etapa ID utilizando un contador `WrPending`.
  3. **Penalización del Load:** Para una instrucción de carga (`lw`), el dato no existe hasta el final de MA. Cualquier operación posterior que use ese registro sufre **3 ciclos de atasco**.
  4. **Objetivo del Ejercicio 4.c:** Diseñar un camino de cortocircuito (Forwarding) desde la salida de MA (`DataMAtoWB`) hacia la ALU en EX, para no tener que esperar a WriteBack.

---

### DIAPOSITIVA 2: IDENTIFICACIÓN DEL RIESGO Y CASO TEMPORAL (PUNTO 2)
- **Expositor sugerido:** Integrante 2
- **Título de la Diapositiva:** Dependencia RAW Load -> ALU y Cronograma Temporal
- **Puntos Clave a Explicar:**
  1. **Dependencia Verdadera (RAW):** Una instrucción ALU (`dadd r2, r1, r0`) necesita el dato que `lw r1, ...` acaba de solicitar a la memoria.
  2. **Etapas Involucradas:**
     - Generación del dato: Etapa **MA (Memory Access)**.
     - Consumo del dato: Etapa **EX (Execute - ALU)**.
  3. **Cronograma con y sin Forwarding:**
     - *Sin Forwarding (Distancia 1):* 3 burbujas en ID (ciclos 3, 4 y 5). ALU ejecuta en ciclo 6 tras WB.
     - *Con Forwarding (Distancia 1):* 1 ciclo de atasco inevitable (burbuja de carga en ciclo 3 mientras `lw` está en EX). En ciclo 4, `lw` está en MA y la ALU ejecuta en EX con el dato reenviado por el bypass. Ahorro: 2 ciclos.
     - *Distancia 2:* Atasco pasa de 2 ciclos a **0 ciclos (cero espera)**.

---

### DIAPOSITIVA 3: DISEÑO E IMPLEMENTACIÓN EN VHDL (PUNTO 4.b)
- **Expositor sugerido:** Integrante 3 (o Integrantes 3 y 4)
- **Título de la Diapositiva:** Modificaciones Microarquitectónicas en VHDL
- **Puntos Clave a Explicar:**
  1. **Identificación de Operandos (`tipos_cpu.vhd` y `decode.vhd`):**
     - Se agregaron `reg_op1` y `reg_op2` a `execute_record`.
     - En `decode.vhd`, se guardan los identificadores de registros leídos para cada operación ALU.
  2. **Extracción del Registro Destino en MA (`pipeline_registros.vhd`):**
     - Se inspecciona `MARecords(0)` para verificar si es un Load (`READ_MEM`).
     - Se exportan `IsLoad_MA` y `RegDest_MA` (desde `WBRecords(1).mode`).
  3. **Multiplexor de Reenvío en la ALU (`execute_alu.vhd`):**
     - Dentro del procedimiento `alu`, si `Forwarding = true` e `IsLoad_MA = '1'`, se compara `reg_op1` y `reg_op2` con `RegDest_MA`. Si coinciden, se reemplaza el operando por `DataMAtoWB`.
  4. **Bypass del Detector de Atascos (`raw_waw_detector.vhd`):**
     - Al detectar que el Load llegó a MA y que Forwarding está activo, se desbloquea `StallRAW` un ciclo antes, permitiendo que la ALU avance a EX justo a tiempo.

---

### DIAPOSITIVA 4: PROGRAMAS DE PRUEBA EN ASSEMBLER Y RESULTADOS (PUNTO 4.c)
- **Expositor sugerido:** Integrante 4 (o Integrante 5)
- **Título de la Diapositiva:** Verificación Experimental y Validación de Tiempos
- **Puntos Clave a Explicar:**
  1. **Programa 1 (`prog_test1_raw_load_alu.asm`):**
     - Demuestra empíricamente el caso de Distancia 1 (1 stall vs 3 stalls) y el de Distancia 2 (0 stalls vs 2 stalls).
     - Validación de resultados numéricos en memoria de datos (`sw`).
  2. **Programa 2 (`prog_test2_array_sum.asm`):**
     - Suma de 4 elementos vectoriales con cargas continuas y acumulación inmediata en la ALU.
     - *Sin Forwarding:* 12 ciclos perdidos en atascos RAW.
     - *Con Forwarding:* 4 ciclos perdidos en atascos.
     - *Ahorro neto:* 8 ciclos (**reducción del 66.7% en penalizaciones**).

---

### DIAPOSITIVA 5: COMPARATIVA ARQUITECTÓNICA Y CONCLUSIONES (PUNTOS 3.a, 3.b Y CONCLUSIÓN)
- **Expositor sugerido:** Integrante 5 (o Integrante 6)
- **Título de la Diapositiva:** Métricas de Rendimiento, Limitaciones y Conclusiones
- **Puntos Clave a Explicar:**
  1. **Comparativa Secuencial vs Pipelined vs Forwarding:**
     - El procesador con Forwarding se aproxima al CPI ideal de 1.0, manteniendo el período de ciclo bajo ($\tau_{etapa} + t_{mux}$).
  2. **Limitaciones Físicas Inevitables:**
     - Imposibilidad de eliminar la burbuja de carga a distancia 1 debido a la causalidad temporal de la memoria (el dato no existe antes de MA).
     - Solución complementaria por compilador: *Instruction Scheduling* (reordenar instrucciones independientes para llenar la ranura de retardo de carga).
  3. **Conclusión Final:**
     - Implementación modular, robusta y completamente verificada con 0 errores de compilación sobre la totalidad del código VHDL del TDA-1819.
