/******************************************************************************
* file: assigment4-part1.s
* author: Basant Kumar
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/


@ BSS section
    .bss

@ DATA SECTION
    .data
START1: .asciz "CAR"
START2: .asciz "CUT"
.align
LENGTH: .word 0x3

/*Output*/
GREATER: .word 0

@ TEXT section
    .text

.globl _main

_main:
  ldr r4, =START1        /*load addr of str1 in r4   */
  ldr r5, =START2        /*load addr of str2 in r5   */
  ldr r6, =LENGTH        /*load addr of LENGTH in r6 */
  ldr r7, =GREATER       /*load addr of GREATER in r7*/

/*one time read operation*/
  ldr r2, [r6]        /*read LENGTH*/
  ldr r3, [r7]        /*read GREATER*/

compare:
  ldrb r0, [r4]        /*read str1 1-byte                   */
  ldrb r1, [r5]        /*read str2 1-byte                   */
  cmp r0, r1           /*compare characters of str1 and str2*/
  mvn r0, #0
  bmi update           /*if str1[i] < str2[i] update GREATER with r0 = 0xFFFFFFFF*/

next:
  add r4, r4, #1      /*jump to addr of next character*/
  add r5, r5, #1      /*jump to addr of next character*/
  sub r2, r2, #1
  cmp r2, #0          /*compare strlen with zero*/
  bne compare         /*if not equal jump to level:compare for next character comparision*/
  mov r0, #0          /*if str1[i] = str2[i] update GREATER with r0 = 0x0*/

update:
  add r3, r3, r0
  str r3, [r7]        /*update GREATER*/

.end