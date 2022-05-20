@ Data Section
.data
.balign 4
  from: .asciz "z"            @ Caracter a verificar.
.balign 4
  out:  .asciz "Result: %d\n" @ String de saída.

.global printf

.section .text
.global main
.arm

main:
  LDR  R1, =from    @ Carregar string que contém o caracter a verificar.
  LDRB R0, [R1, #0] @ Buscar o caracter como byte.
  BL   islower      @ Chamar islower().
  MOV  R1, R0       @ Ajustar segundo parâmetro do printf com o valor de retorno.
  LDR  R0, =out     @ Carregar string de saída como primeiro parâmetro do printf.
  BL   printf       @ Chamar printf para mostrar o resultado.
  BL   _exit        @ Pedir ao SO para sair do programa.

/*
 * islower(R0)
 * R0 - char
 */
islower:
  CMP   R0, #'a'     @ Verificar se o valor numérico de R0 é menor que o do char 'a'.
  MOVLT R0, #0       @ Se sim, não é uma letra minúscula. Valor de retorno 'false' (0).
  BLT   exit_islower @ Sair.

  CMP   R0, #'z'     @ Continuar verificação com a última letra minúscula em ASCII.
  MOVGT R0, #0       @ Se for maior que o valor de 'z', também não é letra minúscula. Condição falsa (0). 
  BGT   exit_islower @ Sair.

  MOVLE R0, #1       @ Se cumpre todos os requisitos, esta é uma letra minúscula.
  
  exit_islower:
  BX   LR            @ return;
    
_exit:
  MOV R7, #1         @ Exit syscall
  SVC 0              @ Invoke
