		.data
VA:		.word	2, 5, 3, 4 		; primer vector
VB:		.word	6, 1, 7, 2 		; segundo vector
N:		.word	4 				; cantidad de elementos
PROD:	.word	0 				; resultado
		.code
		lw r3, N(r0)			; r3 = contador de elementos
		daddi r2, r0, 0 			; r2 = desplazamiento en VA y VB
		daddi r4, r0, 0 			; r4 = producto escalar parcial
LAZO:	lw r1, VA(r2)			; r1 = VA[i] (load)
		lw r5, VB(r2)			; r5 = VB[i] (load)
		dmul r6, r1, r5 			; ambos operandos vienen de loads
		dadd r4, r4, r6 			; acumular VA[i]*VB[i]
		daddi r2, r2, 4 			; siguiente elemento
		daddi r3, r3, -1 		; un elemento menos
		bnez r3, LAZO 			; repetir si quedan
		sw r4, PROD(r0)			; guardar el resultado
		halt
	
