// Guion de Presentación — TP10 Grupo 11
// División de filminas, tiempos y guion oral para los 6 integrantes

// === INTEGRANTES POR BLOQUE ===
#let orador1 = "Lázaro"
#let orador2 = "Agustín"
#let orador3 = "Tomi"
#let orador4 = "Martín"
#let orador5 = "Valeria"
#let orador6 = "Jose"

#let ink = rgb("#1F2937")
#let muted = rgb("#64748B")
#let accent = rgb("#2563EB")
#let accent-soft = rgb("#EFF6FF")
#let accent-border = rgb("#BFDBFE")
#let stall-bg = rgb("#FFF7ED")
#let stall-ink = rgb("#9A3412")
#let stall-border = rgb("#FDBA74")
#let rule-col = rgb("#E2E8F0")
#let header-bg = rgb("#F8FAFC")

#set document(
  title: "Guion de Exposición — TP10 Grupo 11",
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
        [TP10 · Guion de exposición (15 min) — Adelantamiento load → ALU],
        [Grupo 11 · Taller de Arquitectura 2026],
      )
      v(-2pt)
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
        [Guion de defensa oral · 6 integrantes],
        [Página #counter(page).display("1 de 1", both: true)],
      )
    }
  },
)

#set text(
  font: ("Segoe UI", "Arial"),
  size: 9.8pt,
  fill: ink,
  lang: "es",
)

#set par(leading: 0.6em, spacing: 0.7em, justify: false)

#show raw.where(block: false): it => box(
  fill: rgb("#F1F5F9"),
  inset: (x: 3pt, y: 1pt),
  outset: (y: 1.5pt),
  radius: 2.5pt,
  text(font: ("Consolas", "Courier New"), size: 8.5pt, fill: rgb("#0F172A"), it),
)

#let speaker-header(num, name, slides, duration, focus) = {
  v(10pt, weak: true)
  block(
    width: 100%,
    fill: rgb("#131C2B"),
    radius: 6pt,
    inset: (x: 13pt, y: 9pt),
    breakable: false,
    sticky: true,
  )[
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      [
        #text(size: 8.5pt, weight: "semibold", fill: rgb("#60A5FA"), tracking: 0.8pt)[BLOQUE #num · #slides]
        #v(2pt)
        #text(size: 13pt, weight: "bold", fill: white)[#name]
      ],
      [
        #box(fill: rgb("#1E293B"), stroke: 0.6pt + rgb("#334155"), radius: 4pt, inset: (x: 8pt, y: 4pt))[
          #text(size: 9.5pt, weight: "bold", fill: rgb("#93C5FD"))[Tiempo: #duration]
        ]
      ],
    )
    #v(3pt)
    #text(size: 8.8pt, fill: rgb("#CBD5E1"))[Foco: #focus]
  ]
}

#let slide-script(num, title, time, cue: none, script, handoff: none) = {
  block(
    width: 100%,
    stroke: (left: 2.5pt + accent, rest: 0.5pt + rule-col),
    fill: white,
    radius: (right: 5pt),
    inset: (x: 11pt, y: 8.5pt),
    breakable: false,
  )[
    #grid(
      columns: (1fr, auto),
      align: (left + horizon, right + horizon),
      [#text(size: 10.2pt, weight: "bold", fill: rgb("#0F172A"))[Filmina #num — #title]],
      [#text(size: 8.5pt, font: "Consolas", fill: accent, weight: "semibold")[~#time]],
    )
    #if cue != none [
      #v(2pt)
      #text(size: 8.6pt, fill: muted, style: "italic")[En pantalla: #cue]
    ]
    #v(4pt)
    #text(size: 9.5pt, fill: ink)[#script]
    #if handoff != none [
      #v(4pt)
      #text(size: 8.8pt, weight: "semibold", fill: rgb("#1E40AF"))[Pase: «#handoff»]
    ]
  ]
  v(4pt)
}

// ============================================================================
// ENCABEZADO Y TABLA DE REPARTO
// ============================================================================
#block(
  width: 100%,
  inset: (bottom: 10pt),
  stroke: (bottom: 2pt + accent),
)[
  #text(size: 8.8pt, weight: "semibold", fill: accent, tracking: 0.9pt)[
    TALLER DE ARQUITECTURA 2026 · TRABAJO PRÁCTICO 10 · GRUPO 11
  ]
  #v(3pt)
  #text(size: 18pt, weight: "bold", fill: rgb("#0F172A"))[
    Guion y reparto de la presentación oral (15 minutos)
  ]
  #v(3pt)
  #text(size: 9.5pt, fill: muted)[
    Duración estimada del guion: ~12 min 35 s · Margen para transiciones y respiro: ~2 min 25 s
  ]
]

#v(8pt)

#set text(size: 8.8pt)
#table(
  columns: (42pt, 1fr, 78pt, 1.15fr, 54pt),
  align: (center, left, center, left, right),
  inset: (x: 6pt, y: 5.5pt),
  stroke: (x, y) => (
    top: if y == 0 { 1.1pt + ink } else if y == 1 { 0.8pt + rgb("#94A3B8") } else { 0.45pt + rule-col },
    bottom: 0.45pt + rule-col,
    left: none,
    right: none,
  ),
  fill: (_, y) => if y == 0 { header-bg } else { none },
  table.header([*Bloque*], [*Orador*], [*Filminas*], [*Temas*], [*Tiempo*]),
  [*1*], [#orador1], [1 a 3], [Portada, consigna 4c y problema original], [1:55],
  [*2*], [#orador2], [4 a 6], [Idea general, 4 piezas y condiciones], [2:10],
  [*3*], [#orador3], [7 y 8], [Traza ciclo a ciclo y regla de atraso], [1:50],
  [*4*], [#orador4], [9 a 11], [Programas, tabla de tiempos y consola], [2:25],
  [*5*], [#orador5], [12 y 13], [Forma de onda y bug del doble atasco RAW], [2:15],
  [*6*], [#orador6], [14 a 16], [Verificación 10/10, entrega y cierre], [2:00],
)
#set text(size: 9.8pt)

#v(6pt)
#block(
  width: 100%,
  fill: stall-bg,
  stroke: (left: 3pt + rgb("#D97706"), rest: 0.5pt + stall-border),
  radius: (right: 4pt),
  inset: (x: 11pt, y: 8pt),
)[
  *Recomendaciones prácticas para la defensa:* las filminas *7* y *12* son las más técnicas (conviene señalar con el cursor las cajas `X*` y la franja `952–1001 ns`). Si en el ensayo se pasan de tiempo, recortar unos segundos en la filmina *14*. No conviene hacer demo en vivo dentro de los 15 minutos: tener Active-HDL ya abierto con `fwd_suma` listo por si lo piden en la ronda de preguntas.
]

// ============================================================================
// ORADOR 1 — FILMINAS 1 A 3
// ============================================================================
#speaker-header(1, orador1, "FILMINAS 1 A 3", "1:55", "Abrir la charla, delimitar el escenario 4c y explicar por qué hoy se pierde un ciclo.")

#slide-script(1, "Portada — Adelantamiento load → ALU en el TDA 1819", "0:25",
  cue: "Presentación del grupo y hoja de ruta.",
  [
    «Buenas tardes. Somos el Grupo 11 y vamos a presentar el TP10 sobre el procesador TDA 1819. Nos tocó el escenario 4c del ejercicio 4: adelantar el dato que un `load` lee de memoria hacia una instrucción aritmético-lógica que lo necesita en la ALU. Vamos a recorrer el problema original, el diseño en cuatro piezas, la traza ciclo a ciclo, los programas de prueba con sus tiempos y un bug del procesador que encontramos y corregimos en el camino.»
  ],
)

#slide-script(2, "Qué nos tocó: escenario 4c", "0:40",
  cue: "Señalar Productor (izquierda), flecha MEM/WB y Consumidor (derecha).",
  [
    «El escenario 4c es el caso clásico _load-use_: un `load` lee de la sección de datos y una instrucción aritmético-lógica posterior necesita ese valor como operando de la ALU. Nuestro mecanismo cubre `lb`, `lh` y `lw` como productores y las 30 instrucciones aritmético-lógicas enteras como consumidoras, en el primer operando, en el segundo o en los dos. Todo lo que queda afuera —como _stores_, saltos, productores aritmético-lógicos, `lf`, `poph` o la FPU— corresponde a otros escenarios y mantiene exactamente el comportamiento original.»
  ],
)

#slide-script(3, "Hoy el dato espera un ciclo de más", "0:50",
  cue: "Recorrer los dos bloques Dr (ciclos 3 y 4) y el bloque M (ciclo 4).",
  [
    «Así resuelve hoy el TDA una dependencia RAW. El detector lleva un contador de escrituras pendientes por registro. Cuando el `dadd` intenta leer `r1` en _Decode_ en el ciclo 3, el contador está en 1, se activa `StallRAW` y _Fetch_ y _Decode_ quedan congelados durante dos ciclos. Recién cuando el `lw` entra a _Writeback_ en el ciclo 5, escribe `r1` en el banco en la primera mitad del ciclo, baja `StallRAW` y el `dadd` vuelve a leer en la segunda mitad. Pero si miramos el ciclo 4, el dato ya salió de memoria y quedó en el registro `MEM/WB`. Ese ciclo de espera es el que recuperamos con el adelantamiento.»
  ],
  handoff: [Ahora #orador2 va a contar cómo diseñamos el camino de adelantamiento y qué piezas agregamos.],
)

// ============================================================================
// ORADOR 2 — FILMINAS 4 A 6
// ============================================================================
#speaker-header(2, orador2, "FILMINAS 4 A 6", "2:10", "Explicar el diagrama del cauce, los 4 componentes tocados y las condiciones de seguridad.")

#slide-script(4, "La idea: el dato va de MEM/WB a la ALU", "0:45",
  cue: "Seguir con el cursor la línea azul desde MEM/WB hasta el multiplexor de la ALU, y luego las 4 señales verticales.",
  [
    «La idea arquitectónica es directa: al terminar su _Memory Access_, el `load` deja el dato en el registro de segmentación `MEM/WB`. Agregamos un camino de datos desde `MEM/WB` hasta un multiplexor delante de la ALU. De esa manera, en el ciclo siguiente —el mismo en que el `load` escribe el banco en _Writeback_— la instrucción aritmético-lógica ya puede operar en la ALU con ese dato. Para coordinar cuándo se usa ese camino, sumamos cuatro señales de control hacia y desde el detector RAW: `FwdEnableID`, `FwdRAW`, `EXFPUPending` e `IdRegFwdMA`.»
  ],
)

#slide-script(5, "Cuatro piezas, una por componente", "0:50",
  cue: "Recorrer las 4 tarjetas de izquierda a derecha (1 → 2 → 3 → 4).",
  [
    «El mecanismo se divide en cuatro piezas, una por componente: primero, en `pipeline_registros`, cuando un `load` adelantable entra a _Memory Access_ publicamos su registro destino por `IdRegFwdMA`. Segundo, en `raw_waw_detector`, al iniciar el ciclo `ForwardMA` libera un atasco que estuviera esperando justo ese registro, y al leer un operando `CanForwardRAW` decide si adelantar en vez de atascar. Tercero, `decode` avisa con `FwdEnableID` si la instrucción es aritmético-lógica y, si recibe `FwdRAW = 1`, marca en `ID/EX` qué operando se adelanta. Cuarto, en `execute`, `ForwardOperands` actúa como multiplexor tomando el dato de `MEM/WB` extendido con ceros. Todo se controla con el nuevo genérico `Forwarding` de `usuario.vhd`: en `false`, las piezas quedan inactivas.»
  ],
)

#slide-script(6, "Se adelanta sólo si se cumple todo esto", "0:35",
  cue: "Hacer foco en los puntos 4 y 5 (las dos decisiones conservadoras).",
  [
    «El detector sólo habilita el adelantamiento si se cumplen cinco condiciones a la vez: `Forwarding` y `Pipelining` activos, instrucción aritmético-lógica entera en _Decode_, y que el registro leído sea el destino del `load` actualmente en _Memory Access_. Las dos últimas condiciones son de seguridad: si hay más de una escritura pendiente sobre ese registro —por ejemplo dos `loads` seguidos al mismo destino— preferimos esperar al más reciente; y si la FPU tiene operaciones en curso, también inhibimos el adelantamiento para que un atasco estructural o WAW de la FPU no desfase la lectura de `MEM/WB`. Si falta cualquiera, se atasca como en el procesador original.»
  ],
  handoff: [#orador3 va a mostrar cómo se ve esto ciclo a ciclo en un programa real.],
)

// ============================================================================
// ORADOR 3 — FILMINAS 7 Y 8
// ============================================================================
#speaker-header(3, orador3, "FILMINAS 7 Y 8", "1:50", "Bajar a tierra la traza de fwd_suma y explicar por qué el caso consecutivo no baja a 0.")

#slide-script(7, "Ciclo a ciclo: primera iteración de fwd_suma", "1:05",
  cue: "Comparar la fila del dadd arriba (Dr, Dr, D, X en ciclo 10) vs abajo (Dr, D, X* en ciclo 9).",
  [
    «Acá vemos la primera vuelta del lazo de `fwd_suma`, tomada directo de la simulación. El `Dr` del `lw` en el ciclo 5 no es de nuestro escenario: espera a `r2`, que produce un `daddi`. Lo que nos importa es el `dadd`. Arriba, sin adelantamiento, se atasca dos ciclos —el 7 y el 8— y recién ejecuta en el ciclo 10. Abajo, con adelantamiento, en el ciclo 7 sigue habiendo un atasco porque el `lw` todavía está en `EX`, pero al arrancar el ciclo 8 el `lw` entra a `MA`: el detector libera `StallRAW`, el `dadd` se decodifica marcando `r1` como adelantado y, en el ciclo 9, entra a la ALU como `X*` tomando el valor `3` que quedó en `MEM/WB` a los 970 ns. Todo el resto del programa se adelanta un ciclo: en 5 iteraciones, son 5 ciclos ganados.»
  ],
)

#slide-script(8, "El atraso load → ALU baja un ciclo", "0:45",
  cue: "Recorrer los tres números grandes (2→1, 1→0, 0→0) y cerrar con 52 ns vs 50 ns.",
  [
    «De ahí sale la regla general: cuando el `load` y la aritmético-lógica son consecutivos, el atasco baja de 2 ciclos a 1; cuando hay una instrucción independiente en el medio, el atasco desaparece por completo; y con dos o más ya no había atasco. ¿Por qué en el caso consecutivo no se puede bajar a cero? Porque dentro del ciclo de 100 ns del TDA, la ALU arranca a los 50 ns y el dato recién sale de la memoria a los 52 ns del _Memory Access_ del `load`. Es exactamente el mismo atasco _load-use_ inevitable que conocemos del MIPS64 con forwarding.»
  ],
  handoff: [Ahora #orador4 va a presentar los tres programas de prueba, los tiempos medidos y la salida de consola.],
)

// ============================================================================
// ORADOR 4 — FILMINAS 9 A 11
// ============================================================================
#speaker-header(4, orador4, "FILMINAS 9 A 11", "2:25", "Mostrar los 3 programas, justificar los tiempos/CPI y mostrar la evidencia de consola.")

#slide-script(9, "Programas: cambia la distancia load → uso", "0:45",
  cue: "Señalar los 3 bloques de código y mencionar las dependencias de control.",
  [
    «Para el punto 2 diseñamos tres programas donde variamos únicamente la distancia entre cada `load` y su uso, y los corrimos con `Forwarding` en `true` y en `false` para contrastar el mismo código. `fwd_suma` suma un vector de 5 enteros con `lw` y `dadd` consecutivos; `fwd_suma_reord` es exactamente la misma suma pero moviendo el incremento del índice entre el `load` y el `dadd`, mostrando que reordenar más adelantar elimina el atasco por completo; y `fwd_prodesc` calcula un producto escalar con dos `loads` seguidos antes de un `dmul`. Además, los tres incluyen dependencias fuera del escenario 4c —como `daddi → bnez` y `dmul → dadd`— que actúan como control para verificar que ahí el procesador sigue atascando igual.»
  ],
)

#slide-script(10, "Tiempos: 4 o 5 ciclos menos con cauce", "0:55",
  cue: "Recorrer la columna Ahorro (−5, −5, −4) y CPI; mencionar por qué fwd_prodesc gana 4 y no 8.",
  [
    «En el punto 3a medimos las tres configuraciones en Active-HDL 17. Sin cauce, cada instrucción tarda exactamente 5 ciclos —150 en las sumas y 165 en el producto escalar— y activar `Forwarding` no cambia nada porque no hay atascos. El tiempo de ensamblaje tampoco cambia: 127 ns y 157 ns. Con cauce, el adelantamiento ahorra un ciclo por iteración: 5 ciclos en cada suma y 4 en el producto escalar, bajando el CPI hasta 1,80 en la versión reordenada. En `fwd_prodesc` se ganan 4 ciclos y no 8 porque, cuando el `dmul` reintenta tras el primer atasco, el primer `load` (`r1`) ya escribió en _Writeback_ y se lee del banco; el único que llega adelantado es `r5`. Y todos los ciclos que quedan están contabilizados uno por uno en el informe.»
  ],
)

#slide-script(11, "Cómo se comprueba en la simulación", "0:45",
  cue: "Señalar las 5 líneas NOTE de Adelantamiento y los valores 3, 8, 1, C (12), 6.",
  [
    «Esta es la consola real de Active-HDL al correr `fwd_suma` con cauce y adelantamiento. Cada vez que el multiplexor en `execute.vhd` usa un dato de `MEM/WB`, emite un mensaje `NOTE` con el registro, el valor y el instante exacto. Acá vemos los cinco adelantamientos —uno por iteración— y los valores son justamente los cinco elementos del vector: 3, 8, 1, 12 y 6. El programa termina a los 6100 ns con `R4 = 1E` (30), el mismo resultado que sin adelantamiento, pero 500 ns antes.»
  ],
  handoff: [#orador5 va a mostrar cómo se ve esto en las formas de onda y el bug que encontramos al probar el procesador.],
)

// ============================================================================
// ORADOR 5 — FILMINAS 12 Y 13
// ============================================================================
#speaker-header(5, orador5, "FILMINAS 12 Y 13", "2:15", "Leer las señales en el Waveform Viewer y explicar el hallazgo + corrección del bug.")

#slide-script(12, "Forma de onda: el atasco desaparece", "1:05",
  cue: "Señalar la franja naranja 952–1001 ns: arriba StallRAW sube; abajo StallRAW queda en 0 y sube FwdRAW.",
  [
    «Acá comparamos dos capturas de la forma de onda de Active-HDL para `fwd_suma_reord`, recortadas exactamente en la misma ventana de 600 a 1180 ns. Recordemos que en este programa hay una instrucción entre el `load` y el `dadd`. En la franja sombreada, de 952 a 1001 ns: arriba, sin adelantamiento, `StallRAW` sube a 1 porque _Decode_ lee `R1` antes de que el `lw` lo escriba, frenando al `dadd` un ciclo. Abajo, con adelantamiento, en ese mismo intervalo `StallRAW` queda en 0 y la señal que sube a 1 es `FwdRAW`: el detector confirma que `R1` se puede adelantar y el `dadd` sigue sin esperar. En ambas corridas se ve `IdRegFwdMA` en `02` (`R1 + 1`) mientras el `lw` está en _Memory Access_. Así cada vuelta baja de 10 a 9 ciclos y el programa pasa de 6100 a 5600 ns.»
  ],
)

#slide-script(13, "Bug encontrado: el doble atasco RAW", "1:10",
  cue: "Señalar el daddi r4, r0, 9 a la izquierda y las 4 líneas azules del lazo while a la derecha.",
  [
    «Al correr `fwd_prodesc` sin adelantamiento detectamos un error que ya tenía el procesador original: cuando una instrucción con dos operandos sufre dos atascos RAW seguidos —uno por cada operando—, la instrucción siguiente desaparece y nunca se ejecuta. En esta prueba mínima, el `dadd` se atasca primero por `r1` y después por `r2`, y el `daddi r4, r0, 9` que viene atrás se pierde: `R4` termina en 0 en vez de 9. La causa estaba en `fetch.vhd`: al caer el primer `StallRAW`, _Fetch_ esperaba el flanco de `EnableIF` y buscaba una instrucción nueva sin verificar si el segundo operando había disparado un nuevo `StallRAW`, pisando `IF/ID`. La corrección son las cuatro líneas resaltadas en azul: repetir la espera mientras `StallRAW` siga en `'1'`. También ajustamos 15 ns la consulta visual en `states_machine.vhd`. Con eso, `bug_doble_raw` vuelve a dar `R4 = 9`, `fwd_prodesc` da 46 y `prog_prueba` vuelve a ejecutar su `bnez`.»
  ],
  handoff: [Para cerrar, #orador6 resume la verificación, los archivos entregados y las conclusiones.],
)

// ============================================================================
// ORADOR 6 — FILMINAS 14 A 16
// ============================================================================
#speaker-header(6, orador6, "FILMINAS 14 A 16", "2:00", "Mostrar la solidez de la verificación, el detalle de la entrega y cerrar abriendo a preguntas.")

#slide-script(14, "Verificación: ningún resultado cambió", "0:40",
  cue: "Recorrer los 4 indicadores grandes (10 de 10, 0 errores, R4 igual, R4 = 9).",
  [
    «Toda la verificación se corrió en Active-HDL 17 Student Edition, el simulador de la cátedra. El proyecto compila con _Compile All_ con cero errores y cero advertencias. Ejecutamos las 10 corridas completas —los tres programas en las tres configuraciones más la prueba mínima del bug— y las 10 dieron el resultado exacto: `R4` termina igual en los tres modos, confirmando que el adelantamiento sólo ahorra tiempo (500 ns en las sumas y 400 ns en el producto escalar), y `R4 = 9` en la prueba del bug.»
  ],
)

#slide-script(15, "Qué se entregó", "0:40",
  cue: "Señalar los 3 grupos: 10 archivos de forwarding, 2 del bug y 3 programas .asm.",
  [
    «La entrega consta de 12 archivos VHDL modificados y 3 programas en Assembler. Diez archivos implementan el adelantamiento —desde el genérico `Forwarding` en `usuario.vhd` hasta el detector y el multiplexor en `execute.vhd`— y los otros dos corresponden a la corrección del doble atasco RAW. No se agregó ningún archivo VHDL nuevo: cada uno reemplaza al original en la misma ruta, preservando el orden de compilación, la codificación Latin-1 y marcando cada cambio con el comentario `TP10`.»
  ],
)

#slide-script(16, "Conclusiones y preguntas", "0:40",
  cue: "Repasar los 4 bullets con calma y abrir a preguntas.",
  [
    «En conclusión: implementamos el adelantamiento `load → ALU` del escenario 4c controlable por genérico, bajando el atasco de 2 a 1 ciclo en instrucciones consecutivas y de 1 a 0 con una instrucción intermedia; verificamos que los programas ahorran un ciclo por iteración sin alterar resultados y que con `Forwarding = false` el comportamiento es idéntico al original; y además dejamos corregido el bug del doble atasco RAW. Muchas gracias, quedamos abiertos a preguntas; si quieren, tenemos Active-HDL abierto para correr cualquiera de los programas en vivo.»
  ],
)

// ============================================================================
// ANEXO RÁPIDO: POSIBLES PREGUNTAS DE LA CÁTEDRA
// ============================================================================
#pagebreak()
#block(
  width: 100%,
  inset: (bottom: 8pt),
  stroke: (bottom: 1.5pt + accent),
)[
  #text(size: 14pt, weight: "bold", fill: rgb("#0F172A"))[Anexo — Respuestas rápidas para preguntas de la cátedra]
  #v(2pt)
  #text(size: 9pt, fill: muted)[Ayuda memoria para responder con precisión si los docentes preguntan al final]
]
#v(6pt)

#let qa(q, a) = block(
  width: 100%,
  fill: header-bg,
  stroke: (left: 2.5pt + ink, rest: 0.5pt + rule-col),
  radius: (right: 4pt),
  inset: (x: 10pt, y: 7.5pt),
  breakable: false,
)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#0F172A"))[#q]
  #v(3pt)
  #text(size: 9pt, fill: ink)[#a]
]

#qa("1. ¿Por qué en lw seguido de dadd sigue quedando 1 ciclo de atasco?",
  [Porque dentro del ciclo de 100 ns del TDA, _Execute_ arranca en la ALU a los 50 ns, mientras que el dato de memoria recién sale hacia los 52 ns de _Memory Access_ (y se carga en `MEM/WB` a los 70 ns). No se puede entregar antes de que exista: es el mismo atasco _load-use_ de 1 ciclo del MIPS64 con forwarding.])

#v(5pt)
#qa("2. ¿Qué pasa si hay dos loads seguidos que escriben el mismo registro (ej. lw r1, A; lw r1, B; dadd r4, r4, r1)?",
  [El contador de escrituras pendientes de `r1` vale 2. `CanForwardRAW` exige exactamente 1 escritura pendiente (`GetRWrPending = 1`), así que no adelanta el dato viejo del primer `load` y espera al segundo, igual que el procesador original.])

#v(5pt)
#qa("3. ¿Por qué inhiben el adelantamiento cuando la FPU está ocupada (EXFPUPending ≠ 0)?",
  [La FPU tiene un cauce de 4 ciclos en _Execute_ y puede generar atascos estructurales o WAW que demoren la entrada a _Execute_ de la instrucción dependiente. Si se demora un ciclo más, el dato del `load` ya habría salido de `MEM/WB`. Inhibir el adelantamiento en ese caso garantiza corrección sin complicar la lógica.])

#v(5pt)
#qa("4. ¿Qué pasa si una instrucción usa el mismo registro en ambos operandos (ej. dadd r2, r1, r1)?",
  [Está contemplado: `decode.vhd` evalúa `FwdRAW` en cada lectura de operando y puede marcar tanto `fwd1` como `fwd2` en `ID/EX`, y `ForwardOperands` en `execute.vhd` reemplaza ambos con el dato de `MEM/WB`.])

#v(5pt)
#qa("5. ¿Probaron los programas de la cátedra? ¿Qué pasó con salto.asm y logicas.asm?",
  [Sí. `prog_prueba.asm` (que además disparaba el bug del doble atasco y pasaba de 4700 a 5100 ns al corregirlo) y `desp_bits.asm` (1900 ns) terminan bien. `salto.asm` es un lazo infinito y corta a los 10300 ns por el límite original de 100 instrucciones de `states_machine.vhd`; `logicas.asm` tiene un error de sintaxis propio en la línea 7 (falla a los 29 ns en el ensamblador, que no se tocó).])

#v(5pt)
#qa("6. ¿Por qué en fwd_prodesc se ahorran 4 ciclos y no 8 si hay dos loads por iteración?",
  [En el ciclo 8, `r1` ya podría adelantarse porque `lw r1` está en MA, pero `r5` todavía está en EX y `dmul` se atasca igual. Al reintentar en el ciclo 9, `lw r1` ya escribió `r1` en el banco en su _Writeback_ (25 ns), así que `r1` se lee del banco y sólo `r5` entra por adelantamiento desde `MEM/WB`: 1 ciclo ahorrado por iteración × 4 iteraciones = 4 ciclos.])
