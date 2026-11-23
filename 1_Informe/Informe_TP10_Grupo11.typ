// TP10 — Procesador TDA 1819: adelantamiento load -> ALU (escenario 4c)
// Taller de Arquitectura 2026 · Grupo 11

#let ink = rgb("#1F2937")
#let muted = rgb("#64748B")
#let accent = rgb("#2563EB")
#let accent-soft = rgb("#EFF6FF")
#let accent-border = rgb("#BFDBFE")
#let stall-bg = rgb("#F6E2D3")
#let stall-ink = rgb("#8C421C")
#let rule-col = rgb("#E2E8F0")
#let header-bg = rgb("#F8FAFC")
#let code-bg = rgb("#F8FAFC")

#set document(
  title: "TP10 — Procesador TDA 1819: adelantamiento load → ALU (escenario 4c)",
  author: "Grupo 11 — Taller de Arquitectura 2026",
)

#set page(
  paper: "a4",
  margin: (top: 2.0cm, bottom: 1.95cm, left: 2.0cm, right: 2.0cm),
  header: context {
    if counter(page).get().first() > 1 {
      set text(size: 8.5pt, fill: muted)
      grid(
        columns: (1fr, auto),
        [TP10 · Procesador TDA 1819 — Adelantamiento load → ALU (escenario 4c)],
        [Taller de Arquitectura 2026],
      )
      v(-6pt)
      line(length: 100%, stroke: 0.5pt + rule-col)
    }
  },
  footer: context {
    if counter(page).get().first() > 1 {
      line(length: 100%, stroke: 0.5pt + rule-col)
      v(-4pt)
      set text(size: 8.5pt, fill: muted)
      grid(
        columns: (1fr, auto),
        [Grupo 11 · Noviembre de 2026],
        [Página #counter(page).display("1 de 1", both: true)],
      )
    }
  },
)

#set text(
  font: ("Segoe UI", "Arial"),
  size: 10pt,
  fill: ink,
  lang: "es",
)

#set par(
  justify: true,
  leading: 0.62em,
  spacing: 0.8em,
)

#set list(indent: 1em, body-indent: 0.5em, spacing: 0.42em)
#set enum(indent: 1em, body-indent: 0.5em, spacing: 0.42em)

// Inline code
#show raw.where(block: false): it => box(
  fill: rgb("#F1F5F9"),
  inset: (x: 3pt, y: 1pt),
  outset: (y: 1.5pt),
  radius: 2.5pt,
  text(font: ("Consolas", "Courier New"), size: 8.6pt, fill: rgb("#0F172A"), it),
)

// Code blocks
#show raw.where(block: true): it => block(
  width: 100%,
  fill: code-bg,
  stroke: (left: 2.5pt + accent, rest: 0.6pt + rule-col),
  inset: (x: 11pt, y: 8.5pt),
  radius: (right: 4pt),
  breakable: false,
  text(font: ("Consolas", "Courier New"), size: 8.2pt, fill: rgb("#0F172A"), it),
)

// Headings
#show heading.where(level: 1): it => {
  v(14pt, weak: true)
  block(breakable: false, sticky: true)[
    #text(size: 13pt, weight: "bold", fill: ink, it.body)
    #v(-5pt)
    #line(length: 100%, stroke: 0.8pt + rule-col)
    #v(4pt)
  ]
}

#show heading.where(level: 2): it => {
  v(10pt, weak: true)
  block(breakable: false, sticky: true)[
    #text(size: 10.8pt, weight: "bold", fill: rgb("#1E3A8A"), it.body)
    #v(2pt)
  ]
}

// Figures
#show figure.caption: it => {
  set text(size: 8.8pt, fill: muted, style: "italic")
  v(3pt)
  it
}
#set figure(supplement: [Figura])

// Reusable clean table helper
#let nice-table(columns: auto, align: left, font-size: 9pt, ..args) = {
  set text(size: font-size)
  set par(justify: false, leading: 0.52em)
  table(
    columns: columns,
    align: align,
    inset: (x: 7pt, y: 5.5pt),
    stroke: (x, y) => (
      top: if y == 0 { 1.1pt + ink } else if y == 1 { 0.8pt + rgb("#94A3B8") } else { 0.45pt + rule-col },
      bottom: 0.45pt + rule-col,
      left: none,
      right: none,
    ),
    fill: (_, y) => if y == 0 { header-bg } else { none },
    ..args,
  )
}

// Helper for pipeline trace cells (Section 8.2)
#let pc(val) = {
  if val == "Dr" {
    table.cell(fill: stall-bg, align: center, text(weight: "bold", fill: stall-ink, "Dr"))
  } else if val == "X*" {
    table.cell(fill: rgb("#DBEAFE"), align: center, text(weight: "bold", fill: rgb("#1D4ED8"), "X*"))
  } else if val == "Db" or val == "De" {
    table.cell(fill: rgb("#F1F5F9"), align: center, text(fill: muted, val))
  } else {
    table.cell(align: center, val)
  }
}

// ============================================================================
// PORTADA / ENCABEZADO DEL INFORME
// ============================================================================
#block(
  width: 100%,
  inset: (bottom: 12pt),
  stroke: (bottom: 2pt + accent),
)[
  #set par(justify: false)
  #text(size: 9pt, weight: "semibold", fill: accent, tracking: 0.8pt)[
    TALLER DE ARQUITECTURA 2026 · TRABAJO PRÁCTICO 10
  ]
  #v(4pt)
  #text(size: 17.5pt, weight: "bold", fill: rgb("#0F172A"), hyphenate: false)[
    Procesador TDA 1819: adelantamiento load → ALU (escenario 4c)
  ]
  #v(4pt)
  #text(size: 10pt, fill: muted)[
    Grupo 11 · Noviembre de 2026
  ]
]

#v(8pt)

#nice-table(
  columns: (90pt, 1fr),
  font-size: 9.2pt,
  table.header([*Legajo*], [*Integrante*]),
  [03846/1], [Burgueño, Martín Andrés],
  [03861/9], [Dufur, Lázaro],
  [01592/9], [Graziani, Tomas Fermin Pablo],
  [03209/5], [Jauregui Lorda, Valeria],
  [02224/9], [Pernalete Perez, Jose Miguel],
  [03923/6], [Shimizu, Agustín],
)

#v(8pt)

#block(
  width: 100%,
  fill: accent-soft,
  stroke: (left: 3pt + accent, rest: 0.5pt + accent-border),
  inset: (x: 12pt, y: 10pt),
  radius: (right: 4pt),
)[
  *Resumen.* Se incorporó al TDA 1819 el adelantamiento (_forwarding_) del dato leído por un `load` en _Memory Access_ hacia la ALU de una instrucción aritmético-lógica posterior. El mecanismo se habilita mediante el nuevo parámetro genérico `Forwarding`. Con él, el atasco `load → ALU` baja de 2 a 1 ciclo cuando las instrucciones son consecutivas y de 1 a 0 con una instrucción intermedia; los tres programas de prueba ejecutan entre 4 y 5 ciclos menos sin cambiar ningún resultado. Todos los tiempos y resultados se verificaron en Active-HDL 17, el simulador de la cátedra.
]

// ============================================================================
// 1. CONSIGNA Y ALCANCE
// ============================================================================
= 1. Consigna y alcance

Al grupo le tocó el escenario 4c del ejercicio 4: un `load` lee un dato de la sección de datos en _Memory Access_ y una instrucción aritmético-lógica lo necesita como operando de la ALU en _Execute_. El objetivo es que ese dato llegue a la ALU desde el registro de segmentación `MEM/WB`, sin esperar a que _Writeback_ lo escriba en el banco de registros.

#nice-table(
  columns: (88pt, 1fr),
  font-size: 9pt,
  table.header([*Elemento*], [*Incluido en el mecanismo*]),
  [*Productor*], [`lb`, `lh` y `lw` que leen la sección de datos y escriben un registro `R0`–`R15`],
  [*Consumidor*], [Instrucciones aritmético-lógicas enteras que usan la ALU: `dadd`, `daddi`, `daddu`, `daddui`, `dsub`, `dsubi`, `dsubu`, `dmul`, `dmulu`, `ddiv`, `ddivu`, `slt`, `slti`, `negr`, `andr`, `andi`, `orr`, `ori`, `xorr`, `xori`, `xnorr`, `notr`, `dsl`, `dsli`, `dsr`, `dsri`, `dsls`, `dslsi`, `dsrs`, `dsrsi`],
  [*Operandos*], [El primero, el segundo o ambos (por ejemplo `dadd r2, r1, r1`)],
  [*Control*], [Parámetro genérico `Forwarding` en el banco de pruebas `usuario.vhd`; sólo tiene efecto con `Pipelining = true`],
)

Quedan afuera, porque corresponden a otros escenarios o a otras unidades:
- _Store_ como consumidor (4b y 4d) y saltos condicionales (`beqz`, `bnez`, `beq`, `bne`), que siguen esperándose como antes.
- Productores aritmético-lógicos (4a y 4b): su resultado no se adelanta.
- `lf`, `poph` y los `lh`/`lw` que leen la pila (base `SP`), porque no leen la sección de datos o escriben registros de punto flotante.
- Instrucciones de la FPU, que tienen su propio cauce de 4 ciclos en _Execute_.

// ============================================================================
// 2. CÓMO RESUELVE HOY EL TDA 1819 UNA DEPENDENCIA RAW
// ============================================================================
= 2. Cómo resuelve hoy el TDA 1819 una dependencia RAW

El procesador original detecta la dependencia en _Decode_ y detiene _Fetch_ y _Decode_ hasta que el productor pasa por _Writeback_. Un `load` seguido de una aritmético-lógica que usa su destino pierde 2 ciclos; con una instrucción en el medio pierde 1.

Dentro de cada ciclo de 100 ns, el administrador de la CPU (`cpu_admin.vhd`) habilita todas las etapas a la vez y las tareas quedan escalonadas así:

#nice-table(
  columns: (92pt, 1fr),
  font-size: 9pt,
  table.header([*Momento del ciclo*], [*Qué ocurre*]),
  [*0 ns*], [Flanco de `CLK`: arrancan las cinco etapas; _Writeback_ descuenta su escritura pendiente en el detector RAW],
  [*25 ns*], [_Writeback_ escribe el banco de registros (primera mitad del ciclo, señal `CLK_HALF`)],
  [*50 ns*], [Segunda mitad: _Decode_ lee los operandos del banco, _Execute_ opera en la ALU, _Memory Access_ lee o escribe la memoria de datos, _Fetch_ busca la instrucción],
  [*70 ns*], [Se cargan los registros de segmentación (`EnablePDA_ID`, `EnablePDA_EX`, `EnablePDA_MA`)],
)

El detector de dependencias de datos (`raw_waw_detector.vhd`) lleva un contador de escrituras pendientes por registro:

+ Al comienzo del ciclo siguiente a la decodificación de una instrucción que escribe un registro, _Decode_ incrementa el contador de ese registro (`IncWrPending`).
+ Cada vez que _Decode_ lee un operando, el detector consulta el contador (`CheckRAW`). Si es mayor que cero activa `StallRAW` y recuerda el registro en conflicto (`IdRegRAW`).
+ Con `StallRAW` activo, _Fetch_ y _Decode_ se quedan esperando; _Decode_ reintenta la misma instrucción cuando `StallRAW` cae.
+ Al comienzo de su _Writeback_, el productor decrementa el contador (`DecWrPending`). Si era la última escritura pendiente del registro en conflicto, baja `StallRAW`. _Decode_ vuelve a leer en la segunda mitad de ese mismo ciclo, cuando el dato ya fue escrito a los 25 ns.

#figure(
  image("img/image1.png", width: 100%),
  caption: [Comparación de la dependencia RAW en `lw r1, A(r0)` seguido de `dadd r4, r4, r1`, sin adelantamiento (2 ciclos de atasco) y con adelantamiento `MEM/WB → ALU` (1 ciclo de atasco).],
)

Para un `lw` seguido de un `dadd` que usa su destino: el `dadd` lee en el ciclo en que el `lw` está en _Execute_ y se atasca. El `lw` pasa por _Memory Access_ sin liberar nada, y recién en su _Writeback_ el `dadd` puede decodificarse. Son 2 ciclos perdidos, aunque el dato ya estaba leído de memoria un ciclo antes. Ese ciclo es el que recupera el adelantamiento.

// ============================================================================
// 3. DISEÑO DEL ADELANTAMIENTO
// ============================================================================
= 3. Diseño del adelantamiento

El dato que lee el `load` queda en el registro de segmentación `MEM/WB` al final de su _Memory Access_. Un multiplexor a la entrada de la ALU lo toma de ahí en el ciclo siguiente, el mismo en que el `load` hace _Writeback_. Así la aritmético-lógica puede ejecutar un ciclo antes que en el procesador original.

#figure(
  image("img/image2.png", width: 96%),
  caption: [Cauce del TDA 1819 con el camino de adelantamiento `MEM/WB → ALU` y sus señales de control.],
)

El camino en color sale del registro `MEM/WB` y entra por un multiplexor delante de la ALU. Las cuatro señales verticales permiten que el detector decida, ciclo a ciclo, si un operando se adelanta o si la instrucción se atasca.

El mecanismo tiene cuatro piezas, una por componente:

+ *Registros de segmentación (`pipeline_registros.vhd`).* Cuando una instrucción entra a _Memory Access_, si es un `load` adelantable informa su registro destino al detector por la nueva salida `IdRegFwdMA` (número de registro + 1, o 0 si no hay).
+ *Detector RAW (`raw_waw_detector.vhd`).* Al comienzo de cada ciclo (flanco de `EnableMA`) guarda ese registro en `FwdRegMA` (procedimiento `ForwardMA`). Si hay un atasco RAW vigente, causado por una aritmético-lógica, justamente por ese registro, y es su única escritura pendiente, baja `StallRAW`. Cuando _Decode_ lee un operando, `CanForwardRAW` decide si se adelanta: en ese caso no atasca y activa `FwdRAW`.
+ *Decode (`decode.vhd`).* Avisa al detector con `FwdEnableID` si la instrucción es aritmético-lógica. Después de cada lectura de operando, si `FwdRAW` vale 1 marca el operando en el registro `ID/EX`: campos `fwd1` o `fwd2` y `fwdreg`.
+ *Execute (`execute.vhd`).* El procedimiento `ForwardOperands` es el multiplexor: reemplaza `op1` u `op2` por el dato de `MEM/WB` (`RecInWB.data.memaccess`), extendido con ceros a 32 bits igual que lo escribiría _Writeback_. Antes verifica que `MEM/WB` contenga el `load` esperado y deja un mensaje en la consola por cada adelantamiento.

Un operando se adelanta sólo si se cumplen todas estas condiciones:
- `Forwarding = true` y `Pipelining = true`.
- La instrucción en _Decode_ es aritmético-lógica entera (`FwdEnableID`).
- El registro leído es `R0`–`R15` y es el destino del `load` que está en _Memory Access_ en ese ciclo.
- Ese registro tiene una sola escritura pendiente. Si hubiera dos, por ejemplo dos `loads` seguidos al mismo registro, el valor correcto es el del más nuevo, y se espera como antes.
- La FPU no tiene operaciones en curso (`EXFPUPending = 0`). Sus atascos estructurales y WAW pueden demorar el _Execute_ de la instrucción dependiente, y para no depender de eso se mantiene el comportamiento original.

Efecto sobre el atraso de una aritmético-lógica que usa el destino de un `load`:

#nice-table(
  columns: (1fr, 130pt, 130pt),
  align: (left, center, center),
  font-size: 9pt,
  table.header(
    [*Distancia entre el `load` y su uso*],
    [*Atasco sin adelantamiento*],
    [*Atasco con adelantamiento*],
  ),
  [Instrucciones consecutivas], [2 ciclos], [*1 ciclo*],
  [Una instrucción en el medio], [1 ciclo], [*0 ciclos*],
  [Dos o más instrucciones en el medio], [0 ciclos], [0 ciclos],
)

El ciclo que queda en el caso consecutivo es inevitable: el dato recién sale de la memoria hacia los 52 ns del _Memory Access_ del `load`, después de que la ALU de ese mismo ciclo arrancó a los 50 ns. Es el mismo atasco _load-use_ que tiene el MIPS64 con adelantamiento.

// ============================================================================
// 4. IMPLEMENTACIÓN: ARCHIVOS MODIFICADOS
// ============================================================================
= 4. Implementación: archivos modificados

Se modificaron 12 archivos `.vhd` existentes y no se agregó ninguno, así que el orden de compilación del proyecto no cambia. Cada cambio está marcado en el código con el comentario `TP10` y documentado en el encabezado de su archivo. Las rutas son relativas a la carpeta del diseño `TDA_1819` dentro del workspace (`My_Designs/TDA_1819/TDA_1819/`).

#nice-table(
  columns: (122pt, 138pt, 1fr),
  font-size: 8.4pt,
  table.header([*Archivo*], [*Ruta dentro del proyecto*], [*Cambio*]),
  [`usuario.vhd`], [`src/Usuario/`], [Nuevo genérico `Forwarding` (por defecto `true`); mensaje inicial con la configuración; programa por defecto `fwd_suma.asm`],
  [`pc.vhd`], [`src/Usuario/PC/`], [Recibe `Forwarding` y lo pasa a la CPU],
  [`cpu.vhd`], [`src/Usuario/PC/2. CPU/`], [Genérico `Forwarding`; señales nuevas `IdRegFwdMA`, `FwdRAW`, `FwdEnableID`, `EXFPUPendingFwd`; `EnableMA` conectada al detector],
  [`tipos_cpu.vhd`], [`src/Packages/`], [Campos `fwd1`, `fwd2` y `fwdreg` en el registro `ID/EX` (`execute_record`)],
  [`decode.vhd`], [`src/Usuario/PC/2. CPU/2. Etapas/2. Decode/`], [Función `IsALUInst`, salida `FwdEnableID`, entrada `FwdRAW` y marca de operandos adelantados en las 30 instrucciones aritmético-lógicas],
  [`execute.vhd`], [`src/Usuario/PC/2. CPU/2. Etapas/3. Execute/`], [Entrada `RecInWB` (`MEM/WB`) y procedimiento `ForwardOperands`: el multiplexor de la ALU],
  [`etapas.vhd`], [`src/Usuario/PC/2. CPU/2. Etapas/`], [Conexiones nuevas de _Decode_ y _Execute_; exporta `EXFPUPending`],
  [`pipeline_registros.vhd`], [`src/Usuario/PC/2. CPU/3. Pipeline_Registros/`], [Salida `IdRegFwdMA`: destino del `load` adelantable que entra a _Memory Access_],
  [`atascos.vhd`], [`src/Usuario/PC/2. CPU/4. Atascos/`], [Genérico `Forwarding` y paso de las señales al detector RAW],
  [`raw_waw_detector.vhd`], [`src/Usuario/PC/2. CPU/4. Atascos/2. Datos/`], [`GetRWrPending`, `CanForwardRAW`, `ForwardMA`; `CheckRAW` ya no atasca cuando se puede adelantar],
  [`fetch.vhd`], [`src/Usuario/PC/2. CPU/2. Etapas/1. Fetch/`], [Corrección adicional (sección 5): no busca mientras siga habiendo un atasco RAW],
  [`states_machine.vhd`], [`src/Usuario/PC/2. CPU/1. UI/1. Máquina de Estados/`], [Corrección adicional (sección 5): muestra bien el doble atasco RAW],
)

Con `Forwarding = false`, las piezas nuevas quedan inactivas: el detector ni siquiera reacciona a `EnableMA`. Con ese valor el procesador funciona como el original, más la corrección de la sección 5.

// ============================================================================
// 5. CORRECCIÓN ADICIONAL: DOBLE ATASCO RAW
// ============================================================================
= 5. Corrección adicional: doble atasco RAW

Al probar el procesador sin adelantamiento apareció un error. Cuando una instrucción con dos operandos de registro sufre dos atascos RAW seguidos (uno por cada operando), la instrucción siguiente nunca se ejecuta. Ocurre sólo con el cauce activado; sin cauce los resultados son correctos.

#nice-table(
  columns: (138pt, 108pt, 1fr),
  font-size: 8.6pt,
  table.header([*Programa*], [*Instrucción perdida*], [*Efecto medido en Active-HDL (cauce, sin adelantamiento)*]),
  [`lw r1` / `lw r2` / `dadd r3, r1, r2` / `daddi r4, r0, 9` (prueba mínima)], [`daddi r4, r0, 9`], [`R4` queda en 0 en lugar de 9; termina a los 1200 ns en lugar de 1300],
  [`fwd_prodesc.asm` sin adelantamiento], [`dadd r4, r4, r6` en cada iteración], [`PROD = 0` en lugar de 46; termina a los 5900 ns en lugar de 7100],
  [`prog_prueba.asm`], [`bnez r3, SEGUIR`], [No cambia los registros porque el salto no se toma, pero ejecuta una instrucción menos: termina a los 4700 ns en lugar de 5100],
)

*Causa.* En `fetch.vhd`, cuando termina un atasco RAW la búsqueda espera el próximo flanco de `EnableIF` y sigue, sin volver a mirar si mientras tanto empezó otro atasco. El segundo atasco lo provoca el segundo operando de la misma instrucción: se activa a los 52 ns del ciclo en que _Decode_ reintenta. _Fetch_ busca entonces una instrucción nueva y pisa la que estaba esperando en `IF/ID` sin haber sido decodificada.

*Corrección.* Después de esa espera, _Fetch_ repite la espera mientras `StallRAW` siga activo (un lazo `while` de 4 líneas). Es un cambio de control: no altera ningún tiempo cuando no hay doble atasco.

*Visualización.* La máquina de estados de la interfaz (`states_machine.vhd`), en el estado `D_RAW`, consultaba `StallRAW` a los 50 ns, antes de la lectura del segundo operando. Por eso mostraba la instrucción como decodificada y desfasaba los estados siguientes (aparecían secuencias como `W W W W`). Ahora espera 15 ns más antes de consultar. Es sólo visual: no cambia ningún tiempo ni resultado.

*Impacto.* Con las dos correcciones, la prueba mínima deja `R4 = 9`, `fwd_prodesc` sin adelantamiento vuelve a dar `PROD = 46` y `prog_prueba` vuelve a ejecutar el `bnez`. Las tres comparaciones, con y sin la corrección, se midieron en Active-HDL (sección 9). La corrección se aplica con y sin adelantamiento: el adelantamiento hace menos frecuente el doble atasco, pero no lo elimina (por ejemplo, un operando producido por una aritmético-lógica y el otro por un `load`).

// ============================================================================
// 6. PROGRAMAS DE PRUEBA (PUNTO 2)
// ============================================================================
= 6. Programas de prueba (punto 2)

Se escribieron tres programas que varían sólo la distancia entre cada `load` y su uso. Cada uno se corre con el adelantamiento activado y desactivado, así el contraste lo da el mismo programa. Van en la carpeta `src/Assembler/` del proyecto y se eligen con el genérico `ProgName` de `usuario.vhd`.

#nice-table(
  columns: (96pt, 108pt, 118pt, 1fr),
  font-size: 8.5pt,
  table.header([*Programa*], [*Qué calcula*], [*Dependencia `load → ALU`*], [*Qué muestra*]),
  [`fwd_suma.asm`], [Suma de un vector de 5 enteros: `SUMA = 30`], [`lw r1` seguido de `dadd r4, r4, r1`], [Caso consecutivo: el atasco baja de 2 ciclos a 1 en cada iteración],
  [`fwd_suma_reord.asm`], [La misma suma con una instrucción reordenada: `SUMA = 30`], [`lw r1`, luego `daddi r2` y recién después `dadd r4, r4, r1`], [Distancia 2: con adelantamiento no queda ningún atasco `load → ALU`],
  [`fwd_prodesc.asm`], [Producto escalar de dos vectores de 4 enteros: `PROD = 46`], [`lw r1` y `lw r5` alimentan `dmul r6, r1, r5`], [Dos `loads` seguidos: sin adelantamiento hay doble atasco (y dispara el bug de la sección 5); con adelantamiento queda uno solo],
)

Los tres incluyen dependencias que el escenario 4c no cubre, y que por eso se atascan igual en ambos modos: `daddi r3 → bnez r3` (aritmético-lógica → salto), `daddi r2 → lw r1, TABLA(r2)` (aritmético-lógica → dirección del `load`) y, en `fwd_prodesc`, `dmul r6 → dadd r4, r4, r6` (aritmético-lógica → aritmético-lógica). Sirven de control: muestran que el mecanismo sólo actúa donde corresponde.

#block(breakable: false)[
  *`fwd_suma.asm`*
  ```asm
          .data
  TABLA:  .word   3, 8, 1, 12, 6     ; vector de 5 enteros
  N:      .word   5                  ; cantidad de elementos
  SUMA:   .word   0                  ; resultado
          .code
          lw r3, N(r0)               ; r3 = contador de elementos
          daddi r2, r0, 0            ; r2 = desplazamiento en TABLA
          daddi r4, r0, 0            ; r4 = suma parcial
  LAZO:   lw r1, TABLA(r2)           ; r1 = TABLA[i] (load)
          dadd r4, r4, r1            ; RAW load->ALU inmediata
          daddi r2, r2, 4            ; siguiente elemento
          daddi r3, r3, -1           ; un elemento menos
          bnez r3, LAZO              ; repetir si quedan
          sw r4, SUMA(r0)            ; guardar la suma
          halt
  ```
]

#block(breakable: false)[
  *`fwd_suma_reord.asm`* (sólo cambia el orden dentro del lazo)
  ```asm
  LAZO:   lw r1, TABLA(r2)           ; r1 = TABLA[i] (load)
          daddi r2, r2, 4            ; independiente: separa load y uso
          dadd r4, r4, r1            ; RAW load->ALU a distancia 2
          daddi r3, r3, -1           ; un elemento menos
          bnez r3, LAZO              ; repetir si quedan
  ```
]

#block(breakable: false)[
  *`fwd_prodesc.asm`*
  ```asm
          .data
  VA:     .word   2, 5, 3, 4         ; primer vector
  VB:     .word   6, 1, 7, 2         ; segundo vector
  N:      .word   4                  ; cantidad de elementos
  PROD:   .word   0                  ; resultado
          .code
          lw r3, N(r0)               ; r3 = contador de elementos
          daddi r2, r0, 0            ; r2 = desplazamiento en VA y VB
          daddi r4, r0, 0            ; r4 = producto escalar parcial
  LAZO:   lw r1, VA(r2)              ; r1 = VA[i] (load)
          lw r5, VB(r2)              ; r5 = VB[i] (load)
          dmul r6, r1, r5            ; ambos operandos vienen de loads
          dadd r4, r4, r6            ; acumular VA[i]*VB[i]
          daddi r2, r2, 4            ; siguiente elemento
          daddi r3, r3, -1           ; un elemento menos
          bnez r3, LAZO              ; repetir si quedan
          sw r4, PROD(r0)            ; guardar el resultado
          halt
  ```
]

// ============================================================================
// 7. TIEMPOS DE ENSAMBLAJE Y EJECUCIÓN (PUNTO 3A)
// ============================================================================
= 7. Tiempos de ensamblaje y ejecución (punto 3a)

Con el cauce activado, el adelantamiento ahorra 5 ciclos en las dos sumas (uno por iteración) y 4 en el producto escalar. Sin cauce no cambia nada, porque no hay atascos que evitar. Reordenar el lazo y adelantar se suman: `fwd_suma` pasa de 64 ciclos sin adelantamiento a 54 en la versión reordenada con adelantamiento.

Cómo se mide (período de reloj 100 ns, constante `PERIODO` de `const_reloj.vhd`):
- *Tiempo de ensamblaje:* instante en que el banco de pruebas informa que el programa fue ensamblado, medido desde 0 ns. No depende del cauce ni del adelantamiento.
- *Inicio de la ejecución:* primer flanco de reloj habilitado después del ensamblaje, es decir el siguiente múltiplo de 100 ns (200 ns en los tres programas).
- *Fin de la ejecución:* instante del mensaje «ha sido ejecutado exitosamente» en la consola.
- *Tiempo de ejecución:* $"fin" - "inicio"$. Los ciclos son ese tiempo dividido 100 ns, y el CPI es ciclos dividido instrucciones ejecutadas (30, 30 y 33; no se cuentan las instrucciones buscadas y anuladas tras un salto tomado).

#nice-table(
  columns: (88pt, 1fr, 56pt, 56pt, 58pt, 42pt, 38pt),
  align: (left, left, right, right, right, right, right),
  font-size: 8.5pt,
  table.header(
    [*Programa*], [*Configuración*], [*Ensamb. (ns)*], [*Fin (ns)*], [*Ejec. (ns)*], [*Ciclos*], [*CPI*],
  ),
  [`fwd_suma`], [Sin cauce], [127], [15200], [15000], [150], [5,00],
  [`fwd_suma`], [Cauce, sin adelantamiento], [127], [6600], [6400], [64], [2,13],
  [`fwd_suma`], [*Cauce, con adelantamiento*], [127], [*6100*], [*5900*], [*59*], [*1,97*],
  [`fwd_suma_reord`], [Sin cauce], [127], [15200], [15000], [150], [5,00],
  [`fwd_suma_reord`], [Cauce, sin adelantamiento], [127], [6100], [5900], [59], [1,97],
  [`fwd_suma_reord`], [*Cauce, con adelantamiento*], [127], [*5600*], [*5400*], [*54*], [*1,80*],
  [`fwd_prodesc`], [Sin cauce], [157], [16700], [16500], [165], [5,00],
  [`fwd_prodesc`], [Cauce, sin adelantamiento], [157], [7100], [6900], [69], [2,09],
  [`fwd_prodesc`], [*Cauce, con adelantamiento*], [157], [*6700*], [*6500*], [*65*], [*1,97*],
)

Los nueve tiempos de la tabla se midieron en Active-HDL 17 Student Edition (sección 9). El tiempo de ensamblaje crece con la cantidad de líneas y datos del programa: `fwd_prodesc` tiene un vector más que las sumas.

En `fwd_prodesc` se ganan 4 ciclos y no 8 aunque hay dos `loads` por iteración. Cuando `dmul` se reintenta, el `lw r1` ya está en _Writeback_ y su dato se lee del banco de registros; sólo `r5` llega por adelantamiento.

== 7.1 ¿Son razonables los tiempos?

Sí: cada ciclo medido tiene una causa identificable. Sin cauce, cada instrucción ocupa exactamente 5 ciclos: $30 times 5 = 150$ en las dos sumas y $33 times 5 = 165$ en el producto escalar, lo mismo que se midió. Con cauce, lo ideal sería terminar una instrucción por ciclo más 4 ciclos de llenado (lo que tarda la primera en llegar a _Writeback_). La diferencia con lo medido son atascos, y se pueden contar uno por uno en el diagrama de estados de la simulación:

#nice-table(
  columns: (1fr, 44pt, 44pt, 48pt, 48pt, 46pt, 46pt),
  align: (left, right, right, right, right, right, right),
  font-size: 8.1pt,
  table.header(
    [*Concepto (ciclos)*],
    [*`suma`\ sin fwd*],
    [*`suma`\ con fwd*],
    [*`reord`\ sin fwd*],
    [*`reord`\ con fwd*],
    [*`prodesc`\ sin fwd*],
    [*`prodesc`\ con fwd*],
  ),
  [Instrucciones ejecutadas], [30], [30], [30], [30], [33], [33],
  [Llenado del cauce], [4], [4], [4], [4], [4], [4],
  [*`Load → ALU` (lo que ataca el adelantamiento)*], [*10*], [*5*], [*5*], [*0*], [*8*], [*4*],
  [Aritmético-lógica → salto (`daddi r3 → bnez`)], [10], [10], [10], [10], [8], [8],
  [Aritmético-lógica → aritmético-lógica (`dmul → dadd`)], [0], [0], [0], [0], [8], [8],
  [Aritmético-lógica → dirección del primer `lw` (`daddi r2 → lw`)], [1], [1], [1], [1], [1], [1],
  [Saltos tomados (2 ciclos cada uno)], [8], [8], [8], [8], [6], [6],
  [Último salto, que no se toma], [1], [1], [1], [1], [1], [1],
  [*Total (medido)*], [*64*], [*59*], [*59*], [*54*], [*69*], [*65*],
)

De dónde sale cada atasco:
- *`Load → ALU`.* Sin adelantamiento, la instrucción que usa el dato de un `load` espera en _Decode_ hasta que el `load` lo escribe en _Writeback_: 2 ciclos si es la siguiente y 1 si hay una instrucción en el medio. Con adelantamiento espera 1 y 0. En `fwd_prodesc` la `dmul` espera dos veces por vuelta (primero a `R1` y después a `R5`); con adelantamiento, una sola.
- *Aritmético-lógica → salto o → aritmético-lógica.* Son dependencias de otros escenarios (4a y saltos) que el 4c no cubre: valen lo mismo con el adelantamiento activado o no, y sirven de control.
- *Saltos.* El `bnez` se resuelve en _Execute_. Cuando se toma, la instrucción que ya se había buscado detrás (el `sw`) se anula y el destino se busca dos ciclos más tarde. En la última vuelta no se toma y la instrucción siguiente espera un solo ciclo en _Decode_.

Los tiempos son entonces los esperables para este procesador, y la única fila que cambia con el genérico `Forwarding` es la de `load → ALU`: 5 ciclos menos en cada suma y 4 en el producto escalar. Ninguno de los tres programas se cuelga; los programas de la cátedra que no terminan, y por qué, están en la sección 10.

// ============================================================================
// 8. FLUJO DE EJECUCIÓN (PUNTO 3B)
// ============================================================================
= 8. Flujo de ejecución (punto 3b)

En los tres programas, cada aritmético-lógica que depende de un `load` ejecuta con el operando tomado de `MEM/WB` (marcado `X*` abajo). Ocurre exactamente una vez por iteración: 5 en cada suma y 4 en el producto escalar, cada uno confirmado por un mensaje en la consola.

== 8.1 Qué se lee, escribe o procesa en cada etapa

Esta tabla vale para todas las instrucciones de los tres programas. La memoria principal tiene tres secciones: datos (desde `1000h`), instrucciones (desde `2000h`) y pila (desde `7000h`); ninguno de los programas usa la pila ni el registro `SP`.

#nice-table(
  columns: (76pt, 84pt, 98pt, 96pt, 74pt, 1fr),
  font-size: 8pt,
  table.header(
    [*Instrucción*], [*IF (búsqueda)*], [*ID (decodificación)*], [*EX (ejecución)*], [*MA (memoria)*], [*WB (escritura)*],
  ),
  [`lw rd, desp(rb)`],
  [Lee `IP`; lee la instrucción de la sección de instrucciones; escribe `IR` y actualiza `IP`],
  [Lee `IR`; lee `rb` del banco; calcula la dirección `desp + rb`],
  [Sin operación: no usa la ALU],
  [Lee la sección de datos; el dato queda en `MEM/WB`],
  [Escribe `rd` (primera mitad del ciclo)],

  [`dadd`, `daddi`, `dmul` (aritm.-lógicas)],
  [Ídem],
  [Lee `IR`; lee registros fuente (o inmediato); con adelantamiento, marca el operando de `MEM/WB`],
  [La ALU opera (con el operando adelantado si corresponde) y actualiza `FLAGS`],
  [Sin acceso a memoria],
  [Escribe `rd` con el resultado de la ALU],

  [`bnez rf, etiq`],
  [Ídem],
  [Lee `IR`; lee `rf`; pasa la dirección destino],
  [La ALU evalúa `rf` y escribe `FLAGS`; si el salto se toma, escribe `IP`],
  [Sin acceso],
  [Sin escritura],

  [`sw rf, desp(rb)`],
  [Ídem],
  [Lee `IR`; lee `rf` (el dato) y `rb`; calcula la dirección],
  [Sin operación],
  [Escribe la sección de datos],
  [Sin escritura],

  [`halt`],
  [Ídem],
  [Lee `IR`; detiene IF, ID y EX (`StopInit`)],
  [—],
  [Terminan las instrucciones previas],
  [Terminan las instrucciones previas],
)

Señales del adelantamiento en cada etapa: al entrar el `load` a MA se publica su destino (`IdRegFwdMA`); en ID la lectura del operando consulta al detector (`FwdEnableID` y `FwdRAW`); en EX el multiplexor toma `RecInWB.data.memaccess`.

== 8.2 Ciclo a ciclo: primera iteración de `fwd_suma`

El ciclo 1 empieza a los 200 ns, así que el ciclo $c$ ocupa de $100 dot (c + 1)$ a $100 dot (c + 2)$ ns. Referencias: *F* búsqueda, *D* decodificación, *Dr* atasco RAW en decodificación, *X* ejecución, *X\** ejecución con operando adelantado, *M* acceso a memoria, *W* escritura en registro, *Db* instrucción buscada detrás de un salto que espera su resolución, *De* instrucción anulada porque el salto se tomó.

#block(breakable: false)[
  *Sin adelantamiento* (`dadd` atascado 2 ciclos):
  #v(3pt)
  #set text(size: 8pt)
  #table(
    columns: (98pt, ..range(15).map(_ => 1fr)),
    align: (left, ..range(15).map(_ => center)),
    inset: (x: 2.5pt, y: 4pt),
    stroke: 0.45pt + rule-col,
    fill: (_, y) => if y == 0 { header-bg } else { none },
    table.header([*Instrucción*], ..range(1, 16).map(i => [*#i*])),
    [`lw r3, N(r0)`], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(10).map(_ => []),
    [`daddi r2, r0, 0`], [], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(9).map(_ => []),
    [`daddi r4, r0, 0`], [], [], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(8).map(_ => []),
    [`lw r1, TABLA(r2)`], [], [], [], pc("F"), pc("Dr"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(6).map(_ => []),
    [`dadd r4, r4, r1`], [], [], [], [], [], pc("F"), pc("Dr"), pc("Dr"), pc("D"), pc("X"), pc("M"), pc("W"), [], [], [],
    [`daddi r2, r2, 4`], ..range(8).map(_ => []), pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), [], [],
    [`daddi r3, r3, -1`], ..range(9).map(_ => []), pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), [],
    [`bnez r3, LAZO`], ..range(10).map(_ => []), pc("F"), pc("Dr"), pc("Dr"), pc("D"), pc("X"),
    [`sw r4, SUMA(r0)`], ..range(13).map(_ => []), pc("F"), pc("Db"),
  )
]

#v(4pt)

#block(breakable: false)[
  *Con adelantamiento* (`dadd` atascado 1 ciclo, `X*` en el ciclo 9):
  #v(3pt)
  #set text(size: 8pt)
  #table(
    columns: (98pt, ..range(15).map(_ => 1fr)),
    align: (left, ..range(15).map(_ => center)),
    inset: (x: 2.5pt, y: 4pt),
    stroke: 0.45pt + rule-col,
    fill: (_, y) => if y == 0 { header-bg } else { none },
    table.header([*Instrucción*], ..range(1, 16).map(i => [*#i*])),
    [`lw r3, N(r0)`], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(10).map(_ => []),
    [`daddi r2, r0, 0`], [], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(9).map(_ => []),
    [`daddi r4, r0, 0`], [], [], pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(8).map(_ => []),
    [`lw r1, TABLA(r2)`], [], [], [], pc("F"), pc("Dr"), pc("D"), pc("X"), pc("M"), pc("W"), ..range(6).map(_ => []),
    [`dadd r4, r4, r1`], [], [], [], [], [], pc("F"), pc("Dr"), pc("D"), pc("X*"), pc("M"), pc("W"), [], [], [], [],
    [`daddi r2, r2, 4`], ..range(7).map(_ => []), pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), [], [], [],
    [`daddi r3, r3, -1`], ..range(8).map(_ => []), pc("F"), pc("D"), pc("X"), pc("M"), pc("W"), [], [],
    [`bnez r3, LAZO`], ..range(9).map(_ => []), pc("F"), pc("Dr"), pc("Dr"), pc("D"), pc("X"), pc("M"),
    [`sw r4, SUMA(r0)`], ..range(12).map(_ => []), pc("F"), pc("Db"), pc("De"),
  )
]

Los atascos que quedan no son del escenario 4c: el `lw r1` espera a `r2` (`daddi → dirección del load`) y el `bnez` espera a `r3` (`daddi → salto`). El `sw` buscado detrás del `bnez` se anula porque el salto se toma.

Qué hace cada componente en los ciclos clave, con adelantamiento:

+ *Ciclo 6 (700–800 ns).* El `lw r1` termina de decodificarse: lee `IR`, lee `r2` (recién escrito en la primera mitad del ciclo por el `daddi r2`) y calcula la dirección `TABLA + 0 = 1000h`. _Fetch_ lee `IP` y la sección de instrucciones, carga el `dadd` en `IR` y avanza `IP`.
+ *Ciclo 7 (800–900 ns).* El `lw` pasa por EX sin usar la ALU. El `dadd` lee `r4` sin problema; al leer `r1` el detector encuentra 1 escritura pendiente y el `lw` está en EX, no en MA, así que activa `StallRAW` y guarda que el atasco lo causó una aritmético-lógica. A los 870 ns, al pasar el `lw` a MA, los registros de segmentación publican `IdRegFwdMA = r1`.
+ *Ciclo 8 (900–1000 ns).* A los 900 ns, `ForwardMA` ve que el `load` que entró a MA escribe `r1`, su única escritura pendiente, y baja `StallRAW`. En la segunda mitad, _Decode_ vuelve a leer: `r4` sale del banco y para `r1` el detector responde `FwdRAW = 1`, así que se marca `fwd2 = 1` y `fwdreg = r1`. A los 950 ns el `lw` lee la sección de datos (valor 3) y a los 970 ns el dato queda en `MEM/WB`.
+ *Ciclo 9 (1000–1100 ns).* El `lw` hace _Writeback_: descuenta su escritura pendiente y escribe `r1 = 3` a los 1025 ns. A los 1050 ns el `dadd` entra a la ALU; el multiplexor reemplaza el segundo operando por el dato de `MEM/WB` y la ALU calcula `r4 + 3` y actualiza `FLAGS`. Consola: `Adelantamiento (MEM/WB -> EX): R1 = 0x00000003 ingresa a la ALU como segundo operando`.
+ *Ciclos 10 y 11.* El `dadd` no accede a memoria en MA y escribe `r4` en WB. Sin adelantamiento, el `dadd` recién se decodifica en el ciclo 9 (lee `r1` del banco, ya escrito a los 1025 ns) y ejecuta en el 10: todo lo que sigue se corre un ciclo.

== 8.3 `fwd_suma_reord`: distancia 2, sin atasco `load → ALU`

Con el `daddi r2` entre el `load` y su uso, el `dadd` se decodifica cuando el `lw` ya está en MA. Sin adelantamiento se atasca 1 ciclo (`Dr` en el ciclo 8); con adelantamiento no se atasca y ejecuta con el dato de `MEM/WB` en el ciclo 9.

#nice-table(
  columns: (110pt, 1fr, 1fr),
  font-size: 8.8pt,
  table.header([*Instrucción*], [*Sin adelantamiento (ciclos 6–12)*], [*Con adelantamiento (ciclos 6–12)*]),
  [`lw r1, TABLA(r2)`], [`D X M W` (ciclos 6–9)], [`D X M W` (ciclos 6–9)],
  [`daddi r2, r2, 4`], [`F D X M W` (6–10)], [`F D X M W` (6–10)],
  [`dadd r4, r4, r1`], [`F Dr D X M W` (7–12)], [*`F D X* M W` (7–11)*],
  [`daddi r3, r3, -1`], [`F D X M W` (9–13)], [`F D X M W` (8–12)],
)

== 8.4 `fwd_prodesc`: dos `loads` que alimentan una `dmul`

El `dmul r6, r1, r5` lee `r1` (`lw` a distancia 2) y `r5` (`lw` consecutivo).

#nice-table(
  columns: (110pt, 1fr, 1fr),
  font-size: 8.8pt,
  table.header([*Instrucción*], [*Sin adelantamiento*], [*Con adelantamiento*]),
  [`lw r1, VA(r2)`], [`F Dr D X M W` (ciclos 4–9)], [`F Dr D X M W` (ciclos 4–9)],
  [`lw r5, VB(r2)`], [`F D X M W` (6–10)], [`F D X M W` (6–10)],
  [`dmul r6, r1, r5`], [`F Dr Dr D X M W` (7–13)], [*`F Dr D X* M W` (7–12)*],
  [`dadd r4, r4, r6`], [`F Dr Dr D X M W` (10–16)], [`F Dr Dr D X M W` (9–15)],
)

Sin adelantamiento, el `dmul` se atasca primero por `r1` (hasta el _Writeback_ del `lw r1`) y después por `r5`: es el doble atasco de la sección 5. Con adelantamiento, en el ciclo 8 `r1` ya se podía adelantar (el `lw r1` estaba en MA), pero `r5` todavía estaba en EX y la instrucción se atascó. En el ciclo 9 el reintento lee `r1` del banco, porque el `lw r1` ya lo escribió en su _Writeback_, y adelanta `r5` desde `MEM/WB`. El `dadd r4, r4, r6` depende de la `dmul` (aritmético-lógica → aritmético-lógica, escenario 4a) y por eso sigue atascado 2 ciclos en ambos modos.

== 8.5 Evidencia en la consola

Cada adelantamiento deja un mensaje de severidad `NOTE` emitido por `execute.vhd` en el ciclo en que la ALU usa el dato:

#nice-table(
  columns: (84pt, 108pt, 66pt, 36pt, 58pt, 1fr),
  font-size: 8.2pt,
  table.header([*Programa*], [*Tiempo (ns)*], [*Ciclo*], [*Reg.*], [*Valor*], [*Operando*]),
  [`fwd_suma`], [1050, 2050, 3050, 4050, 5050], [9, 19, 29, 39, 49], [`R1`], [3, 8, 1, 12, 6], [Segundo (`dadd r4, r4, r1`)],
  [`fwd_suma_reord`], [1050, 1950, 2850, 3750, 4650], [9, 18, 27, 36, 45], [`R1`], [3, 8, 1, 12, 6], [Segundo (`dadd r4, r4, r1`)],
  [`fwd_prodesc`], [1150, 2550, 3950, 5350], [10, 24, 38, 52], [`R5`], [6, 1, 7, 2], [Segundo (`dmul r6, r1, r5`)],
)

Los valores adelantados son, en orden, los elementos de `TABLA` y de `VB`: el dato leído por cada `load` llega a la ALU un ciclo antes de que se lea del banco de registros. Con `Forwarding = false` no aparece ningún mensaje y los resultados finales (`SUMA = 30`, `PROD = 46`) son los mismos.

#figure(
  box(stroke: 0.6pt + rule-col, radius: 3pt, clip: true, image("img/image3.png", width: 100%)),
  caption: [Consola de Active-HDL 17: `fwd_suma` con cauce y adelantamiento.],
)

== 8.6 Evidencia en la forma de onda

La figura compara las formas de onda de Active-HDL para `fwd_suma_reord`, recortadas a la misma ventana de tiempo: de 600 a 1180 ns, la primera vuelta del lazo. En este programa hay una instrucción (`daddi r2, r2, 4`) entre el `lw r1` y el `dadd r4, r4, r1`.

#figure(
  box(stroke: 0.6pt + rule-col, radius: 3pt, clip: true, image("img/image4.png", width: 100%)),
  caption: [Active-HDL 17, `fwd_suma_reord` con cauce. Arriba sin adelantamiento, abajo con adelantamiento. La franja marca de 952 a 1001 ns.],
)

- Sin adelantamiento, `StallRAW` vale 1 de 952 a 1001 ns: _Decode_ lee `R1` mientras el `lw r1` todavía no lo escribió, y el `dadd` espera un ciclo.
- Con adelantamiento, en ese mismo lapso `StallRAW` queda en 0 y `FwdRAW` vale 1: el detector informa que `R1` se puede adelantar, _Decode_ lo marca y el `dadd` sigue sin esperar.
- En las dos corridas `IdRegFwdMA` vale `02` (`R1 + 1`) de 870 a 970 ns, mientras el `lw r1` está en _Memory Access_. Lo que decide si se usa es el genérico `Forwarding`.

Cada vuelta pasa de 10 a 9 ciclos, y el programa termina a los 5600 ns en lugar de 6100.

// ============================================================================
// 9. VERIFICACIÓN Y CÓMO REPRODUCIR LOS RESULTADOS
// ============================================================================
= 9. Verificación y cómo reproducir los resultados

Toda la verificación se hizo en Active-HDL 17 Student Edition, el simulador de la cátedra. En los tres programas el adelantamiento no cambia el resultado (`R4` es el mismo en las tres configuraciones) y nunca hace más lento un programa: con cauce, ahorra 500 ns en cada suma y 400 ns en el producto escalar.

*Verificación en Active-HDL.* El proyecto con los 12 archivos de la entrega se abrió en Active-HDL 17 Student Edition y se compiló con _Compile All_: 0 errores y 0 advertencias. Después se corrieron los tres programas en las tres configuraciones y `bug_doble_raw` con cauce, observando la consola y una forma de onda con `CLK`, `StallRAW`, `FwdRAW`, `IdRegFwdMA`, `R1` y `R4`.

#nice-table(
  columns: (92pt, 1fr, 62pt, 54pt, 62pt, 62pt),
  align: (left, left, right, right, right, right),
  font-size: 8.5pt,
  table.header(
    [*Programa*], [*Configuración*], [*Ensamb. (ns)*], [*Fin (ns)*], [*Msgs. fwd*], [*`R4` final*],
  ),
  [`fwd_suma`], [Sin cauce], [127], [15200], [0], [`1E` (30)],
  [`fwd_suma`], [Cauce, sin adelantamiento], [127], [6600], [0], [`1E` (30)],
  [`fwd_suma`], [*Cauce, con adelantamiento*], [127], [*6100*], [*5*], [`1E` (30)],
  [`fwd_suma_reord`], [Sin cauce], [127], [15200], [0], [`1E` (30)],
  [`fwd_suma_reord`], [Cauce, sin adelantamiento], [127], [6100], [0], [`1E` (30)],
  [`fwd_suma_reord`], [*Cauce, con adelantamiento*], [127], [*5600*], [*5*], [`1E` (30)],
  [`fwd_prodesc`], [Sin cauce], [157], [16700], [0], [`2E` (46)],
  [`fwd_prodesc`], [Cauce, sin adelantamiento], [157], [7100], [0], [`2E` (46)],
  [`fwd_prodesc`], [*Cauce, con adelantamiento*], [157], [*6700*], [*4*], [`2E` (46)],
  [`bug_doble_raw`], [Cauce, sin adelantamiento], [71], [1300], [0], [`9`],
)

En la consola, cada mensaje de adelantamiento aparece en el instante que indica la tabla de la sección 8.5. En `fwd_prodesc` con cauce y sin adelantamiento, la forma de onda muestra el doble atasco del `dmul r6, r1, r5` (de 950 a 1001 ns por `R1` y de 1052 a 1101 ns por `R5`), y aun así el resultado es 46. En `bug_doble_raw` se ven los dos atascos seguidos del `dadd r3, r1, r2` (de 450 a 501 ns por `R1` y de 552 a 602 ns por `R2`) y `R4` termina en 9: la instrucción que antes se perdía ahora se ejecuta. Así queda verificada en el simulador de la cátedra la corrección de la sección 5.

#figure(
  box(stroke: 0.6pt + rule-col, radius: 3pt, clip: true, image("img/image5.png", width: 100%)),
  caption: [Active-HDL 17, `bug_doble_raw` con cauce: los dos atascos seguidos del `dadd` y `R4 = 9` al final.],
)

*Antes y después de la corrección del bug.* Para medir el comportamiento sin la corrección se comentaron las cuatro líneas del lazo `while` en `fetch.vhd`, se recompiló todo el diseño con _Compile All_ y se corrió con cauce y sin adelantamiento; después se volvieron a habilitar y se recompiló. Sin la corrección, cada programa termina antes porque ejecuta menos instrucciones, y dos de ellos dan un resultado incorrecto:

#nice-table(
  columns: (1fr, 130pt, 140pt),
  font-size: 8.8pt,
  table.header([*Programa (cauce, sin adelantamiento)*], [*Sin la corrección*], [*Con la corrección*]),
  [`bug_doble_raw`], [1200 ns, `R4 = 0`], [*1300 ns, `R4 = 9`*],
  [`fwd_prodesc`], [5900 ns, `R4 = 0`], [*7100 ns, `R4 = 2E` (46)*],
  [`prog_prueba` (cátedra)], [4700 ns], [*5100 ns*],
)

En la forma de onda de `bug_doble_raw` sin la corrección se ven los mismos dos atascos seguidos del `dadd`, pero `R4` no cambia nunca: el `daddi r4, r0, 9` se pierde. En `fwd_prodesc` aparece el doble atasco del `dmul` en cada vuelta del lazo y `R4` queda en 0 todo el programa.

También se corrieron en Active-HDL, con la corrección, tres programas de la cátedra citados en la sección 10: `desp_bits.asm` termina a los 1900 ns, y `salto.asm` y `logicas.asm` no terminan, por los motivos que se explican allí.

*Para reproducirlo en Active-HDL:*

+ Copiar los 12 `.vhd` de la entrega a sus rutas (tabla de la sección 4), reemplazando los originales, y los 3 `.asm` a `src/Assembler/`.
+ Compilar todo el diseño (_Compile All_). El orden de compilación no cambia.
+ En `usuario.vhd` elegir `ProgName` (por ejemplo `"fwd_suma.asm"`), `Pipelining` y `Forwarding`, y volver a compilar ese archivo.
+ Inicializar la simulación con `usuario` como _top-level_ y correrla hasta que termine.
+ En la consola deben aparecer, en orden: la configuración elegida, el tiempo de ensamblaje, un mensaje `Adelantamiento (MEM/WB -> EX)` por iteración (sólo con `Forwarding = true`) y el tiempo de fin, que debe coincidir con la tabla de la sección 7.
+ Para ver el cauce, agregar a la forma de onda `/usuario/UUT/UUT2/UUT1/UUT1/InstStatesExec` (estado de cada instrucción) y, de `/usuario/UUT/UUT2`, las señales `StallRAW`, `FwdRAW`, `IdRegFwdMA`, `IDtoEX` y `RecInWB`.

#block(breakable: false)[
  Los mismos pasos desde la consola de Active-HDL, una vez elegida la configuración en `usuario.vhd`:
  ```tcl
  acom -O3 -e 100 -work tda_1819 -2002 $dsn/src/Usuario/usuario.vhd
  asim -t ns -O5 +access +r +m+usuario usuario USUARIO_ARCHITECTURE
  wave /usuario/UUT/UUT2/CLK /usuario/UUT/UUT2/StallRAW /usuario/UUT/UUT2/FwdRAW \
       /usuario/UUT/UUT2/IdRegFwdMA /usuario/UUT/UUT2/UUT7/R1 /usuario/UUT/UUT2/UUT7/R4
  run
  endsim
  ```
]

// ============================================================================
// 10. PROBLEMAS ENCONTRADOS Y SOLUCIONES
// ============================================================================
#pagebreak()
= 10. Problemas encontrados y soluciones

Los problemas que aparecieron durante el trabajo, dónde se detectaron y cómo se resolvieron:

#nice-table(
  columns: (1fr, 130pt, 1fr),
  font-size: 8.3pt,
  table.header([*Problema*], [*Dónde apareció*], [*Solución*]),
  [Con cauce, cuando una instrucción se atasca dos veces seguidas (una por cada operando), se pierde la instrucción siguiente],
  [Al correr `fwd_prodesc` sin adelantamiento (`PROD = 0` en lugar de 46), `bug_doble_raw` y `prog_prueba`. Es un error del procesador original],
  [`fetch.vhd`: repetir la espera mientras `StallRAW` siga activo (sección 5)],

  [La máquina de estados mostraba mal ese doble atasco],
  [En la tabla `InstStatesExec`],
  [`states_machine.vhd` consulta `StallRAW` 15 ns más tarde. Es sólo visual],

  [Dos `loads` en vuelo que escriben el mismo registro: adelantar el dato del primero sería usar un valor viejo],
  [Al diseñar las condiciones del detector],
  [Sólo se adelanta si el registro tiene una única escritura pendiente; si hay dos, se espera como en el original (sección 3)],

  [Con la FPU ocupada, el _Execute_ del consumidor puede demorarse y el dato ya no estaría en `MEM/WB`],
  [Al diseñar las condiciones del detector],
  [El adelantamiento se inhibe mientras la FPU tiene operaciones en curso (`EXFPUPending`)],

  [El ensamblador rechaza un comentario que sigue a un registro o a un 0 sin un espacio antes del tabulador],
  [Al escribir los programas de prueba],
  [Se agregó un espacio antes del tabulador en esas líneas],

  [El ensamblador se corta con un índice fuera de rango si hay una línea vacía en `.data`, y exige una última línea con un tabulador después de `halt`],
  [Al revisar programas de prueba escritos por el grupo],
  [Los programas entregados no tienen líneas vacías y terminan con esa línea],

  [La máquina de estados tiene lugar para 100 instrucciones ejecutadas; si un programa ejecuta más, la simulación se corta],
  [`salto.asm` de la cátedra, que es un lazo infinito: en Active-HDL se detiene a los 10300 ns con «Index 101 out of range (1 to 100)» en `states_machine.vhd`],
  [Es del simulador original y no se modificó. Los programas del TP ejecutan 30 y 33 instrucciones],

  [`logicas.asm` de la cátedra no llega a ejecutarse: el ensamblador informa «Error en la línea 7 … la instrucción declarada no es válida»],
  [Al correrlo en Active-HDL: se detiene a los 29 ns, antes de terminar el ensamblado],
  [Es un error del programa, no del procesador (el ensamblador no se modificó). No se tocó],

  [Al descomprimir en Windows, la carpeta «1. Máquina de Estados» puede quedar con otro nombre y el archivo nuevo, en una carpeta que Active-HDL no compila],
  [Al copiar los archivos de la entrega],
  [Se armó un proyecto completo con los cambios ya aplicados; si se copian a mano, verificar que haya una sola carpeta],

  [Active-HDL 17 avisa que el orden de compilación es distinto del guardado],
  [Al compilar con _Compile All_ el workspace, que es de una versión anterior],
  [Active-HDL reordena solo y compila sin errores ni advertencias; se puede contestar «No» al aviso],
)
