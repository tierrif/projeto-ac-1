/*
 * Instituto Politécnico de Beja
 * Escola Superior de Tecnologia e Gestão
 * Engenharia Informática - Arquitetura de Computadores
 * Projeto de Programação em Assembly para a Arquiterura ARM 1.0
 *
 * Tierri Ferreira, 22897
 * André Azevedo, 22483
 */

@ Data Section
.data
.balign 4
  str1: .asciz "ABCDE" @ String completa.
.balign 4
  str2: .asciz "ABC"   @ Segmento a verificar.
.balign 4
  out: .asciz "%d\n"   @ String de saída para mostrar tamanho do segmento em comum.

.section .text
.global main
.arm

main:
  LDR R0, =str1 @ Carregar a string completa.
	LDR R1, =str2 @ Carregar o segmento a verificar.
  BL  strspn    @ Chamar strspn()
  MOV R1, R0    @ Passar o valor de retorno R0 para o parâmetro R1 de printf.
	LDR R0, =out  @ Carregar string de saída para o printf.
	BL  printf    @ Chamar printf e mostrar valor de retorno.
  B   _exit     @ Pedir ao SO para sair do programa.

strspn:
  PUSH {R4, LR} @ Reservar R4 para este método.
  MOV  R2, #0   @ Inicializar iterador.

  strspn_loop:
    LDRB  R3, [R0, R2] @ Obter caracter no índice R2 da primeira string.
    LDRB  R4, [R1, R2] @ Obter caracter no índice R2 da segunda string.
    CMP   R3, R4       @ Verificar se R3 é igual a R4 (os caracteres)
    ADDEQ R2, #1       @ Se sim, o tamanho do segmento incrementa.
    BEQ   strspn_loop  @ Apenas continua se o segmento continua a ser igual.

  POP {R4, LR}         @ Retornar ao valor prévio de R4.
  MOV R0, R2           @ Retornar o valor de R2 (em R0).
  BX  LR               @ return;

_exit:
  MOV R7, #1           @ Selecionar syscall de saída.
  SVC #0               @ Invocar syscall.
