@ Data Section
.data
.balign 4
  from: .asciz "A"            @ Caracter em string a transformar.
.balign 4
  out:  .asciz "Result: %c\n" @ Mostrar caracter transformado.

.global printf

.section .text
.global main
.arm

main:
  LDR  R1, =from    @ Carregar caracter a transformar numa string.
  LDRB R0, [R1, #0] @ Obter primeiro caracter da string como byte.
  BL   tolower      @ Chamar tolower().
  MOV  R1, R0       @ Adaptar parâmetro R1 do printf para o retorno da função.
  LDR  R0, =out     @ Carregar string de saída.
  BL   printf       @ Chamar printf.
  BL   _exit        @ Pedir ao SO para sair do programa.

/*
 * tolower(R0)
 * R0 - str
 */
tolower:
  MOV   R1, R0      @ Passar R0 para R1, uma vez que este será o valor de retorno de isupper.
  PUSH  {LR}        @ Reservar LR uma vez que será chamada uma função.
  BL    isupper     @ Chamar isupper para verificar se este caracter é letra maiúscula.
  POP   {LR}        @ Voltar ao LR desta função.
  CMP   R0, #0      @ Verificar se não é maiúscula.
  ADDGT R1, #32     @ Se é, adiciona 32 ao valor numérico do char, que equivale à sua versão minúscula.

  MOV   R0, R1      @ Retornar o valor do char em R1.
  BX    LR          @ return;

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
