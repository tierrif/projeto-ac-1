.data
.align 4
  out:  .asciz "Result: %s\n"
.align 4
  str1: .asciz "World"
.align 4
  str2: .asciz "Hello, "

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =str2
  LDR  R1, =str1
  PUSH {LR}
  BL   strcat
  POP  {LR}
  MOV  R1, R0
  LDR  R0, =out
  BL   printf
  BL   _exit

strcat:
  MOV R2, #0
  MOV R3, #0

  strcat_loop:
    LDRB  R4, [R0, R2]
    CMP   R4, #0
    ADDNE R2, #1
    BNE   strcat_loop
    LDRB  R4, [R1, R3]
    STRB  R4, [R0, R2]
    ADD   R3, #1
    ADD   R2, #1
    CMP   R4, #0
    BNE   strcat_loop

  BX  LR

_exit:
  MOV R7, #1      @ Exit syscall
  SVC #0          @ Invoke
