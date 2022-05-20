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
  PUSH {LR}
  BL   strcpy
  POP  {LR}
  PUSH {LR}
  BL   printf
  POP  {LR}
  BL   _exit

/*
 * strcpy(R0, R1)
 * R0 - str (from)
 * R1 - str (to)
 */
strcpy:
  MOV  R2, R0
  PUSH {LR}
  BL   _strlen
  POP  {LR}

  MOV  R3, #0
  strcpy_loop:
    LDRB R4, [R2, R3]
    STRB R4, [R1, R3]
    ADD R3, #1
    CMP R3, R0
    BLT strcpy_loop

  LDR R0, =out
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
