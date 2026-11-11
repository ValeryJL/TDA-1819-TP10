		.data
VEC:	.word	12, 34, 56, 78
RES:	.word	0

		.code
; -------------------------------------------------------------
; Test 2: Procesamiento secuencial con acumulador y cargas continuas
; -------------------------------------------------------------
; Este programa suma los 4 elementos de un arreglo vectorizado en memoria.
; En un procesador sin forwarding, cada 'lw' genera 3 burbujas de atasco RAW
; antes de poder ser utilizado por la suma ALU 'dadd'.
; Con nuestra implementación del Ejercicio 4c (Forwarding Load -> ALU),
; el stall se reduce de 3 ciclos a sólo 1 ciclo en cada suma acumulativa,
; logrando un speedup significativo en la ejecución del bucle/secuencia.

		lw r1, VEC(r0)		; Carga elemento 0
		dadd r10, r0, r1	; RAW Distancia 1: Forwarding MEM->EX (1 stall vs 3)

		daddi r20, r0, 8	; Offset byte 8
		lw r2, VEC(r20)		; Carga elemento 1
		dadd r10, r10, r2	; RAW Distancia 1: Forwarding MEM->EX (1 stall vs 3)

		daddi r20, r0, 16	; Offset byte 16
		lw r3, VEC(r20)		; Carga elemento 2
		dadd r10, r10, r3	; RAW Distancia 1: Forwarding MEM->EX (1 stall vs 3)

		daddi r20, r0, 24	; Offset byte 24
		lw r4, VEC(r20)		; Carga elemento 3
		dadd r10, r10, r4	; RAW Distancia 1: Forwarding MEM->EX (1 stall vs 3)

		sw r10, RES(r0)		; Guarda el resultado acumulado final (180)
		halt
