/*
 * Instituto Politécnico de Beja
 * Escola Superior de Tecnologia e Gestão
 * Engenharia Informática - Arquitetura de Computadores
 * Projeto de Programação em Assembly para a Arquiterura ARM 1.0
 *
 * Tierri Ferreira
 */

@ Data section
.data
.balign 4
  menu:    .asciz "------\n Menu \n------\n1. hello\n2. world\nMenu option: "
.balign 4
  string:  .asciz "%d"
.balign 4
  test:    .fill 64, 1, 0
.balign 4
  test1:   .fill 64, 1, 0
.balign 4
  hello:   .asciz "hello\n"
.balign 4
  world:   .asciz "world\n"
.balign 4
  out:     .asciz "Selected option: %s\n"
.balign 4
  invalid: .asciz "Invalid option.\nTry again: "

.balign 4
  islower: .asciz "islower"
.balign 4
  isupper: .asciz "isupper"
.balign 4
  memchr: .asciz "memchr"
.balign 4
  memcpy: .asciz "memcpy"
.balign 4
  strcat: .asciz "strcat"
.balign 4
  strcmp: .asciz "strcmp"
.balign 4
  strcpy: .asciz "strcpy"
.balign 4
  strcspn: .asciz "strcspn"
.balign 4
  strlen: .asciz "strlen"
.balign 4
  strlwr: .asciz "strlwr"
.balign 4
  strncmp: .asciz "strncmp"
.balign 4
  strncpy: .asciz "strncpy"
.balign 4
  strrev: .asciz "strrev"
.balign 4
  strspn: .asciz "strspn"
.balign 4
  strupr: .asciz "strupr"
.balign 4
  tolower: .asciz "tolower"
.balign 4
  toupper: .asciz "toupper"

.global scanf
.global printf

.section .text
.global main
.arm

main:
  PUSH  {LR}
  LDR   R0, =menu
  BL    printf
  B     skip_repeat
repeat:
  LDR   R0, =invalid
  BL    printf
skip_repeat:
  LDR   R0, =string
  LDR   R1, =test
  BL    scanf

  LDR   R0, =out
  LDR   R2, =test
  LDRB  R3, [R2, #0]

  CMP   R3, #1
  LDR   R4, =hello
  MOVEQ R1, R4

  CMP   R3, #2
  LDR   R4, =world
  MOVEQ R1, R4

  CMP   R1, #0
  BEQ   repeat

  BL    printf
  POP   {LR}

  B     _exit

_exit:
  MOV R7, #1
  SVC #0     @ Invoke Syscall
