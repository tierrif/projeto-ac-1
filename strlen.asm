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
  string: .asciz "Hello, world" @ String a verificar.
.balign 4
  out:    .asciz "Length: %d\n" @ String de output.

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =string    @ Carregar string a verificar.
  PUSH {LR}           @ Reservar LR para strlen().
  BL   strlen         @ Chamar strlen().
  POP  {LR}           @ Voltar ao valor inicial de LR.
  MOV  R1, R0         @ Mover retorno para segundo parâmetro.
  LDR  R0, =out       @ Carregar string de output.
  BL   printf         @ Chamar printf().
  BL   _exit          @ Pedir ao SO para sair.

strlen:
  MOV R4, #0          @ Inicializar iterador.
  while:
    ADD  R4, #1       @ Incrementar iterador.
    LDRB R3, [R0, R4] @ Retirar byte da string.
    CMP  R3, #0       @ Verificar se chegámos ao fim da string.
    BNE  while        @ Se ainda não, continuar iteração.
  MOV R0, R4          @ Retornar tamanho (número de iterações.)
  BX  LR              @ return;

    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
