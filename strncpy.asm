@ Data Section
.data
.balign 4
  from: .asciz "Hello, world" @ String inicial.
.balign 4
  to:   .fill 64, 1, 0        @ String de destino.
.balign 4
  out:  .asciz "Result: %s\n" @ String de output.

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =from @ Carregar string inicial.
  LDR  R1, =to   @ Carregar string de destino.
  MOV  R2, #4    @ Guardar número de bytes máximo no terceiro parâmetro.
  BL   strncpy   @ Chamar strncpy().
  BL   printf    @ Chamar printf().
  B    _exit     @ Pedir ao SO para sair.

/*
 * strncpy(R0, R1, R2)
 * R0 - str (from)
 * R1 - str (to)
 * R2 - int (max bytes)
 */
strncpy:
  MOV  R5, R0             @ Conservar R0 em R5.
  PUSH {LR}               @ Reservar LR para nova chamada, strlen().
  BL   _strlen            @ Chamar strlen() para ver tamanho da string.
  POP  {LR}               @ Voltar ao LR de strncpy().

  MOV  R3, #0             @ Inicializar iterador da string.
  strncpy_loop:
    CMP  R3, R2           @ Verificar se chegámos ao máximo de bytes dado.
    BGT  strncpy_loop_end @ break; // se sim.
    LDRB R4, [R5, R3]     @ Carregar byte da string a copiar.
    STRB R4, [R1, R3]     @ Guardar na string de destino.
    ADD  R3, #1           @ Incrementar iterador.
    CMP  R3, R0           @ Verificar se chegou ao tamanho máximo da string.
    BLT  strncpy_loop     @ Se não, continuar iteração.
  strncpy_loop_end:

  LDR  R0, =out           @ Retornar valor da string, uma vez que é retorno direto.
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
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
