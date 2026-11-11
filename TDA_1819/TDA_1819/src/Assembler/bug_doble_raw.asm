		.data
A:		.word	5
B:		.word	7
		.code
		lw r1, A(r0)
		lw r2, B(r0)
		dadd r3, r1, r2
		daddi r4, r0, 9
		daddi r5, r0, 11
		halt
	
