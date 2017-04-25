##############################################################
# Do NOT modify this file.
# This file is NOT part of your homework 2 submission.
##############################################################

.data
canSet: 		.byte 0:9
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
array: .byte 
	    0,2,8,6,9,1,4,5,7,
	    9,1,7,4,8,5,6,3,2, 	
	    4,6,5,3,7,2,1,9,8, 	
	    1,5,6,7,2,4,3,8,9, 	
	    7,4,9,8,1,3,5,2,6, 	
	    8,3,2,9,5,6,7,4,1, 	
	    2,7,1,5,4,9,8,6,3, 	
	    5,9,3,1,6,8,2,7,4, 	
	    6,8,4,2,3,7,9,1,5 	
 # Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_string_reg(%reg)
	li $v0, PRINT_STRING
	la $a0, 0(%reg)
	syscall 
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro

.macro print_space
	li $v0, 11
	li $a0, ' '
	syscall 
.end_macro

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro

.macro print_char_addr(%address)
	li $v0, 11
	lb $a0, %address
	syscall
.end_macro

.macro print_char_reg(%reg)
	li $v0, 11
	move $a0, %reg
	syscall
.end_macro

.text
.globl main

main:
	
	la $a0,array
	li $a1,0
	li $a2,-1
#	la $a3,canSet
	jal sudoku	
#	jal constructCandidates
#	move $t0,$v0
#	print_int($t0)
#	print_newline	
#	li $t9,0
#	la $t1,canSet
test:	
#	bge $t9,$t0,quit_main
#	lb $t2,0($t1)
#	print_int($t2)
#	addi $t1,$t1,1
#	addi $t9,$t9,1
#	j test
		
	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"
