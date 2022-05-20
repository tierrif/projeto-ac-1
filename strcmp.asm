@ Secção de dados.
.data
.balign 4
  str1: .asciz "wABCDE" @ Primeira string a comparar
.balign 4
  str2: .asciz "abcde"  @ Segunda string a comparar
.balign 4
  out: .asciz "%d\n"    @ String de saída para mostrar valor inteiro em printf.

.global printf
.section .text
.global main
.arm

main: 
  LDR R0, =str1 @ Carregar a primeira string a comparar.
	LDR R1, =str2 @ Carregar a segunda string a comparar.
	BL  strcmp    @ Chamar strcmp()
	MOV R1, R0    @ Passar o valor de retorno R0 para o parâmetro R1 de printf.
	LDR R0, =out  @ Carregar string de saída para o printf.
	BL  printf    @ Chamar printf e mostrar valor de retorno.
  B   _exit     @ Pedir ao SO para sair do programa.
	
strcmp:
  PUSH {R4-R7, LR}     @ Reservar registos R4 a R7 para esta função.

  MOV  R2, #0          @ Inicializar R2, iterador da primeira string.
  MOV  R3, #0          @ Inicializar R3, iterador da segunda string.
	MOV  R6, #0          @ Inicializar R6, contador principal da primeira string.
  MOV  R7, #0          @ Inicializar R7, contador principal da segunda string.
  strcmp_loop:         @ Começar iteração.
    LDRB  R4, [R0, R2] @ Obter caracter no índice R2 (iterador da primeira string).
		LDRB  R5, [R1, R3] @ Obter caracter no índice R3 (iterador da segunda string).
    CMP   R4, #0       @ Verificar se o char é null (chegou ao fim da iteração) (1a).
		ADDNE R2, #1       @ Se ainda não, continuar a iteração e incrementar.
		CMP   R5, #0       @ Fazer o mesmo para o char da 2a string.
		ADDNE R3, #1       @ Continuar a iteração se ainda não chegou ao fim da string (2a).
  
		ADD   R6, R4       @ Adicionar ao contador principal da primeira string.      
		ADD   R7, R5       @ Adicionar ao contador principal da segunda string.
		CMP   R6, R7       @ Verificar se é maior, menor, ou igual.
		BGT   strcmp_gt    @ Entrar no if do maior se é maior.
		BLT   strcmp_lt    @ Se for menor, entrar no if do menor.
		CMP   R4, #0       @ Verifica novamente se o char da primeira string é null.
		BNE   strcmp_loop  @ Se não é, continua a iteração (ainda não terminou).
		CMP   R5, #0       @ Verifica novamente se o char da segunda string é null.
		BNE   strcmp_lt    @ Se não é e a primeira é null, então a primeira é menor.
		BEQ   strcmp_eq    @ Se for null, significa que ambas são null, então são iguais.

		B     strcmp_loop  @ Continua iteração.
	@ strcmp_loop_end
				
	strcmp_gt: 
		MOV R0, #1         @ Retornar 1 (greater than).
    POP {R4-R7, LR}    @ Voltar aos valores prévios dos registos reservados.
		BX  LR             @ return;

  strcmp_lt:
		MOV R0, #-1        @ Retornar -1 (lower than).
    POP {R4-R7, LR}    @ Voltar aos valores prévios dos registos reservados.
    BX  LR             @ return;

	strcmp_eq:
		MOV R0, #0         @ Retornar 0 (equal).
    POP {R4-R7, LR}    @ Voltar aos valores prévios dos registos reservados.
		BX  LR             @ return;
@ strcmp_end

_exit:
    MOV R7, #1         @ Selecionar syscall de saída.
    SVC #0             @ Invocar syscall.
