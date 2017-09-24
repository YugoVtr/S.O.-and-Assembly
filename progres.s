.data
	first:			.word 3		# N[0] da progressão 
	difference:		.word 2 	# Razão da progressão 
	last:			.word 10	# Ultimo indice da progressão 
	index:			.word 0		# indice corrente da progressão 
	CR:	.word32 0x10000
	DR:	.word32 0x10008
	
.text
main:
	ld r3,first(r0) 
	ld r4,difference(r0)
	ld r5,last(r0)
	ld r6,index(r0)
loop:
	#impressão do N[index]
	lwu r1,CR(r0) ;Control Register
	lwu r2,DR(r0) ;Data Register
	daddi r10,r0,1
	sd r3,(r2) ;r3 output..
	sd r10,(r1) ;.. to screen

	# N[index+1] = N[index] + difference
	dadd r3,r3,r4
	daddi r6,r6,1 
	sd r3,last(r0)
	
	# Enquanto não estiver no indice desejado
	bne r6,r5,loop
	halt 