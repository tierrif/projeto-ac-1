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
  from: .asciz "a"            @ Caracter em string a transformar.
.balign 4
  out:  .asciz "Result: %c\n" @ Mostrar caracter transformado.

.global printf

.section .text
.global main
.arm

main:
  LDR  R1, =from    @ Carregar caracter a transformar numa string.
  LDRB R0, [R1, #0] @ Obter primeiro caracter da string como byte.
  BL   toupper      @ Chamar toupper().
  MOV  R1, R0       @ Adaptar parâmetro R1 do printf para o retorno da função.
  LDR  R0, =out     @ Carregar string de saída.
  BL   printf       @ Chamar printf.
  BL   _exit        @ Pedir ao SO para sair do programa.

/*
 * toupper(R0)
 * R0 - str
 */
toupper:
  MOV   R1, R0      @ Passar R0 para R1, uma vez que este será o valor de retorno de islower.
  PUSH  {LR}        @ Reservar LR uma vez que será chamada uma função.
  BL    islower     @ Chamar islower para verificar se este caracter é letra minúscula.
  POP   {LR}        @ Voltar ao LR desta função.
  CMP   R0, #0      @ Verificar se não é minúscula.
  SUBGT R1, #32     @ Se é, subtrai 32 ao valor numérico do char, que equivale à sua versão maiúscula.

  MOV   R0, R1      @ Retornar o valor do char em R1.
  BX    LR          @ return;

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
  BX    LR
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
