@ Data Section
.data
.balign 4
  from: .asciz "Hello, world" @ String inicial.
.balign 4
  to:   .fill 64, 1, 0        @ String vazia para output.
.balign 4
  out:  .asciz "Result: %s\n" @ String de output.

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =from @ Carregar string inicial.
  LDR  R1, =to   @ Carregar string destino.
  MOV  R2, #4    @ Setar parâmetro 3 de memcpy() com quantidade de bytes a copiar.
  PUSH {LR}      @ Reservar LR para memcpy().
  BL   memcpy    @ Chamar memcpy().
  POP  {LR}      @ Retornar ao valor original de LR.
  PUSH {LR}      @ Fazer o mesmo para printf.
  LDR  R0, =out  @ Ajustar primeiro parâmetro de printf com string de output.
  BL   printf    @ Chamar printf.
  POP  {LR}      @ Retornar ao valor original de LR.
  BL   _exit     @ Pedir ao SO para sair do programa.

/*
 * memcpy(R0, R1, R2)
 * R0 - str (from)
 * R1 - str (to)
 * R2 - int (max bytes)
 */
memcpy:
  MOV  R5, R0            @ Guardar R0 em R5 porque vai ser alterado pelo retorno de strlen().
  PUSH {LR}              @ Reservar LR para strlen().
  BL   _strlen           @ Chamar strlen() para conseguir iterar a string dada.
  POP  {LR}              @ Retornar ao valor de LR desta função memcpy().

  MOV  R3, #0            @ Inicializar iterador do loop.
  memcpy_loop:      
    CMP  R3, R2          @ Verificar se o número máximo de bytes foi atingido.
    BGT  memcpy_loop_end @ break; // se sim.
    LDRB R4, [R5, R3]    @ Buscar caracter da string inicial em índice R3 do iterador.
    STRB R4, [R1, R3]    @ Guardar no mesmo índice na string vazia do output.
    ADD R3, #1           @ Incrementar iterador.
    CMP R3, R0           @ Verificar se excedeu o tamanho da string.
    BLT memcpy_loop      @ Se ainda não, continuar iteração.
  memcpy_loop_end:

  MOV R0, #0             @ Retornar sempre null (void), uma vez que a única coisa alterada foi em memória.
  BX   LR                @ return;

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
