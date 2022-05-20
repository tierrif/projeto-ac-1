@ Data Section
.data
.balign 4
  string:  .asciz "Hello, world"
.balign 4
  string2: .asciz "h"

.section .text
.global main
.arm

main:
  LDR  R0, =string
  LDR  R1, =string2
  PUSH {R7, R8, LR}
  BL   strcspn
  POP  {R7, R8, LR}
  BL   _exit

/*
 * strcspn(R0, R1)
 * R0 - str
 * R1 - str
 */
strcspn:
  MOV  R2, #0 @ Counter at strcspn_loop
  MOV  R3, R0
  MOV  R4, #0 @ Counter at strsspn_str_loop

  PUSH {R1-R5, LR}
  BL   _strlen
  POP  {R1-R5, LR}
  PUSH {R0-R5, LR}
  MOV  R0, R1
  BL   _strlen
  MOV  R7, R0
  POP  {R0-R5, LR}
  strcspn_str_loop:
    LDRB R6, [R1, R4]
    ADD  R4, #1
    strcspn_loop:
      LDRB  R5, [R3, R2]
      CMP   R5, R6
      MOVEQ R0, R2
      BEQ   strcspn_loop_end
      ADD   R2, #1
      CMP   R2, R0
      BLT   strcspn_loop
    strcspn_loop_end:
    CMP  R4, R7
    BLT  strcspn_str_loop
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
