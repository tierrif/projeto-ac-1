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
  string: .asciz "Hello, world" @ String principal.
.balign 4
  out:    .asciz "%d\n"         @ Output.
.balign 4
  strchr: .fill 2, 1, 0         @ String vazia para um char numa string.

.global printf
.section .text
.global main
.arm

main:
  LDR  R0, =string        @ Carregar string principal para R0 e obter o seu tamanho.
  PUSH {LR}               @ Reservar LR para a função strlen().
  BL   _strlen            @ Chamar strlen() uma vez que é necessário saber o tamanho da string.
  POP  {LR}               @ Voltar ao valor normal de LR.
  MOV  R2, R0             @ Ajustar valor do parâmetro 3 do memchr() com o tamanho (retorno de strlen()).
  LDR  R0, =string        @ Re-carregar string devido ao facto de R0 ter sido reutilizado.
  MOV  R1, #'o'           @ Segundo parâmetro, char em byte.
  PUSH {LR}               @ Reservar LR novamente para memchr().
  BL   memchr             @ Chamar memchr().
  POP  {LR}               @ Voltar ao valor normal de LR.
  MOV  R1, R0             @ Ajustar parâmetro do printf com dados a mostrar (retorno).
  LDR  R0, =out           @ String principal de saída no primeiro parâmetro de printf.
  BL   printf             @ Chamar printf para mostrar o resultado.
  BL   _exit              @ Pedir ao SO para sair do programa.

/*
 * memchr(R0, R1, R2)
 * R0 - str
 * R1 - char
 * R2 - int
 */
memchr:
  LDR  R3, =strchr        @ Carregar espaço de memória vazio para guardar char em string.
  STRB R1, [R3, #0]       @ Converter char em string.
  MOV  R4, R0             @ Guardar R0 noutro registo para não perder o seu valor no retorno.
  PUSH {R1-R7, LR}        @ Reservar todos os registos usados exceto R0 (retorno).
  MOV  R1, R3             @ Segundo parâmetro de strcspn(), string a procurar (char em string).
  BL   strcspn            @ Chamar strcspn().
  POP  {R1-R7, LR}        @ Voltar aos valores normais dos registos.
  MOV  R5, R0             @ Guardar retorno noutro registo (temporário, "manobra" para usar R4).
  MOV  R0, R4             @ Retomar o valor anterior de R0 guardado em R4.
  MOV  R4, R5             @ Passar R5 para R4, uma vez que R4 já não está a ser usado.
  MOV  R5, #0             @ Usar R5 para iteração.

  memchr_loop:
    CMP   R5, R2          @ Verificar se o número de bytes dado foi atingido.
    MOVEQ R0, #0          @ Se sim, retornar null.
    BEQ   memchr_loop_end @ break;
    LDRB  R7, [R0, R5]    @ Carregar char em byte da string neste índice R5.
    ADD   R5, #1          @ Incrementar o iterador.
    CMP   R1, R7          @ Verificar se o caracter foi atingido.
    MOVEQ R0, R5          @ Se sim, retornar o valor incrementado.
    BNE   memchr_loop     @ Senão, continuar a iteração.
  memchr_loop_end:

  BX   LR                 @ return;

/*
 * Implementação original
 * em strcspn.asm.
 */
strcspn:
  MOV  R2, #0
  MOV  R3, R0
  MOV  R4, #0
  PUSH {R1-R5, LR}
  BL   _strlen
  POP  {R1-R5, LR}
  PUSH {R0-R5, LR}
  MOV  R0, R1
  BL   _strlen
  MOV  R7, R0
  POP  {R0-R5, LR}
  strcspn_str_loop:
    LDRB R6, [R1, R4]
    ADD  R4, #1
    strcspn_loop:
      LDRB  R5, [R3, R2]
      CMP   R5, R6
      MOVEQ R0, R2
      BEQ   strcspn_loop_end
      ADD   R2, #1
      CMP   R2, R0
      BLT   strcspn_loop
    strcspn_loop_end:
    CMP  R4, R7
    BLT  strcspn_str_loop
  BX   LR

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
