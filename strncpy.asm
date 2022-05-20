@ Data Section
.data
.balign 4
  from: .asciz "Hello, world"
.balign 4
  to:   .fill 64, 1, 0
.balign 4
  out:  .asciz "Result: %s\n"

.global printf

.section .text
.global main
.arm

main:
  LDR  R0, =from
  LDR  R1, =to
  MOV  R2, #4
  PUSH {LR}
  BL   strncpy
  POP  {LR}
  PUSH {LR}
  BL   printf
  POP  {LR}
  BL   _exit

/*
 * strncpy(R0, R1, R2)
 * R0 - str (from)
 * R1 - str (to)
 * R2 - int (max bytes)
 */
strncpy:
  MOV  R5, R0
  PUSH {LR}
  BL   _strlen
  POP  {LR}

  MOV  R3, #0
  strncpy_loop:
    CMP  R3, R2
    BGT  strncpy_loop_end
    LDRB R4, [R5, R3]
    STRB R4, [R1, R3]
    ADD R3, #1
    CMP R3, R0
    BLT strncpy_loop
  strncpy_loop_end:

  LDR  R0, =out
  BX   LR

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
