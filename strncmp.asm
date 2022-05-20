@ Secção de dados.
.data
.balign 4
  str1: .asciz "abcde"  @ Primeira string a comparar
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
	MOV R2, #2    @ Índice máximo a comparar.
	BL  strncmp   @ Chamar strncmp()
	MOV R1, R0    @ Passar o valor de retorno R0 para o parâmetro R1 de printf.
	LDR R0, =out  @ Carregar string de saída para o printf.
	BL  printf    @ Chamar printf e mostrar valor de retorno.
  B   _exit     @ Pedir ao SO para sair do programa.
	
strncmp:
  PUSH {R5-R8, LR}       @ Reservar registos R5 a R8 para esta função.

  MOV  R3, #0            @ Inicializar R3, iterador da primeira string.
  MOV  R4, #0            @ Inicializar R4, iterador da segunda string.
	MOV  R7, #0            @ Inicializar R7, contador principal da primeira string.
  MOV  R8, #0            @ Inicializar R8, contador principal da segunda string.
  strncmp_loop:          @ Começar iteração.
    LDRB  R5, [R0, R3]   @ Obter caracter no índice R3 (iterador da primeira string).
		LDRB  R6, [R1, R4]   @ Obter caracter no índice R4 (iterador da segunda string).
    CMP   R5, #0         @ Verificar se o char é null (chegou ao fim da iteração) (1a).
		ADDNE R3, #1         @ Se ainda não, continuar a iteração e incrementar.
		CMP   R6, #0         @ Fazer o mesmo para o char da 2a string.
		ADDNE R4, #1         @ Continuar a iteração se ainda não chegou ao fim da string (2a).
  
		ADD   R7, R5         @ Adicionar ao contador principal da primeira string.      
		ADD   R8, R6         @ Adicionar ao contador principal da segunda string.

		CMP R2, R3           @ Verificar se n chegou ao valor máximo.
		BGT	strncmp_loop_end @ Se for maior (length), sair.
		CMP R5, #0           @ Verificar se o primeiro char é nulo e a iteração chegou ao fim.
		BNE strncmp_loop     @ Se ainda não, continuar a iteração.
		CMP R6, #0           @ Verificar o mesmo para o segundo char.
		BNE strncmp_lt       @ Se não é e R5 é nulo, então o primeiro é menor.
		BEQ strncmp_eq       @ Se é igual, então são iguais.
	strncmp_loop_end:

		CMP R7, R8           @ Verificar qual a maior string.
		BGT strncmp_gt       @ Maior.
		BLT strncmp_lt       @ Menor.
		BEQ strncmp_eq       @ Igual.
	@ strncmp_loop_end
				
	strncmp_gt: 
		MOV R0, #1         @ Retornar 1 (greater than).
    POP {R5-R8, LR}    @ Voltar aos valores prévios dos registos reservados.
		BX  LR             @ return;

  strncmp_lt:
		MOV R0, #-1        @ Retornar -1 (lower than).
    POP {R5-R8, LR}    @ Voltar aos valores prévios dos registos reservados.
    BX  LR             @ return;

	strncmp_eq:
		MOV R0, #0         @ Retornar 0 (equal).
    POP {R5-R8, LR}    @ Voltar aos valores prévios dos registos reservados.
		BX  LR             @ return;
@ strncmp_end

_exit:
  MOV R7, #1         @ Selecionar syscall de saída.
  SVC #0             @ Invocar syscall.
