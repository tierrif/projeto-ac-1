@ Data Section
.data
.balign 4
  string: .asciz "Hello, world"
.balign 4
  out:    .asciz "Length: %d\n"

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =string
  MOV  R1, R0
  PUSH {LR}
  BL   strlen
  POP  {LR}
  MOV  R2, R0
  LDR  R0, =out
  MOV  R1, R2
  PUSH {LR}
  BL   printf
  POP  {LR}
  BL   _exit

strlen:
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
