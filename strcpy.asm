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
  from: .asciz "Hello, world" @ String de origem.
.balign 4
  to:   .fill 64, 1, 0        @ String de destino (vazia).
.balign 4
  out:  .asciz "Result: %s\n" @ String de output.

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =from @ Carregar string de origem.
  LDR  R1, =to   @ Carregar string de destino.
  PUSH {LR}      @ Reservar LR para strcpy().
  BL   strcpy    @ Chamar strcpy().
  POP  {LR}      @ Voltar ao valor original de LR.
  PUSH {LR}      @ Reservar LR para printf().
  BL   printf    @ Chamar printf().
  POP  {LR}      @ Voltar ao valor original de LR.
  BL   _exit     @ Pedir ao SO para sair.

/*
 * strcpy(R0, R1)
 * R0 - str (from)
 * R1 - str (to)
 */
strcpy:
  MOV  R2, R0         @ Guardar primeira string em R2 para chamar strlen().
  PUSH {LR}           @ Reservar LR para strlen().
  BL   _strlen        @ Chamar strlen() para iterar a string.
  POP  {LR}           @ Voltar ao valor LR de strcpy().

  MOV  R3, #0         @ Inicializar iterador R3 para ambas as strings.
  strcpy_loop:
    LDRB R4, [R2, R3] @ Buscar byte à primeira string.
    STRB R4, [R1, R3] @ Guardar o mesmo byte na string de destino.
    ADD  R3, #1       @ Incrementar R3.
    CMP  R3, R0       @ Verificar se chegou ao tamanho da string.
    BLT  strcpy_loop  @ Se ainda não, continuar iteração.

  LDR R0, =out        @ Retornar string da memória, uma vez que o retorno é feito diretamente.
  BX   LR             @ return;

/*
 * Implementação original
 * em strlen.asm.
 */
_strlen:
  MOV R4, #0
  while:
    ADD  R4, #1
    LDRB R3, [R0, R4]
    CMP  R3, #0
    BNE  while
  MOV R0, R4
  BX  LR

    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
