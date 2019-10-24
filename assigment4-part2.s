/******************************************************************************
* file: assigment4-part2.s
* author: Basant Kumar
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/


@ BSS section
    .bss

@ DATA SECTION
    .data
STRING: .asciz "CS6620"
SUBSTR: .asciz "620"

.align
/*output*/
lps: .word 0
len_substr: .word 0
position: .word 0

@ TEXT section
    .text

.globl _main
/* substr pattern search based on KMP algorithm*/
_main:
/*one time read operation*/
  ldr r5, =SUBSTR           /*load addr of SUBSTR in r5   */
  ldr r6, =lps              /*load addr of lps in r6 */

/*stage1: Preprocess substr to get longest proper prefix, i.e. lps*/
lps_func:
  mov r3, #0                /*len = 0;*/
  mov r2, #1                /*i = 1;*/
  mov r4, r5                /*put SUBSTR for different offset*/
  ldrb r0, [r4, r2]         /*SUBSTR[i]*/
  cmp r0, #0                /*compare str with zero */
  beq store_len

lps_compare:
  ldrb r1, [r5, r3]         /*SUBSTR[len]*/
  cmp r0, r1                /*SUBSTR[i] == SUBSTR[len]*/
  beq lps_len_inc
  cmp r3, #0
  bne lps_len_update        /*for len=0, store zero in lps*/

lps_update:
  str r3, [r6, r2, lsl #2]  /*lps[i] = len*/
  b lps_next 

lps_len_inc:
  add r3, r3, #1            /*len++*/
  b lps_update

lps_len_update:
  sub r9, r3, #1            /*len - 1*/
  ldr r3, [r6, r9, lsl #2]  /*len = lps[len - 1]*/
  b lps_compare

lps_next:
  add r2, r2, #1            /*i++ which keep track of SUBSTR length, */
  ldrb r0, [r4, r2]         /*SUBSTR[i]*/
  cmp r0, #0                /*compare str with zero */
  bne lps_compare           /*if not equal jump to level:lps_compare for next character comparision*/
store_len:
  ldr r1, =len_substr
  str r2, [r1]

/*output of lps_function is updated in lps[] and len_substr*/
/*stage2: pattern search, if mismatch next search will be based on lps entry*/
kmp_func:
/*one time read operation*/
  ldr r7, =STRING          /*load addr of STRING in r5   */
  ldr r8, =position        /*load addr of LENGTH in r6 */
  ldr r1, =len_substr

  ldr r4, [r1]              /* len of SUBSTR*/
  mov r2, #0               /*i = 0, for STRING index*/
  mov r3, #0               /*j = 0, for SUBSTR index*/

  ldrb r1, [r7, r2]         /*STRING[i]*/

kmp_compare:
  ldrb r0, [r5, r3]         /*SUBSTR[j]*/
  cmp r0, r1                /* check for STRING[i] == SUBSTR[j]*/
  bne kmp_mismatch

kmp_len_inc:
  add r3, r3, #1            /*j++*/
  add r2, r2, #1            /*i++*/

  cmp r3, r4                /*j == M, means whole substring parsed */
  beq kmp_found

kmp_mismatch:
  cmp r0, r1                /* check for STRING[i] == SUBSTR[j]*/
  beq kmp_next
  cmp r3, #0                /* check (j != 0) */ 
  beq inc_i
  sub r9, r3, #1            /*j - 1*/
  ldr r3, [r6, r9, lsl #2]  /*j = lps[j - 1]*/
  b kmp_next

inc_i:
  add r2, r2, #1           /*i++*/

kmp_next:
  ldrb r1, [r7, r2]        /*STRING[i]*/
  cmp r1, #0
  bne kmp_compare

kmp_found:
  sub r0, r2, r3           /* substr at position i - j*/
  add r0, r0, #1           /* substr at position i - j*/
  str r0, [r8]

.end