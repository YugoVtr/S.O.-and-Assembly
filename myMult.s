.data
	A:	.word 3
	I:	.word 0 
	B:	.word 2
	C:	.word 0
	CR:	.word32 0x10000
	DR:	.word32 0x10008
	
.text
main:
	ld r3,C(r0) 
	ld r4,A(r0)
	ld r5,B(r0)
	ld r6,I(r0)
loop:
	dadd r3,r3,r4
	daddi r6,r6,1
	NOP
	bne r6,r5,loop 
	sd r3,C(r0)
	
	lwu r1,CR(r0) ;Control Register
	lwu r2,DR(r0) ;Data Register
	daddi r10,r0,1
	sd r3,(r2) ;r3 output..
	sd r10,(r1) ;.. to screen
	halt 