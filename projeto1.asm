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
  menu:    .asciz "\n------------------------------------------\n                   Menu \n------------------------------------------\na. islower\nb. isupper\nc. memchr\nd. memcpy\ne. strcat\nf. strcmp\ng. strcpy\nh. strcspn\ni. strlen\nj. strlwr\nk. strncmp\nl. strncpy\nm. strrev\nn. strspn\no. strupr\np. tolower\nq. toupper\nSelect option: "
.balign 4
  string:  .asciz "%s"
.balign 4
  char:    .asciz "%c"
.balign 4
  test:    .fill 64, 1, 0
.balign 4
  test1:   .fill 64, 1, 0
.balign 4
  out:     .asciz "Selected option: %s\n\n\n"
.balign 4
  invalid: .asciz "Invalid option.\nTry again: "
.balign 4
  charSel: .asciz "\nType a char: "
.balign 4
  run:     .asciz "./run "

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
.global system

.section .text
.global main
.arm

main:
  LDR   R0, =menu @ Carregar string do menu.
  BL    printf
  B     skip_repeat
repeat:
  LDR   R0, =invalid
  BL    printf
skip_repeat:
  LDR   R0, =string
  LDR   R1, =test
  BL    scanf

  LDR   R2, =test
  LDRB  R3, [R2, #0]

  PUSH  {R0-R1, LR}
  MOV   R0, R3
  BL    _functionNameByIndex
  MOV   R3, R0
  POP   {R0-R1, LR}

  CMP   R3, #0
  BEQ   repeat

  LDR   R0, =run
  MOV   R1, R3
  BL    _strcat

  BL    system

  B     _exit

_strcat:
  PUSH {R0, LR}        @ Reservar R0 e LR para chamar strlen().
  BL   _strlen         @ Chamar strlen() para saber o tamanho de R0.
  MOV  R2, R0          @ Mover o valor retornado para R2.
  POP  {R0, LR}        @ Voltar ao valor inicial de R0 e LR.

  MOV  R3, #0          @ Inicializar incrementador de R1.

  strcat_loop:
    LDRB  R4, [R1, R3] @ Buscar caracter em índice R3 da segunda string.
    STRB  R4, [R0, R2] @ Guardar caracter em índice R2 (com tamanho incluído) da primeira string.
    ADD   R3, #1       @ Incrementar incrementador da primeira string.
    ADD   R2, #1       @ Incrementar incrementador da segunda string (já com tamanho incluído).
    CMP   R4, #0       @ Verificar se o caracter é nulo.
    BNE   strcat_loop  @ Se não, ainda não chegou ao seu fim. Continuar iteração.

  BX   LR              @ return;

_strlen:
  MOV R4, #0          @ Inicializar iterador.
  while:
    ADD  R4, #1       @ Incrementar iterador.
    LDRB R3, [R0, R4] @ Retirar byte da string.
    CMP  R3, #0       @ Verificar se chegámos ao fim da string.
    BNE  while        @ Se ainda não, continuar iteração.
  MOV R0, R4          @ Retornar tamanho (número de iterações.)
  BX  LR              @ return;

_functionNameByIndex:
  MOV   R1, R0
  MOV   R0, #0

  CMP   R1, #'a'
  LDREQ R0, =islower
 
  CMP   R1, #'b'
  LDREQ R0, =isupper
 
  CMP   R1, #'c'
  LDREQ R0, =memchr
 
  CMP   R1, #'d'
  LDREQ R0, =memcpy
 
  CMP   R1, #'e'
  LDREQ R0, =strcat
 
  CMP   R1, #'f'
  LDREQ R0, =strcmp
 
  CMP   R1, #'g'
  LDREQ R0, =strcpy
 
  CMP   R1, #'h'
  LDREQ R0, =strcspn
 
  CMP   R1, #'i'
  LDREQ R0, =strlen
 
  CMP   R1, #'j'
  LDREQ R0, =strlwr
 
  CMP   R1, #'k'
  LDREQ R0, =strncmp
 
  CMP   R1, #'l'
  LDREQ R0, =strncpy
 
  CMP   R1, #'m'
  LDREQ R0, =strrev
 
  CMP   R1, #'n'
  LDREQ R0, =strspn
 
  CMP   R1, #'o'
  LDREQ R0, =strupr
 
  CMP   R1, #'p'
  LDREQ R0, =tolower
 
  CMP   R1, #'q'
  LDREQ R0, =toupper

  BX    LR

_exit:
  MOV R7, #1
  SVC #0     @ Invoke Syscall
