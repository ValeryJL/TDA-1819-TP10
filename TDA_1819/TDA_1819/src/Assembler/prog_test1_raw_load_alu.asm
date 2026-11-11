		.data
DATO1:	.word	10
DATO2:	.word	25
RES1:	.word	0
RES2:	.word	0

		.code
; -------------------------------------------------------------
; Test 1: Micro-benchmark de Forwarding Load -> ALU (MEM -> EX)
; -------------------------------------------------------------
; Caso A: Distancia 1 (Load inmediatamente seguido por instrucción ALU)
; Sin Forwarding: 3 ciclos de stall RAW (ID congelado hasta WB)
; Con Forwarding: 1 ciclo de stall RAW (burbuja de carga en EX/MEM) y bypass MEM->EX
		lw r1, DATO1(r0)
		daddi r2, r1, 5		; Dependencia RAW de r1 a distancia 1
		sw r2, RES1(r0)

; Caso B: Distancia 2 (Instrucción independiente intermedia)
; Sin Forwarding: 2 ciclos de stall RAW restantes
; Con Forwarding: 0 ciclos de stall RAW (el dato llega justo a EX desde MEM)
		lw r3, DATO2(r0)
		daddi r4, r0, 100	; Instrucción independiente
		dadd r5, r3, r4		; Dependencia RAW de r3 a distancia 2
		sw r5, RES2(r0)

		halt
