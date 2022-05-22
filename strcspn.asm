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
  string:  .asciz "Hello, world" @ String onde o caracter será procurado.
.balign 4
  string2: .asciz ","            @ String com caracter a procurar.
.balign 4
  result:  .asciz "Result: %d\n" @ String de output.

.section .text
.global main
.arm

main:
  LDR  R0, =string  @ Carregar string principal.
  LDR  R1, =string2 @ Carregar string com caracter a procurar.
  PUSH {R7, R8, LR} @ Reservar R7, R8 e LR para strcspn() (R7 e R8 incluídos por serem especiais).
  BL   strcspn      @ Chamar strcspn().
  POP  {R7, R8, LR} @ Retornar aos valores originais de R7, R8 e LR.
  MOV  R1, R0       @ Mover o valor retornado para o segundo parâmetro de printf.
  LDR  R0, =result  @ Carregar string de output.
  BL   printf       @ Chamar printf().
  BL   _exit        @ Pedir ao SO para sair.

/*
 * strcspn(R0, R1)
 * R0 - str
 * R1 - str
 */
strcspn:
  MOV  R2, #0                @ Contador para strcspn_loop.
  MOV  R3, R0                @ Guardar R0 em R3 uma vez que strlen() será chamado.
  MOV  R4, #0                @ Counter para strcspn_str_loop.

  PUSH {R1-R5, LR}           @ Conservar R1 a R5 e LR na chamada de strlen().
  BL   _strlen               @ Chamar strlen() para a primeira string.
  POP  {R1-R5, LR}           @ Voltar aos valores iniciais dos registos.
  PUSH {R0-R5, LR}           @ Fazer o mesmo, mas incluindo R0 agora.
  MOV  R0, R1                @ Mover R1 para R0 para fazer o mesmo com a segunda string.
  BL   _strlen               @ Chamar strlen() para a segunda string.
  MOV  R7, R0                @ Mover o valor retornado para R7.
  POP  {R0-R5, LR}           @ Voltar aos valores iniciais dos registos.
  strcspn_str_loop:
    LDRB R6, [R1, R4]        @ Carregar byte da segunda string.
    ADD  R4, #1              @ Incrementar R4, contador de strcspn_str_loop.
    strcspn_loop:            
      LDRB  R5, [R3, R2]     @ Carregar byte da primeira string no índice R2 (contador de strcspn_loop).
      CMP   R5, R6           @ Verificar se este é igual ao byte atual da segunda string no loop acima.
      MOVEQ R0, R2           @ Se sim, retornar o valor deste índice, porque é a primeira ocorrência.
      BEQ   strcspn_loop_end @ break; // se sim.
      ADD   R2, #1           @ Incrementar o contador deste loop.
      CMP   R2, R0           @ Verificar se chegámos ao length da string.
      BLT   strcspn_loop     @ Se ainda não, continuar iteração.
    strcspn_loop_end:
    CMP  R4, R7              @ Verificar se chegámos ao length da segunda string.
    BLT  strcspn_str_loop    @ Se não, continuar iteração.

  BX   LR                    @ return;

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
