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
  BL  strlwr    @ Chamar strlwr().
  MOV R1, R0    @ Mover resultado para segundo parâmetro.
  LDR R0, =out  @ Carregar string de output.
  BL  printf    @ Chamar printf().
  BL   _exit    @ Pedir ao SO para sair.

/*
 * strlwr(R0)
 * R0 - str
 */
strlwr:
  MOV R1, R0              @ Conservar R0 em R1.
  PUSH {LR}               @ Reservar LR para strlen().
  BL   _strlen            @ Chamar strlen() para iterar R0 (agora R1).
  POP  {LR}               @ Voltar a LR de strlwr().
  MOV  R4, R0             @ Mover tamanho para R4.
  LDR  R6, =to            @ Carregar string de destino.
    
  MOV R2, #0              @ Iterador do loop.
  strlwr_loop:   
    LDRB  R3, [R1, R2]    @ Carregar byte no índice R2 da string.

    PUSH  {R0, LR}        @ Reservar R0 e LR para não dar conflitos com R0.
    MOV   R0, R3          @ Colocar o byte como primeiro parâmetro.
    BL    isupper         @ Chamar isupper() para ver se é maiúscula.
    MOV   R5, R0          @ Mover booleano retornado para R5.
    POP   {R0, LR}        @ Retornar ao valor inicial de R0 e LR.
   
    CMP   R5, #0          @ Verificar se é false.
    ADDGT R3, #32         @ Se não, transformar em minúscula.
    STRB  R3, [R6, R2]    @ Guardar byte na nova string.

    ADD   R2, #1          @ Incrementar iterador.
    CMP   R2, R4          @ Verificar se chegámos ao tamanho da string.
    BNE   strlwr_loop     @ Se não, continuar iteração.

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
 * em isupper.asm.
 */
isupper:
  CMP   R0, #'A'
  MOVLT R0, #0
  BLT   exit_isupper
  CMP   R0, #'Z'
  MOVGT R0, #0
  BGT   exit_isupper
  MOVLE R0, #1
  exit_isupper:
  BX   LR
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
