// Presentación TP10 — Procesador TDA 1819: adelantamiento load -> ALU (escenario 4c)
// Taller de Arquitectura 2026 · Grupo 11

#let bg-dark = rgb("#131C2B")
#let bg-light = rgb("#F7F5F0")
#let card-bg = rgb("#FFFFFF")
#let card-border = rgb("#E5E2DC")
#let ink-dark = rgb("#111827")
#let ink-muted = rgb("#525B6B")
#let ink-light = rgb("#F8FAFC")
#let ink-light-muted = rgb("#94A3B8")
#let blue = rgb("#2563EB")
#let blue-soft = rgb("#DBEAFE")
#let blue-light = rgb("#60A5FA")
#let stall-bg = rgb("#F5DFD0")
#let stall-ink = rgb("#8C421C")
#let chip-gray = rgb("#EAECEF")
#let amber = rgb("#B45309")

#set document(
  title: "TP10 — Adelantamiento load → ALU en el TDA 1819",
  author: "Grupo 11 — Taller de Arquitectura 2026",
)

#set text(
  font: ("Segoe UI", "Arial"),
  size: 13pt,
  fill: ink-dark,
  lang: "es",
)

#set par(leading: 0.58em, spacing: 0.65em, justify: false)

#show raw.where(block: false): it => text(
  font: ("Consolas", "Courier New"),
  size: 0.92em,
  it,
)

// Slide helpers (16:9 widescreen: 25.4cm x 14.2875cm)
#let light-slide(num, footer-note: "TP10 — Adelantamiento load → ALU", body) = {
  set page(
    width: 25.4cm,
    height: 14.2875cm,
    margin: (top: 1.25cm, bottom: 1.15cm, left: 1.55cm, right: 1.55cm),
    fill: bg-light,
    footer: {
      set text(size: 8.5pt, fill: ink-muted)
      [#num · #footer-note]
    },
  )
  body
}

#let dark-slide(num: none, footer-note: none, body) = {
  set page(
    width: 25.4cm,
    height: 14.2875cm,
    margin: (top: 1.4cm, bottom: 1.15cm, left: 1.65cm, right: 1.65cm),
    fill: bg-dark,
    footer: if num != none {
      set text(size: 8.5pt, fill: ink-light-muted)
      [#num · #footer-note]
    } else { none },
  )
  set text(fill: ink-light)
  body
}

#let slide-title(t) = {
  text(size: 25pt, weight: "bold", fill: ink-dark, t)
  v(14pt)
}

#let stage-box(label, kind: "normal") = {
  let fill-c = if kind == "dr" { stall-bg } else if kind == "xstar" { blue } else if kind == "m" { blue-soft } else { chip-gray }
  let text-c = if kind == "dr" { stall-ink } else if kind == "xstar" { white } else if kind == "m" { blue } else { ink-dark }
  let stroke-c = if kind == "m" { 1.3pt + blue } else { none }
  box(
    width: 1.62cm,
    height: 0.88cm,
    radius: 5pt,
    fill: fill-c,
    stroke: stroke-c,
    align(center + horizon, text(size: 12pt, weight: "semibold", fill: text-c, label)),
  )
}

#let stage-box-sm(label, kind: "normal") = {
  let fill-c = if kind == "dr" { stall-bg } else if kind == "xstar" { blue } else if kind == "m" { blue-soft } else { chip-gray }
  let text-c = if kind == "dr" { stall-ink } else if kind == "xstar" { white } else if kind == "m" { blue } else { ink-dark }
  box(
    width: 1.32cm,
    height: 0.72cm,
    radius: 4pt,
    fill: fill-c,
    align(center + horizon, text(size: 10.5pt, weight: "semibold", fill: text-c, label)),
  )
}

// ============================================================================
// SLIDE 1 — PORTADA
// ============================================================================
#dark-slide[
  #v(0.5cm)
  #text(size: 10pt, weight: "semibold", fill: blue-light, tracking: 1.4pt)[
    TALLER DE ARQUITECTURA 2026 · TRABAJO PRÁCTICO 10
  ]
  #v(0.45cm)
  #text(size: 36pt, weight: "bold", fill: white)[
    Adelantamiento load → ALU en el\ TDA 1819
  ]
  #v(0.35cm)
  #text(size: 14.5pt, fill: ink-light-muted)[
    Escenario 4c: el dato que lee un load llega a la ALU desde el registro MEM/WB, sin esperar al Writeback
  ]
  #v(1.7cm)
  #text(size: 12pt, weight: "bold", fill: white)[Grupo 11 · Noviembre de 2026]
  #v(0.35cm)
  #grid(
    columns: (1fr, 1fr, 1fr),
    row-gutter: 14pt,
    column-gutter: 18pt,
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Burgueño, Martín Andrés]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[03846/1]],
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Dufur, Lázaro]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[03861/9]],
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Graziani, Tomas Fermin Pablo]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[01592/9]],
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Jauregui Lorda, Valeria]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[03209/5]],
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Pernalete Perez, Jose Miguel]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[02224/9]],
    [#text(size: 11.5pt, fill: rgb("#E2E8F0"))[Shimizu, Agustín]\ #text(size: 9.5pt, font: "Consolas", fill: ink-light-muted)[03923/6]],
  )
]

// ============================================================================
// SLIDE 2 — QUÉ NOS TOCÓ: ESCENARIO 4C
// ============================================================================
#light-slide(2)[
  #slide-title[Qué nos tocó: escenario 4c]
  #v(0.35cm)
  #grid(
    columns: (1fr, 3.3cm, 1fr),
    align: horizon,
    column-gutter: 10pt,
    block(
      width: 100%,
      fill: card-bg,
      stroke: 0.8pt + card-border,
      radius: 8pt,
      inset: 18pt,
    )[
      #text(size: 15pt, weight: "bold")[Productor: un load]
      #v(6pt)
      #text(size: 12.5pt, fill: ink-muted)[`lb`, `lh` o `lw` que leen la sección de datos y escriben un registro `R0`–`R15`]
      #v(10pt)
      #text(font: "Consolas", size: 12pt, fill: ink-dark)[lw r1, TABLA(r2)]
    ],
    align(center)[
      #text(size: 32pt, weight: "bold", fill: blue)[→]
      #v(-4pt)
      #text(size: 10pt, weight: "semibold", fill: blue)[dato por\ MEM/WB]
    ],
    block(
      width: 100%,
      fill: card-bg,
      stroke: 0.8pt + card-border,
      radius: 8pt,
      inset: 18pt,
    )[
      #text(size: 15pt, weight: "bold", hyphenate: false)[Consumidor: una aritmético-lógica]
      #v(6pt)
      #text(size: 12.5pt, fill: ink-muted)[Instrucciones enteras que operan en la ALU: `dadd`, `daddi`, `dsub`, `dmul`, `ddiv`, `slt`, `andr`, `ori`, `dsl`… (30 en total)]
      #v(10pt)
      #text(font: "Consolas", size: 12pt, fill: ink-dark)[dadd r4, r4, r1]
    ],
  )
  #v(1.1cm)
  #text(size: 12.5pt, fill: ink-muted)[
    Fuera del escenario, y por eso se atascan como antes: _stores_ y saltos como consumidores, productores aritmético-lógicos (4a, 4b), `lf`, `poph` y la FPU.
  ]
]

// ============================================================================
// SLIDE 3 — HOY EL DATO ESPERA UN CICLO DE MÁS
// ============================================================================
#light-slide(3, footer-note: "TP10 — Adelantamiento load → ALU · F búsqueda, D decodificación, Dr atasco RAW, X ejecución, M memoria, W escritura")[
  #slide-title[Hoy el dato espera un ciclo de más]
  #text(size: 13pt, fill: ink-muted)[
    Sin adelantamiento, un `dadd` que usa el destino de un `lw` inmediatamente anterior pierde 2 ciclos en _Decode_.
  ]
  #v(0.65cm)
  #grid(
    columns: (5.4cm, ..range(8).map(_ => 1.85cm)),
    align: (left + horizon, ..range(8).map(_ => center + horizon)),
    row-gutter: 12pt,
    text(size: 10pt, font: "Consolas", fill: ink-muted)[ciclo],
    ..range(1, 9).map(i => text(size: 10.5pt, font: "Consolas", fill: ink-muted)[#i]),

    text(size: 13.5pt, font: "Consolas", weight: "semibold")[lw r1, A(r0)],
    stage-box("F"), stage-box("D"), stage-box("X"), stage-box("M", kind: "m"), stage-box("W"), [], [], [],

    text(size: 13.5pt, font: "Consolas", weight: "semibold")[dadd r2, r1, r1],
    [], stage-box("F"), stage-box("Dr", kind: "dr"), stage-box("Dr", kind: "dr"), stage-box("D"), stage-box("X"), stage-box("M"), stage-box("W"),
  )
  #v(1.15cm)
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 24pt,
    [#text(weight: "bold", fill: blue)[Ciclo 4:] #text(fill: ink-muted)[el dato ya salió de memoria y queda en #box[`MEM/WB`].]],
    [#text(weight: "bold", fill: stall-ink)[Ciclos 3 y 4:] #text(fill: ink-muted)[el `dadd` espera en _Decode_ a que el `lw` escriba el banco en su _Writeback_.]]
  )
]

// ============================================================================
// SLIDE 4 — LA IDEA: EL DATO VA DE MEM/WB A LA ALU
// ============================================================================
#light-slide(4)[
  #slide-title[La idea: el dato va de MEM/WB a la ALU]
  #grid(
    columns: (14.4cm, 1fr),
    column-gutter: 22pt,
    align: horizon,
    block(
      fill: white,
      stroke: 0.8pt + card-border,
      radius: 8pt,
      inset: 8pt,
    )[
      #image("img/image2.png", width: 100%)
    ],
    [
      #text(weight: "bold", fill: blue)[Camino nuevo:] #text(fill: ink-muted)[del registro `MEM/WB` a un multiplexor delante de la ALU.]
      #v(14pt)
      #text(weight: "bold", fill: blue)[Control nuevo:] #text(fill: ink-muted)[cuatro señales entre las etapas y el detector RAW.]
      #v(14pt)
      #text(fill: ink-muted)[La aritmético-lógica ejecuta en el mismo ciclo en que el `load` hace _Writeback_.]
    ]
  )
]

// ============================================================================
// SLIDE 5 — CUATRO PIEZAS, UNA POR COMPONENTE
// ============================================================================
#light-slide(5)[
  #slide-title[Cuatro piezas, una por componente]
  #v(0.2cm)
  #let piece(num, file, heading, desc) = block(
    width: 100%,
    height: 6.9cm,
    fill: card-bg,
    stroke: (top: 2.5pt + blue, rest: 0.8pt + card-border),
    radius: (bottom: 8pt, top: 3pt),
    inset: 14pt,
  )[
    #text(size: 9.5pt, font: "Consolas", fill: blue)[#num · #file]
    #v(6pt)
    #text(size: 13.5pt, weight: "bold", fill: ink-dark)[#heading]
    #v(8pt)
    #text(size: 11pt, fill: ink-muted)[#desc]
  ]
  #grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    column-gutter: 12pt,
    piece("1", "pipeline_registros", "Avisa qué load entra a MA",
      [Publica `IdRegFwdMA`: el registro destino del `lb`/`lh`/`lw` que entra a _Memory Access_, o 0 si no es adelantable.]),
    piece("2", "raw_waw_detector", "Decide: atasco o adelanto",
      [`ForwardMA` libera el atasco al empezar el ciclo; `CanForwardRAW` evita atascar cuando _Decode_ lee el registro.]),
    piece("3", "decode", "Marca el operando",
      [Avisa con `FwdEnableID` si la instrucción es aritmético-lógica; si `FwdRAW = 1`, marca `fwd1` o `fwd2` y `fwdreg` en `ID/EX`.]),
    piece("4", "execute", "Multiplexor de la ALU",
      [`ForwardOperands` reemplaza el operando por el dato de `MEM/WB`, extendido con ceros, y lo informa en la consola.]),
  )
  #v(0.8cm)
  #text(size: 11.5pt, fill: ink-muted)[
    Las cuatro se activan con el nuevo genérico *`Forwarding`* de `usuario.vhd`. Con `Forwarding = false` el procesador hace exactamente lo mismo que el original.
  ]
]

// ============================================================================
// SLIDE 6 — SE ADELANTA SÓLO SI SE CUMPLE TODO ESTO
// ============================================================================
#light-slide(6)[
  #slide-title[Se adelanta sólo si se cumple todo esto]
  #v(0.2cm)
  #set text(size: 13.5pt)
  + `Forwarding = true` y el cauce activado (`Pipelining = true`).
  + La instrucción en _Decode_ es aritmético-lógica entera.
  + El registro leído (`R0`–`R15`) es el destino del `load` que está en MA en ese ciclo.
  + Es su única escritura pendiente: con dos `loads` al mismo registro, se espera al último.
  + La FPU no tiene operaciones en curso (`EXFPUPending = 0`): sus atascos podrían demorar el _Execute_.
  #v(0.8cm)
  #block(
    width: 100%,
    fill: stall-bg,
    radius: 7pt,
    inset: (x: 16pt, y: 12pt),
  )[
    #text(size: 12.5pt, weight: "semibold", fill: stall-ink)[
      Si falta alguna condición, la instrucción se atasca exactamente como en el TDA original.
    ]
  ]
]

// ============================================================================
// SLIDE 7 — CICLO A CICLO: PRIMERA ITERACIÓN DE fwd_suma
// ============================================================================
#light-slide(7, footer-note: "X* = la ALU usa el dato de MEM/WB (consola: «R1 = 0x00000003 ingresa a la ALU como segundo operando», 1050 ns)")[
  #slide-title[Ciclo a ciclo: primera iteración de `fwd_suma`]
  #grid(
    columns: (5.1cm, ..range(9).map(_ => 1.52cm)),
    align: (left + horizon, ..range(9).map(_ => center + horizon)),
    row-gutter: 7pt,

    text(size: 10.5pt, weight: "bold")[Sin adelantamiento],
    ..range(4, 13).map(i => text(size: 9.5pt, font: "Consolas", fill: ink-muted)[#i]),

    text(size: 11.5pt, font: "Consolas")[lw r1, TABLA(r2)],
    stage-box-sm("F"), stage-box-sm("Dr", kind: "dr"), stage-box-sm("D"), stage-box-sm("X"), stage-box-sm("M"), stage-box-sm("W"), [], [], [],

    text(size: 11.5pt, font: "Consolas")[dadd r4, r4, r1],
    [], [], stage-box-sm("F"), stage-box-sm("Dr", kind: "dr"), stage-box-sm("Dr", kind: "dr"), stage-box-sm("D"), stage-box-sm("X"), stage-box-sm("M"), stage-box-sm("W"),

    text(size: 11.5pt, font: "Consolas")[daddi r2, r2, 4],
    [], [], [], [], [], stage-box-sm("F"), stage-box-sm("D"), stage-box-sm("X"), stage-box-sm("M"),
  )
  #v(0.45cm)
  #grid(
    columns: (5.1cm, ..range(9).map(_ => 1.52cm)),
    align: (left + horizon, ..range(9).map(_ => center + horizon)),
    row-gutter: 7pt,

    text(size: 10.5pt, weight: "bold", fill: blue)[Con adelantamiento],
    ..range(4, 13).map(i => text(size: 9.5pt, font: "Consolas", fill: ink-muted)[#i]),

    text(size: 11.5pt, font: "Consolas")[lw r1, TABLA(r2)],
    stage-box-sm("F"), stage-box-sm("Dr", kind: "dr"), stage-box-sm("D"), stage-box-sm("X"), stage-box-sm("M", kind: "m"), stage-box-sm("W"), [], [], [],

    text(size: 11.5pt, font: "Consolas")[dadd r4, r4, r1],
    [], [], stage-box-sm("F"), stage-box-sm("Dr", kind: "dr"), stage-box-sm("D"), stage-box-sm("X*", kind: "xstar"), stage-box-sm("M"), stage-box-sm("W"), [],

    text(size: 11.5pt, font: "Consolas")[daddi r2, r2, 4],
    [], [], [], [], stage-box-sm("F"), stage-box-sm("D"), stage-box-sm("X"), stage-box-sm("M"), stage-box-sm("W"),
  )
  #v(0.55cm)
  #text(size: 12pt, fill: ink-muted)[
    El `dadd` entra a la ALU en el ciclo 9 en lugar del 10, y todo lo que sigue se adelanta un ciclo: *5 ciclos menos* en las 5 iteraciones.
  ]
]

// ============================================================================
// SLIDE 8 — EL ATRASO LOAD -> ALU BAJA UN CICLO (OSCURA)
// ============================================================================
#dark-slide(num: 8, footer-note: "TP10 — Adelantamiento load → ALU")[
  #text(size: 25pt, weight: "bold", fill: white)[El atraso load → ALU baja un ciclo]
  #v(1.2cm)
  #let stat(from, to, desc) = [
    #line(length: 100%, stroke: 0.6pt + rgb("#334155"))
    #v(10pt)
    #text(size: 46pt, weight: "bold", fill: white)[#from]
    #h(6pt)
    #text(size: 26pt, fill: ink-light-muted)[→]
    #h(6pt)
    #text(size: 46pt, weight: "bold", fill: blue-light)[#to]
    #v(6pt)
    #text(size: 12pt, fill: ink-light-muted)[#desc]
  ]
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 26pt,
    stat("2", "1", [ciclos de atasco con las instrucciones consecutivas]),
    stat("1", "0", [con una instrucción en el medio: desaparece el atasco]),
    stat("0", "0", [con dos o más en el medio no había atasco]),
  )
  #v(1.5cm)
  #text(size: 11.5pt, fill: ink-light-muted)[
    El ciclo que queda es inevitable: el dato sale de memoria a los 52 ns del MA del `load`, cuando la ALU de ese ciclo ya arrancó a los 50 ns. Es el mismo atasco _load-use_ del MIPS64.
  ]
]

// ============================================================================
// SLIDE 9 — PROGRAMAS: CAMBIA LA DISTANCIA LOAD -> USO
// ============================================================================
#light-slide(9, footer-note: "Programas en src/Assembler/ · se eligen con ProgName en usuario.vhd")[
  #slide-title[Programas: cambia la distancia load → uso]
  #let prog-card(name, desc, code, note) = block(
    width: 100%,
    height: 7.4cm,
    fill: card-bg,
    stroke: 0.8pt + card-border,
    radius: 8pt,
    inset: 15pt,
  )[
    #text(size: 13pt, font: "Consolas", weight: "bold", fill: blue)[#name]
    #v(6pt)
    #text(size: 11.2pt, fill: ink-muted)[#desc]
    #v(10pt)
    #text(size: 10.5pt, font: "Consolas", fill: ink-dark)[#code]
    #v(10pt)
    #text(size: 11pt, fill: ink-muted)[#note]
  ]
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 14pt,
    prog-card("fwd_suma", [Suma de un vector de 5 enteros: `SUMA = 30`.],
      [lw r1, TABLA(r2)\ dadd r4, r4, r1],
      [Caso consecutivo: el atasco baja de 2 ciclos a 1 en cada iteración.]),
    prog-card("fwd_suma_reord", [La misma suma con una instrucción reordenada: `SUMA = 30`.],
      [lw r1, TABLA(r2)\ daddi r2, r2, 4\ dadd r4, r4, r1],
      [Distancia 2: con adelantamiento no queda ningún atasco `load → ALU`.]),
    prog-card("fwd_prodesc", [Producto escalar de dos vectores de 4: `PROD = 46`.],
      [lw r1, VA(r2)\ lw r5, VB(r2)\ dmul r6, r1, r5],
      [Dos `loads` seguidos: el doble atasco pasa a uno solo.]),
  )
  #v(0.75cm)
  #text(size: 11.5pt, fill: ink-muted)[
    Los tres incluyen dependencias de otros escenarios (`daddi → bnez`, `dmul → dadd`) que se atascan igual en ambos modos: son el control de que el mecanismo actúa sólo donde corresponde.
  ]
]

// ============================================================================
// SLIDE 10 — TIEMPOS: 4 O 5 CICLOS MENOS CON CAUCE
// ============================================================================
#light-slide(10, footer-note: "Punto 3a · medido en Active-HDL 17 · los tiempos absolutos de fin están en la sección 7 del informe")[
  #slide-title[Tiempos: 4 o 5 ciclos menos con cauce]
  #v(0.15cm)
  #set text(size: 12.5pt)
  #table(
    columns: (1.2fr, 0.75fr, 0.7fr, 1fr, 0.85fr, 1fr),
    align: (left, right, right, right, right, right),
    inset: (x: 8pt, y: 9pt),
    stroke: (x, y) => (
      top: if y == 0 { 1.2pt + ink-dark } else { 0.6pt + card-border },
      bottom: 0.6pt + card-border,
      left: none,
      right: none,
    ),
    table.header(
      [*Programa*], [*Sin cauce*], [*Cauce*], [*Cauce + adel.*], [*Ahorro*], [*CPI*],
    ),
    [`fwd_suma`], [150], [64], text(weight: "bold", fill: blue)[59], text(weight: "bold", fill: blue)[−5 ciclos], [2,13 → *1,97*],
    [`fwd_suma_reord`], [150], [59], text(weight: "bold", fill: blue)[54], text(weight: "bold", fill: blue)[−5 ciclos], [1,97 → *1,80*],
    [`fwd_prodesc`], [165], [69], text(weight: "bold", fill: blue)[65], text(weight: "bold", fill: blue)[−4 ciclos], [2,09 → *1,97*],
  )
  #v(0.8cm)
  #text(size: 12pt, fill: ink-muted)[
    Ciclos de 100 ns, contados desde el primer flanco después del ensamblaje (200 ns) hasta el mensaje de fin. Ensamblaje: 127 ns en las sumas y 157 ns en el producto escalar, igual en todas las configuraciones.
  ]
  #v(0.35cm)
  #text(size: 12pt, fill: ink-muted)[
    Sin cauce el adelantamiento no cambia nada: no hay atascos que evitar. Reordenar y adelantar se suman: `fwd_suma` pasa de 64 a *54 ciclos*.
  ]
]

// ============================================================================
// SLIDE 11 — CÓMO SE COMPRUEBA EN LA SIMULACIÓN
// ============================================================================
#light-slide(11, footer-note: "Consola de Active-HDL 17 · fwd_suma con adelantamiento: los valores adelantados son los 5 elementos de TABLA")[
  #slide-title[Cómo se comprueba en la simulación]
  #block(
    width: 100%,
    fill: white,
    stroke: 0.8pt + card-border,
    radius: 7pt,
    inset: 6pt,
  )[
    #image("img/image3.png", width: 100%)
  ]
  #v(0.45cm)
  #let info-box(head, col, body) = block(
    width: 100%,
    height: 2.85cm,
    fill: card-bg,
    stroke: 0.8pt + card-border,
    radius: 7pt,
    inset: 12pt,
  )[
    #text(size: 11.5pt, font: "Consolas", weight: "bold", fill: col)[#head]
    #v(4pt)
    #text(size: 10.8pt, fill: ink-muted)[#body]
  ]
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 14pt,
    info-box("StallRAW", blue, [Baja a los 900 ns, cuando el `load` entra a MA.]),
    info-box("FwdRAW", blue, [Vale 1 cuando _Decode_ marca `R1` como adelantado.]),
    info-box("R4", ink-dark, [Termina en `1E` (30), igual que sin adelantamiento.]),
  )
]

// ============================================================================
// SLIDE 12 — FORMA DE ONDA: EL ATASCO DESAPARECE
// ============================================================================
#light-slide(12, footer-note: "fwd_suma_reord en Active-HDL 17, de 600 a 1180 ns · la franja marca de 952 a 1001 ns")[
  #slide-title[Forma de onda: el atasco desaparece]
  #block(
    width: 100%,
    fill: white,
    stroke: 0.8pt + card-border,
    radius: 7pt,
    inset: 6pt,
  )[
    #image("img/image4.png", width: 100%)
  ]
  #v(0.45cm)
  #let wave-box(head, col, body) = block(
    width: 100%,
    height: 2.75cm,
    fill: card-bg,
    stroke: 0.8pt + card-border,
    radius: 7pt,
    inset: 12pt,
  )[
    #text(size: 11.5pt, weight: "bold", fill: col)[#head]
    #v(4pt)
    #text(size: 10.8pt, fill: ink-muted)[#body]
  ]
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 14pt,
    wave-box("Sin adelantamiento", stall-ink, [`StallRAW = 1` de 952 a 1001 ns: el `dadd` espera a `R1`.]),
    wave-box("Con adelantamiento", blue, [En ese lapso vale 1 `FwdRAW` y el `dadd` no espera.]),
    wave-box("Resultado", ink-dark, [Cada vuelta tarda 9 ciclos en vez de 10: de 6100 a 5600 ns.]),
  )
]

// ============================================================================
// SLIDE 13 — BUG ENCONTRADO: EL DOBLE ATASCO RAW
// ============================================================================
#light-slide(13, footer-note: "Corrección adicional, independiente del adelantamiento: se aplica con Forwarding = true y false")[
  #slide-title[Bug encontrado: el doble atasco RAW]
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 24pt,
    [
      #text(size: 13.5pt, weight: "bold", fill: stall-ink)[Síntoma: se pierde una instrucción]
      #v(8pt)
      #block(width: 100%, fill: card-bg, stroke: 0.8pt + card-border, radius: 7pt, inset: 12pt)[
        #text(font: "Consolas", size: 10.5pt)[
          lw r1, A(r0)\
          lw r2, B(r0)\
          dadd r3, r1, r2  ; atasco por r1, luego por r2\
          daddi r4, r0, 9  ; nunca se ejecuta
        ]
      ]
      #v(10pt)
      #text(size: 11.2pt, fill: ink-muted)[
        Medido en Active-HDL, con cauce: sin la corrección termina a los 1200 ns con `R4 = 0`; con ella, a los 1300 ns con `R4 = 9`. También pasaba en `fwd_prodesc` sin adelantamiento (`R4 = 0` en lugar de 46) y en `prog_prueba` (se pierde el `bnez`).
      ]
    ],
    [
      #text(size: 13.5pt, weight: "bold", fill: ink-dark)[Causa y corrección en `fetch.vhd`]
      #v(6pt)
      #text(size: 11.2pt, fill: ink-muted)[
        Al terminar un atasco, _Fetch_ esperaba un ciclo y seguía sin mirar si había empezado otro: pisaba la instrucción que esperaba en `IF/ID`.
      ]
      #v(8pt)
      #block(width: 100%, fill: card-bg, stroke: 0.8pt + card-border, radius: 7pt, inset: 12pt)[
        #text(font: "Consolas", size: 10.2pt)[
          WAIT UNTIL falling_edge(StallRAW);\
          WAIT UNTIL rising_edge(EnableIF);\
          #text(fill: blue, weight: "bold")[`while (StallRAW = '1') loop`]\
          #h(10pt)#text(fill: blue)[WAIT UNTIL falling_edge(StallRAW);]\
          #h(10pt)#text(fill: blue)[WAIT UNTIL rising_edge(EnableIF);]\
          #text(fill: blue, weight: "bold")[end loop;]
        ]
      ]
      #v(8pt)
      #text(size: 10.8pt, fill: ink-muted)[
        Y en `states_machine.vhd`, el estado `D_RAW` consulta `StallRAW` 15 ns más tarde (sólo visual).
      ]
    ]
  )
]

// ============================================================================
// SLIDE 14 — VERIFICACIÓN: NINGÚN RESULTADO CAMBIÓ
// ============================================================================
#light-slide(14)[
  #slide-title[Verificación: ningún resultado cambió]
  #v(0.2cm)
  #let kpi(big, col, desc) = [
    #line(length: 100%, stroke: 0.7pt + card-border)
    #v(8pt)
    #text(size: 30pt, weight: "bold", fill: col)[#big]
    #v(4pt)
    #text(size: 11.5pt, fill: ink-muted)[#desc]
  ]
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 32pt,
    row-gutter: 24pt,
    kpi("10 de 10", blue, [corridas con el resultado esperado: 3 programas en 3 configuraciones, más la prueba del bug]),
    kpi("0 errores", ink-dark, [al compilar con _Compile All_ los 12 archivos de la entrega, y 0 advertencias]),
    kpi("R4 igual", ink-dark, [en las tres configuraciones de cada programa: el adelantamiento no cambia el resultado, sólo ahorra tiempo]),
    kpi("R4 = 9", blue, [en la prueba del bug: la instrucción que antes se perdía ahora se ejecuta]),
  )
  #v(0.9cm)
  #text(size: 11.5pt, fill: ink-muted)[
    Todo se verificó en Active-HDL 17 Student Edition, el simulador de la cátedra, con los archivos de la entrega.
  ]
]

// ============================================================================
// SLIDE 15 — QUÉ SE ENTREGA
// ============================================================================
#light-slide(15, footer-note: "Codificación Latin-1 y fin de línea CRLF, como el proyecto original")[
  #slide-title[Qué se entregó]
  #grid(
    columns: (1.55fr, 1fr),
    column-gutter: 16pt,
    block(
      width: 100%,
      height: 7.4cm,
      fill: card-bg,
      stroke: (top: 2.5pt + blue, rest: 0.8pt + card-border),
      radius: (bottom: 8pt, top: 3pt),
      inset: 16pt,
    )[
      #text(size: 14pt, weight: "bold")[Adelantamiento: 10 archivos]
      #v(12pt)
      #grid(
        columns: (1fr, 1fr),
        row-gutter: 10pt,
        text(font: "Consolas", size: 11.5pt)[usuario.vhd], text(font: "Consolas", size: 11.5pt)[decode.vhd],
        text(font: "Consolas", size: 11.5pt)[pc.vhd], text(font: "Consolas", size: 11.5pt)[execute.vhd],
        text(font: "Consolas", size: 11.5pt)[cpu.vhd], text(font: "Consolas", size: 11.5pt)[etapas.vhd],
        text(font: "Consolas", size: 11.5pt)[tipos_cpu.vhd], text(font: "Consolas", size: 11.5pt)[pipeline_registros.vhd],
        text(font: "Consolas", size: 11.5pt)[atascos.vhd], text(font: "Consolas", size: 11.5pt)[raw_waw_detector.vhd],
      )
    ],
    stack(
      spacing: 14pt,
      block(
        width: 100%,
        height: 3.1cm,
        fill: card-bg,
        stroke: (top: 2.5pt + stall-ink, rest: 0.8pt + card-border),
        radius: (bottom: 8pt, top: 3pt),
        inset: 14pt,
      )[
        #text(size: 13.5pt, weight: "bold")[Corrección del bug: 2]
        #v(8pt)
        #text(font: "Consolas", size: 11.5pt)[fetch.vhd\ states_machine.vhd]
      ],
      block(
        width: 100%,
        height: 3.8cm,
        fill: card-bg,
        stroke: (top: 2.5pt + ink-muted, rest: 0.8pt + card-border),
        radius: (bottom: 8pt, top: 3pt),
        inset: 14pt,
      )[
        #text(size: 13.5pt, weight: "bold")[Programas: 3]
        #v(8pt)
        #text(font: "Consolas", size: 11.5pt)[fwd_suma.asm\ fwd_suma_reord.asm\ fwd_prodesc.asm]
      ],
    )
  )
  #v(0.65cm)
  #text(size: 11.2pt, fill: ink-muted)[
    Cada archivo va a su misma ruta dentro de `TDA_1819/src` (tabla de la sección 4 del informe). Ningún archivo es nuevo, así que el orden de compilación no cambia. Cada cambio está marcado con el comentario `TP10`.
  ]
]

// ============================================================================
// SLIDE 16 — CONCLUSIONES (OSCURA)
// ============================================================================
#dark-slide[
  #v(0.4cm)
  #text(size: 28pt, weight: "bold", fill: white)[Conclusiones]
  #v(1.4cm)
  #set text(size: 14.5pt, fill: rgb("#E2E8F0"))
  #set list(spacing: 12pt)
  - El dato de un `load` llega a la ALU un ciclo antes: el atraso `load → ALU` baja de 2 a 1 ciclo, o de 1 a 0.
  - Los programas ahorran un ciclo por iteración sin cambiar ningún resultado.
  - Con `Forwarding = false` el procesador se comporta igual que el original.
  - Encontramos y corregimos un bug que perdía instrucciones ante un doble atasco RAW.
  #v(2.2cm)
  #text(size: 28pt, weight: "bold", fill: blue-light)[¿Preguntas?]
]
