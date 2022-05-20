.data
.align 4
  out:  .asciz "Result: %s\n" @ String de output.
.align 4 
  str1: .asciz "Hello, "      @ Primeira string (e string de destino).
.align 4
  str2: .asciz "World"        @ Segunda string (e string a concatenar).

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =str1       @ Guardar primeira string em R0 como parâmetro.
  LDR  R1, =str2       @ Guardar segunda string em R1 como parâmetro.
  PUSH {LR}            @ Reservar LR para a chamada de strcat().
  BL   strcat          @ Chamar strcat().
  POP  {LR}            @ Voltar ao valor inicial de LR.
  MOV  R1, R0          @ Ajustar segundo parâmetro com nova string a mostrar.
  LDR  R0, =out        @ Ajustar primeiro parâmetro com string de output.
  BL   printf          @ Chamar printf.
  BL   _exit           @ Pedir ao SO para sair.

strcat:
  PUSH {R0, LR}        @ Reservar R0 e LR para chamar strlen().
  BL   strlen          @ Chamar strlen() para saber o tamanho de R0.
  MOV  R2, R0          @ Mover o valor retornado para R2.
  POP  {R0, LR}        @ Voltar ao valor inicial de R0 e LR.

  MOV  R3, #0          @ Inicializar incrementador de R1.

  strcat_loop:
    LDRB  R4, [R1, R3] @ Buscar caracter em índice R3 da segunda string.
    STRB  R4, [R0, R2] @ Guardar caracter em índice R2 (com tamanho incluído) da primeira string.
    ADD   R3, #1       @ Incrementar incrementador da primeira string.
    ADD   R2, #1       @ Incrementar incrementador da segunda string (já com tamanho incluído).
    CMP   R4, #0       @ Verificar se o caracter é nulo.
    BNE   strcat_loop  @ Se não, ainda não chegou ao seu fim. Continuar iteração.

  BX   LR              @ return;

/*
 * Implementação original
 * em strlen.asm.
 */
strlen:
  MOV R4, #0
  while:
    ADD  R4, #1
    LDRB R3, [R0, R4]
    CMP  R3, #0
    BNE  while
  MOV R0, R4
  BX  LR

_exit:
  MOV R7, #1      @ Exit syscall
  SVC #0          @ Invoke
