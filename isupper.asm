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
  from: .asciz "G"            @ Caracter a verificar.
.balign 4
  out:  .asciz "Result: %d\n" @ String de saída.

.global printf

.section .text
.global main
.arm

main:
  LDR  R1, =from    @ Carregar string que contém o caracter a verificar.
  LDRB R0, [R1, #0] @ Buscar o caracter como byte.
  BL   isupper      @ Chamar isupper().
  MOV  R1, R0       @ Ajustar segundo parâmetro do printf com o valor de retorno.
  LDR  R0, =out     @ Carregar string de saída como primeiro parâmetro do printf.
  BL   printf       @ Chamar printf para mostrar o resultado.
  BL   _exit        @ Pedir ao SO para sair do programa.

/*
 * isupper(R0)
 * R0 - char
 */
isupper:
  CMP   R0, #'A'     @ Verificar se o valor numérico de R0 é menor que o do char 'A'.
  MOVLT R0, #0       @ Se sim, não é uma letra maiúscula. Valor de retorno 'false' (0).
  BLT   exit_isupper @ Sair.

  CMP   R0, #'Z'     @ Continuar verificação com a última letra maiúscula em ASCII.
  MOVGT R0, #0       @ Se for maior que o valor de 'Z', também não é letra maiúscula. Condição falsa (0). 
  BGT   exit_isupper @ Sair.

  MOVLE R0, #1       @ Se cumpre todos os requisitos, esta é uma letra maiúscula.
  
  exit_isupper:
  BX   LR            @ return;
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
