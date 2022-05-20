@ Data Section
.data
.balign 4
  string: .asciz "Hello, world"
.balign 4
  strOut: .fill 50, 1, 0
.balign 4
  outMsg: .asciz "String invertida: %s\n"

.global printf
.global scanf

.section .text
.global main
.arm

main:
  LDR R1, =string
  LDR R2, =strOut

  MOV R0, R1
  BL  _strlen

  BL  strrev
  LDR R0, =outMsg
  LDR R1, =strOut
  BL  printf
  BL  _exit

_strlen:
  MOV R4, #0
  while:
    ADD  R4, #1
    LDRB R3, [R0, R4]
    CMP  R3, #0
    BNE  while
  @ SUB R4, #1
  MOV R0, R4
  BX  LR

strrev:
  MOV R5, R0
  SUB R5, #1
  MOV R4, #0

  strrev_loop:
    CMP  R5, #0
    LDRB R3, [R1, R5]
    STRB R3, [R2, R4]
    SUB  R5, #1
    ADD  R4, #1
    BNE  strrev_loop

  BX  LR

_exit:
  MOV R7, #1
  SVC #0
