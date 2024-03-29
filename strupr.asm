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
  from: .asciz "HELLO, world" @ String a transformar.
.balign 4
  to:   .fill 64, 1, 0        @ String de destino.
.balign 4
  out:  .asciz "Result: %s\n" @ String de output.

.global printf

.section .text
.global main
.arm

main:
  LDR R0, =from @ Carregar string a transformar.
  BL  strupr    @ Chamar strupr().
  MOV R1, R0    @ Mover resultado para segundo parâmetro.
  LDR R0, =out  @ Carregar string de output.
  BL  printf    @ Chamar printf().
  BL   _exit    @ Pedir ao SO para sair.

/*
 * strupr(R0)
 * R0 - str
 */
strupr:
  MOV R1, R0              @ Conservar R0 em R1.  
  PUSH {LR}               @ Reservar LR para strlen().
  BL   _strlen            @ Chamar strlen() para iterar R0 (agora R1).
  POP  {LR}               @ Voltar a LR de strlwr().
  MOV  R4, R0             @ Mover tamanho para R4.
  LDR  R6, =to            @ Carregar string de destino.
  
  MOV R2, #0              @ Iterador do loop.
  strupr_loop:
    LDRB  R3, [R1, R2]    @ Carregar byte no índice R2 da string.

    PUSH  {R0, LR}        @ Reservar R0 e LR para não dar conflitos com R0.
    MOV   R0, R3          @ Colocar o byte como primeiro parâmetro.
    BL    islower         @ Chamar islower() para ver se é minúscula.
    MOV   R5, R0          @ Mover booleano retornado para R5.
    POP   {R0, LR}        @ Retornar ao valor inicial de R0 e LR.

    CMP   R5, #0          @ Verificar se é false.
    SUBGT R3, #32         @ Se não, transformar em maiúscula.
    STRB  R3, [R6, R2]    @ Guardar byte na nova string.

    ADD   R2, #1          @ Incrementar iterador.
    CMP   R2, R4          @ Verificar se chegámos ao tamanho da string.
    BNE   strupr_loop     @ Se não, continuar iteração.

  LDR  R0, =to            @ Retornar valor de memória uma vez que retorno é direto.
  BX   LR                 @ return;

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

/*
 * Implementação original
 * em islower.asm.
 */
islower:
  CMP   R0, #'a'
  MOVLT R0, #0
  BLT   exit_islower

  CMP   R0, #'z'
  MOVGT R0, #0
  BGT   exit_islower
  MOVLE R0, #1
  
  exit_islower:
  BX   LR
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
