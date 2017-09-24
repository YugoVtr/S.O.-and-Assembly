; nasm -f elf64 hanoi.asm && gcc -m64 -o hanoi hanoi.o && ./hanoi
; A torre destino e representada pela torre C
; Para Vizualizar o conteudo da torre C apos o fim do jogo retire o comentario na linha 91

; By: Vitor Hugo R. Miranda
; Atividade desenvolvida durante disciplica de Arquitetura I 


SECTION .data
	out_int: db "%d", 10, 0
	out_str: db "%s", 10, 0
	param_num_disc: db "%d", 0
	msg_fim: db " Fim ", 0
	msg_num_disc: db " Informe a quantidade de discos N : ", 0 
	
	; ====================================================================================
	; ========================= RESERVA AS TORRES ========================================
	; ====================================================================================
	
	I: dw 0                     ; Numero de jogadas realizadas
	N: dw 0                     ; Numero de discos                         
	A: times 65536 dw 0         ; Torre A 
	B: times 65536 dw 0         ; Torre B
    C: times 65536 dw 0         ; Torre C 
	topo_A: dw -2               ; Topo da Torre A (Vazia)
	topo_B: dw -2               ; Topo da Torre B (Vazia)
    topo_C: dw -2               ; Topo da Torre C (Vazia)
    jogada: dw 0                ; jogada a ser realizada
    
    topo_Origem: dw -2          ; Topo da torre de origem na movimentação
    topo_Destino: dw -2         ; Topo da torre de destino na movimentação

SECTION .text
	global main
	extern printf
	extern scanf

main:

	; ====================================================================================
	; ========================= INICIALIZA A TORRE ORIGEM ================================
	; ====================================================================================
	
    CALL LEITURA_NUM_DISCOS
    CALL INIT_TORRE_ORIGEM

    ; --------------------------- Define a jogada inicial --------------------------------
	XOR rdx, rdx
	MOV dx, [N]
	
    CALL PAR_OU_IMPAR
    
	XOR rax, rax                
	XOR rbx, rbx
	XOR rcx, rcx
    MOV rax, A                  
    
	CMP dx, 0                   ; Se o numero de disco for par                  
	JZ PRIMEIRA_JOGADA_B        ; A primeira jogada e para a torre B
	JG PRIMEIRA_JOGADA_C        ; Caso contrario a primeira jogada e para torre C 

    PRIMEIRA_JOGADA_C:
	    MOV rbx, B
	    MOV rcx, C
	    JMP INICIO
    
    PRIMEIRA_JOGADA_B:
	    MOV rbx, C
	    MOV rcx, B
	; -------------------------------------- HANOI --------------------------------------
INICIO:	
	XOR rdx,rdx                 ;Topo da torre A((N-1)*2)
	MOV dx, [N]
	DEC dx
	ADD dx,dx;
	MOV [topo_A], dx            
	MOV [N], dx
	
	; ----------------------------- Conta as jogadas -------------------------------------    
	INC word[I]; 

    ; ====================================================================================
	; ========================= VERIFICA SE O JOGO TERMINOU ==============================
	; ====================================================================================
JOGADAS:
    XOR rdx, rdx
    XOR rsi, rsi
    MOV si, [topo_C]
    MOV dx, [N]
    CMP si,dx                   ;Verifica se a torre destino esta cheia
    ;JZ IMPRIMIR
    JZ FIM_STR
    
    XOR rdx, rdx
    MOV dx, [jogada]
    CMP dx, 0
    JZ MOV_AC
    CMP dx, 1
    JZ MOV_AB
    CMP dx, 2
    JZ MOV_BC
    JMP FIM

    
	; --------------------------- Movimentação entre A e C --------------------------------
	MOV_AC:
    XOR rdx, rdx
    XOR rsi, rsi
    MOV si, [topo_A]
    MOV dx, [topo_C]
    CMP dx, -2
    JZ A_TO_C                   ;Verifica se há alguma torre vazia
    CMP si, -2
    JZ C_TO_A
    
    PUSH rbx
	XOR rbx,rbx
	XOR rdx,rdx
	MOV bx, word[topo_C]   
	MOV dx, word[topo_A]
	
	XOR rsi,rsi
	XOR rdi,rdi
	MOV di, [rcx+rbx]           ;Valor no topo de C
	MOV si, [rax+rdx]           ;Valor no topo de A    
	
	POP rbx        
    
    CMP di,si
    JG A_TO_C
    JL C_TO_A

	A_TO_C:
		XOR rsi, rsi
		MOV si, [topo_C]
		ADD si, 2 
		MOV [topo_C], si
		
		PUSH rbx
		XOR rbx,rbx
		XOR rdx,rdx
		MOV bx, [topo_C]   
		MOV dx, [topo_A]
		
		XOR rsi,rsi
		MOV si, [rax+rdx]           ;Move o topo da torre A             
		MOV word [rcx+rbx],si       ;Para o tpo da torre C
		MOV word [rax+rdx], 0
		POP rbx 
		
		XOR rdx, rdx
		MOV dx, [topo_A]
		ADD dx, -2
		MOV [topo_A], dx

		XOR rdx, rdx
		MOV dx, [jogada]
		INC dx
		MOV [jogada], dx
		JMP JOGADAS

	C_TO_A:
		XOR rsi, rsi
		MOV si, [topo_A]
		ADD si, 2 
		MOV [topo_A], si

		PUSH rbx
		XOR rbx,rbx
		XOR rdx,rdx
		MOV bx, word[topo_C]   
		MOV dx, word[topo_A]
		
		XOR rsi,rsi
		MOV si, [rcx+rbx]           ;Move o topo da torre C             
		MOV word[rax+rdx],si        ;Para o tpo da torre A
		MOV word [rcx+rbx], 0
		POP rbx 
								
		XOR rdx, rdx				;Decremento a torre origem
		MOV dx, [topo_C]
		ADD dx, -2
		MOV [topo_C], dx

		XOR rdx, rdx
		MOV dx, [jogada]
		INC dx
		MOV [jogada], dx
		JMP JOGADAS
	; --------------------------- Movimentação entre A e B --------------------------------

MOV_AB:
    XOR rdx, rdx
    XOR rsi, rsi
    MOV si, [topo_A]
    MOV dx, [topo_B]
    CMP dx, -2
    JZ A_TO_B               ;Verifica se há alguma torre vazia
    CMP si, -2
    JZ B_TO_A

    PUSH rcx
	XOR rcx,rcx
	XOR rdx,rdx
	MOV cx, [topo_B]   
	MOV dx, [topo_A]
	
	XOR rsi,rsi
	XOR rdi,rdi
	MOV di, [rbx+rcx]           ;Valor no topo de B
	MOV si, [rax+rdx]           ;Valor no topo de A 
	
	POP rcx
	          
    CMP di,si
    JG A_TO_B
    JL B_TO_A

	A_TO_B:
		XOR rsi, rsi
		MOV si, [topo_B]
		ADD si, 2 
		MOV [topo_B], si

		PUSH rcx
		XOR rcx,rcx
		XOR rdx,rdx
		MOV cx, [topo_B]   
		MOV dx, [topo_A]
		
		XOR rsi,rsi
		MOV si, [rax+rdx]            ;Move o topo da torre A             
		MOV word [rbx+rcx],si        ;Para o tpo da torre B
		MOV word [rax+rdx], 0
		POP rcx 
			
		XOR rdx, rdx				;Decremento a torre origem
		MOV dx, [topo_A]
		ADD dx, -2
		MOV [topo_A], dx

		XOR rdx, rdx
		MOV dx, [jogada]
		INC dx
		MOV [jogada], dx
		JMP JOGADAS

	B_TO_A:
		XOR rsi, rsi
		MOV si, [topo_A]
		ADD si, 2 
		MOV [topo_A], si

		PUSH rcx
		XOR rcx,rcx
		XOR rdx,rdx
		MOV cx, [topo_B]   
		MOV dx, [topo_A]
		
		XOR rsi,rsi
		MOV si, [rbx+rcx]           ;Move o topo da torre B             
		MOV word[rax+rdx],si        ;Para o tpo da torre A
		MOV word[rbx+rcx], 0
		POP rcx 
		
		XOR rdx, rdx				;Decremento a torre origem
		MOV dx, [topo_B]
		ADD dx, -2
		MOV [topo_B], dx

		XOR rdx, rdx
		MOV dx, [jogada]
		INC dx
		MOV [jogada], dx
		JMP JOGADAS
	; --------------------------- Movimentação entre B e C --------------------------------
MOV_BC:
	XOR rdx, rdx
    XOR rsi, rsi
    MOV si, [topo_B]
    MOV dx, [topo_C]
    CMP dx, -2
    JZ B_TO_C               ;Verifica se há alguma torre vazia
    CMP si, -2
    JZ C_TO_B
    
    PUSH rax
	XOR rax,rax
	XOR rdx,rdx
	MOV ax, [topo_B]   
	MOV dx, [topo_C]

	XOR rsi,rsi
	XOR rdi,rdi
	MOV di, [rcx+rdx]           ;Valor no topo de C
	MOV si, [rbx+rax]           ;Valor no topo de B
	
	POP rax     
	       
    CMP di,si
    JG B_TO_C
    JL C_TO_B

	B_TO_C:
		XOR rsi, rsi
		MOV si, [topo_C]
		ADD si, 2 
		MOV [topo_C], si

		PUSH rax
		XOR rax,rax
		XOR rdx,rdx
		MOV ax, [topo_C]   
		MOV dx, [topo_B]
		
		XOR rsi,rsi
		MOV si, [rbx+rdx]            ;Move o topo da torre A             
		MOV word [rcx+rax],si        ;Para o tpo da torre C
		MOV word [rbx+rdx], 0
		POP rax 
		
		XOR rdx, rdx				 ;Decremento a torre origem
		MOV dx, [topo_B]
		ADD dx, -2
		MOV [topo_B], dx

		XOR rdx, rdx
		MOV dx, 0
		MOV [jogada], dx
		JMP JOGADAS

	C_TO_B:
		XOR rsi, rsi
		MOV si, [topo_B]
		ADD si, 2 
		MOV [topo_B], si

		PUSH rax
		XOR rax,rax
		XOR rdx,rdx
		MOV ax, [topo_C]   
		MOV dx, [topo_B]
		
		XOR rsi,rsi
		MOV si, [rcx+rax]           ;Move o topo da torre C             
		MOV word[rbx+rdx],si        ;Para o tpo da torre A
		MOV word [rcx+rax], 0
		POP rax 
		
		XOR rdx, rdx				;Decremento a torre origem
		MOV dx, [topo_C]
		ADD dx, -2
		MOV [topo_C], dx

		XOR rdx, rdx
		MOV dx, 0
		MOV [jogada], dx

		JMP JOGADAS
	; ====================================================================================
	; ================================== FINAIS E IMPRESSÕES =============================
	; ==================================================================================== 	
FIM:
	PUSH rbp
	
	XOR rsi,rsi
	MOV rdi,out_int 
    MOV si, [C+rbx]
	MOV rax,0
	CALL printf
	
	POP rbp
	JMP IMPRIMIR_POSICAO
	
FIM_STR:
	PUSH rbp
	
	XOR rsi,rsi
	MOV rdi,out_str
    MOV rsi, msg_fim
	MOV rax,0
	CALL printf
	
	POP rbp
	RET
	
	; ====================================================================================
	; =================================== MODULOS ========================================
	; ====================================================================================
	
	; -------------------------------- Leitura do numero de discos -----------------------
    LEITURA_NUM_DISCOS:
    	PUSH rbp
    	XOR rsi,rsi
    	MOV rdi,out_str
        MOV rsi, msg_num_disc
    	MOV rax,0
    	CALL printf
    	POP rbp
    	
    	PUSH rbp    
        MOV rdi,param_num_disc
        MOV rsi,N
        MOV rax,0
        CALL scanf          
        POP rbp
        RET
        
    ; -------------------------------- Inicializa a Torre de Origem ----------------------
    INIT_TORRE_ORIGEM:
        XOR rax, rax
        XOR rbx, rbx
        XOR rcx, rcx
        MOV rax, A				    ;declara a torre origem
        MOV rbx, 0				    ;declara o i para marchar o disco    
        MOV rcx, [N]			    ;declara o limite   
    
        INICIA_TORRE: 				;inicia Torre Origem
            CMP rbx, rcx            ;for(i=n,i!=0,i--)                    
            JZ FIM_LOOP_INIT     		
            MOV [rax], rcx			;rax[i] = rcx;
            DEC rcx					;i--
            ADD rax, 2 				;rax[i]++
            JMP INICIA_TORRE
        FIM_LOOP_INIT:
            RET
        
    ; ------------------------ Verifica se um numero e mpar ou par -----------------------
    PAR_OU_IMPAR: 
        CMP dx, 2            
        JL FIM_LOOP
        SUB dx, 2
        JMP PAR_OU_IMPAR
        FIM_LOOP:
            RET
	 ; ---------------------------------- Imprimir Torre ---------------------------------
	 IMPRIMIR: 
		XOR rbx, rbx
		MOV bx, word[topo_C]
		ADD bx,2 
						
		IMPRIMIR_POSICAO:
			CMP bx, 0
			JZ FIM_IMPRIMIR
			SUB bx, 2 
			JMP FIM
		FIM_IMPRIMIR:
			JMP FIM_STR

            
