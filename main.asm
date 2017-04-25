##############################################################
# Do NOT modify this file.
# This file is NOT part of your homework 2 submission.
##############################################################

.data
canSet: .byte 0:9
str_input: .asciiz "Input: "
str_result: .asciiz "Result: "
array: .byte 
	0,0,0,0,7,0,0,0,4,
	0,3,0,4,0,8,0,0,0,	
	8,0,0,0,9,0,2,7,0,	
	0,1,8,0,0,0,0,0,0,
	2,9,0,0,0,0,0,4,8,
	0,0,0,0,0,0,7,6,0,	
	0,2,5,0,4,0,0,0,7,		
	0,0,0,5,0,1,0,9,0,	
	4,0,0,0,6,0,0,0,0			
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
	#
	li $a1,0
	li $a2,-1

	jal sudoku
	
	#move $t0,$v0
	#print_int($t0)
	

	# QUIT Program
quit_main:
	li $v0, QUIT
	syscall



#################################################################
# Student defined functions will be included starting here
#################################################################

.include "hw4.asm"
