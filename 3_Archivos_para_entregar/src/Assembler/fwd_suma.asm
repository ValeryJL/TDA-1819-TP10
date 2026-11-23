		.data
TABLA:	.word	3, 8, 1, 12, 6 	; vector de 5 enteros
N:		.word	5 				; cantidad de elementos
SUMA:	.word	0 				; resultado
		.code
		lw r3, N(r0)			; r3 = contador de elementos
		daddi r2, r0, 0 			; r2 = desplazamiento en TABLA
		daddi r4, r0, 0 			; r4 = suma parcial
LAZO:	lw r1, TABLA(r2)		; r1 = TABLA[i] (load)
		dadd r4, r4, r1 			; RAW load->ALU inmediata
		daddi r2, r2, 4 			; siguiente elemento
		daddi r3, r3, -1 		; un elemento menos
		bnez r3, LAZO 			; repetir si quedan
		sw r4, SUMA(r0)			; guardar la suma
		halt
	
