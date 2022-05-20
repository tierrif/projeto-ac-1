@ Data Section
.data
.balign 4
  string: .asciz "Hello, world"           @ String a inverter.
.balign 4
  strOut: .fill 50, 1, 0                  @ String de destino.
.balign 4
  outMsg: .asciz "String invertida: %s\n" @ String de output.

.global printf
.global scanf

.section .text
.global main
.arm

main:
  LDR R1, =string @ Carregar string a inverter.
  LDR R2, =strOut @ Carregar string de destino.

  MOV R0, R1      @ Posicionar string no primeiro parâmetro de strlen().
  BL  _strlen     @ Chamar strlen().

  BL  strrev      @ Chamar strrev().
  LDR R0, =outMsg @ Carregar string de output.
  LDR R1, =strOut @ Carregar string invertida da memória.
  BL  printf      @ Chamar printf().
  BL  _exit       @ Pedir ao SO para sair.

strrev:
  MOV R5, R0          @ Copiar R0 para R5.
  SUB R5, #1          @ Subtrair tamanho por 1 para índice máximo em vez de tamanho.
  MOV R4, #0          @ Inicializar iterador do destino.

  strrev_loop: 
    LDRB R3, [R1, R5] @ Carregar byte da string a inverter no índice R5 (de frente para trás).
    STRB R3, [R2, R4] @ Guardar por ordem de 0 a [índice máximo] no índice atual R4.
    CMP  R5, #0       @ Verificar se chegámos ao início da string (e fim da iteração).
    SUB  R5, #1       @ Decrementar contador inverso R5 (depois da verificação).
    ADD  R4, #1       @ Incrementar contador da string de destino.
    BNE  strrev_loop  @ Se ainda não chegámos ao fim (CMP R5, #0), continuar.

  BX  LR

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
  MOV R7, #1
  SVC #0
