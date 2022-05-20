@ Data Section
.data
.balign 4
  from: .asciz "HELLO, world"
.balign 4
  to:   .fill 64, 1, 0
.balign 4
  out:  .asciz "Result: %s\n"

.global printf

.section .text
.global main
.arm

main:
  LDR R0, =from
  BL  strupr
  MOV R1, R0
  LDR R0, =out
  BL  printf
  BL   _exit

/*
 * strupr(R0)
 * R0 - str
 */
strupr:
  MOV R1, R0
  PUSH {LR}
  BL   _strlen
  POP  {LR}
  MOV  R4, R0
  LDR  R6, =to
  
  MOV R2, #0 @ counter
  strupr_loop:
    LDRB  R3, [R1, R2]

    PUSH  {R0, LR}
    MOV   R0, R3
    BL    islower
    MOV   R5, R0
    POP   {R0, LR}

    CMP   R5, #0
    SUBGT R3, #32
    STRB  R3, [R6, R2]

    ADD   R2, #1
    CMP   R2, R4
    BEQ   strupr_loop_end
    B     strupr_loop
  strupr_loop_end:

  LDR  R0, =to

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

islower:
  CMP   R0, #'a'
  MOVLT R0, #0
  BLT   exit_islower

  CMP   R0, #'z'
  MOVGT R0, #0
  BGT   exit_islower
  MOVLE R0, #1
  
  exit_islower:
  BX   LR
    
_exit:
  MOV R7, #1     @ Exit syscall
  SVC 0          @ Invoke
