# HOMEWORK #4
# NAME: JUN HAO
# SBUID: 108052431


#NOTE: for sudoku function, it takes really long time to finish especially with lots of blank. it act as infinity
#	loop,please be patient if test with hard sudoku puzzle 
 
  
    # Constants
.eqv QUIT 10
.eqv PRINT_STRING 4
.eqv PRINT_INT 1
.eqv NULL 0x0

.macro print_int(%register)
	li $v0, 1
	add $a0, $zero, %register
	syscall
.end_macro
.macro print_string(%address)
	li $v0, PRINT_STRING
	la $a0, %address
	syscall 
.end_macro

.macro print_newline
	li $v0, 11
	li $a0, '\n'
	syscall 
.end_macro
#
# Computes the Nth number of the Hofsadter Female Sequence
# public int F (int n)
#
F:
	
	addi $sp,$sp,-12
	addi $t0,$a0,-1			#get n-1
	sw $t0,0($sp)			#save n-1 to stack			
	sw $ra,4($sp)			#store $ra to stack
	sw $a0,8($sp)			#save n to stack
	print_string(F_header)
	lw $a0,8($sp)
	print_int($a0)
	
	bnez $a0,F_else			#if not 0 keep recursion
	li $v0,1				# if equal to 0  return 1
	addi $sp,$sp,12
	jr $ra
F_else:
	move $a0,$t0
	
	jal F
	move $a0,$v0
	jal M
	lw $t1,8($sp)			# get n from stack
	sub $v0,$t1,$v0
	lw $ra,4($sp)
	addi $sp,$sp,12
	jr $ra	
#
# Computes the Nth number of the Hofsadter Male Sequence
# public int M (int n)
#	
M:
	
	addi $sp,$sp,-12
	addi $t0,$a0,-1			#get n-1
	sw $t0,0($sp)			#save n-1 to stack			
	sw $ra,4($sp)			#store $ra to stack
	sw $a0,8($sp)			#save n to stack
	print_string(M_header)
	
	lw $a0,8($sp)
	print_int($a0)
	bnez $a0,M_else			#if not 0 keep recursion
	li $v0,0			# if equal to 0  return 0
	addi $sp,$sp,12
	jr $ra
M_else:
	move $a0,$t0
	jal M
	move $a0,$v0
	jal F
	lw $t1,8($sp)			# get n from stack
	sub $v0,$t1,$v0
	lw $ra,4($sp)	
	addi $sp,$sp,12
	jr $ra	

#
# Tak Function
# public int tak (int x, int y, int z)
#
tak:

	addi $sp, $sp,-28	
	sw $ra,0($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $a2,12($sp)
	sw $s0,16($sp)
	sw $s1,20($sp)
	sw $s2,24($sp)
	
	blt $a1,$a0, Rec		# if y<x we keep doing recursion
	move $v0,$a2			# the base case which is that y>=x, we need to return
	addi $sp,$sp,28
	jr $ra
	
Rec:		
	#x-1,y,z case			
	lw $a0,4($sp)
	lw $a1,8($sp)
	lw $a2,12($sp)
	addi $a0,$a0,-1
	jal tak
	move $s0,$v0
	
	#y-1,z,x case
	lw $a0,8($sp)
	lw $a1,12($sp)
	lw $a2,4($sp)
	addi $a0,$a0,-1
	jal tak
	move $s1,$v0
	
	#z-1,x,y case
	lw $a0,12($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	addi $a0,$a0,-1
	jal tak
	move $s2,$v0
	
	# call tak with those 3 save value
	
	move $a0,$s0
	move $a1,$s1
	move $a2,$s2
	jal tak
	
	lw $ra 0($sp)
	lw $s0,16($sp)
	lw $s1,20($sp)
	lw $s2,24($sp)
	addi $sp,$sp,28
	jr $ra
	
	
#
# Helper function for solving sudoku
# public boolean isSolution (int row, int col)
#
isSolution:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,8
	bne $t0,$a0,false
	bne $t0,$a1,false
	li $v0,1
	j done
false:
	li $v0,0
done:	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#
# Helper function for solving sudoku
# public void printSolution (byte[][] board)
#
printSolution:
	addi $sp,$sp,-8
	sw $a0,0($sp)
	sw $ra,4($sp)
	print_string(solution_header)
	print_newline
	lw $t3,0($sp)			#t3 holds the orginal $a0
	li $t0,0			# i
	li $t1,0			# j
	li $t9,9
	
iloop:
	bge $t0,9,finish
	
jloop:
	bge $t1,9,jloop_out
	# keep looping,calculate offset first
	mul $t4,$t0,$t9			# i*9
	add $t4,$t4,$t1			# $t4 <- 9i+j which is the offset
	add $t5,$t4,$t3		
	lb $t6,0($t5)
	print_int ($t6)
	print_string(space)
	addi $t1,$t1,1
	j jloop
jloop_out:
	print_newline
	addi $t0,$t0,1
	li $t1,0
	j iloop
	
	
finish:
	lw $ra,4($sp)
	addi $sp,$sp,8
	jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) gridSet (byte[][] board, int row, int col)
#
gridSet:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $t9 ,3
	li $t8,0 			#counter =0
	li $t7,9
	div $a1,$t9
	mflo $t0	
	mul $t0,$t0,$t9			#$t0 is r_start
	
	div $a2,$t9
	mflo $t1	
	mul $t1,$t1,$t9			#$t1 is c_start
	
	move $t2, $t0			# index i
	move $t3,$t1			# index j
	addi $t4,$t0,3			# r_start +3
	addi $t5,$t1,3			# c_start +3 
	la $t9,gSet			# $t9 hold the address of gset
grid_loop1:
	bge $t2,$t4,end
grid_loop2:
	bge $t3,$t5,inner_loop_out
	#calculate the offset
	mul $t6,$t2,$t7
	add $t6,$t6,$t3			
	add $t6,$t6,$a0			# now $t6 get the destination
	lb $a3 , 0($t6)			
	beqz $a3, keep_inner_loop
	sb $a3,0($t9)
	addi $t9,$t9,1
	addi $t8,$t8,1
keep_inner_loop:
	addi $t3,$t3,1
	j grid_loop2
inner_loop_out:
	addi $t2,$t2,1
	move $t3,$t1		# before go to the next loop, reset j
	j grid_loop1
	
end:
	move $v0,$t8
	lw $ra,0($sp)
	addi $sp,$sp,4	
	jr $ra
	
#
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int col)
#	
colSet:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,0		#count =0
	li $t1,0		#i=0
	li $t9,9		
	la $t8,cSet
col_loop:
	bge $t1,9,col_out
	#calculate offset
	mul $t2,$t1,$t9
	add $t2,$a1,$t2
	add $t3,$a0,$t2
	lb $t4,0($t3)
	beqz $t4, col_isblank
	sb $t4,0($t8)
	
	addi $t0,$t0,1
	addi $t8,$t8,1
	
col_isblank:
	addi $t1,$t1,1
	j col_loop

	
col_out:
	move $v0,$t0
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) rowSet (byte[][] board, int row)
#		
rowSet:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	li $t0,0		#count =0
	li $t1,0		#i=0
	li $t9,9		
	la $t8,rSet
row_loop:
	bge $t1,9,row_out
	#calculate offset
	mul $t2,$a1,$t9
	add $t2,$t1,$t2
	add $t3,$a0,$t2
	lb $t4,0($t3)
	beqz $t4, row_isblank
	add $t7,$t8,$t0
	sb $t4,0($t7)
	
	addi $t0,$t0,1
	#addi $t8,$t8,1
	
row_isblank:
	addi $t1,$t1,1
	j row_loop

	
row_out:
	move $v0,$t0
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra

#
# Helper function for solving sudoku
# public (byte [], int) colSet (byte[][] board, int row, int col)
#			
constructCandidates:
	addi $sp,$sp,-32
	sw $a0,0($sp)			# board
	sw $a1,4($sp)			# row
	sw $a2,8($sp)			# column
	sw $a3,12($sp)			# candidates
	sw $ra,28($sp)
	
	jal rowSet
	sw $v0,16($sp)			# r length
	
	lw $a0,0($sp)
	lw $a1,8($sp)
	jal colSet
	sw $v0,20($sp)			# c length
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	jal gridSet
	sw $v0,24($sp)			# g length
	
	lw $t0,16($sp)			# t0 <- rlength
	lw $t1,20($sp)			# t1 <- clength
	lw $t2,24($sp)			# t2 <- glength
	li $t9,0			# t9 <- count
	li $t8,1			# t8 <- i
	li $t7,0			# t7 is the counter for those 3 loops
	lw $a3,12($sp)
big_loop:	
	bgt $t8,9,return		# check if we get out the loop
	
	#search in rSet
	la $t6,rSet
rloop:
	bge $t7,$t0,rloop_out
	lb $t5,0($t6)
	beq $t5,$t8,next_loop		#if i in rset check next num
	addi $t6,$t6,1
	addi $t7,$t7,1
	j rloop
rloop_out:
	la $t6,cSet
	li $t7,0			#reset counter
cloop:
	bge $t7,$t1,cloop_out
	lb $t5,0($t6)
	beq $t5,$t8,next_loop
	addi $t6,$t6,1
	addi $t7,$t7,1
	j cloop
cloop_out:	
	la $t6,gSet
	li $t7,0
gloop:
	bge $t7,$t2,gloop_out
	lb $t5,0($t6)
	beq $t5,$t8,next_loop
	addi $t6,$t6,1
	addi $t7,$t7,1
	j gloop
gloop_out:
	#if reach here that means it is a candidate
	add $t4,$a3,$t9
	sb $t8,0($t4)
	addi $t9,$t9,1
	
next_loop:
	li $t7,0
	addi $t8,$t8,1
	j big_loop
	
	
	
return:
	move $v0,$t9
	lw $ra,28($sp)
	addi $sp,$sp,32
	jr $ra

#
# sudoku solver function
# public (byte [], int) colSet (byte[][] board, int x, int y)
#	
sudoku:
	addi $sp,$sp,-24
	sw $ra,20($sp)
	sw $fp,16($sp)
	move $fp,$sp
	addi $sp,$sp,-12
	sw $a0,0($sp)
	sw,$a1,4($sp)
	sw $a2,8($sp)
	
	print_string(sudoku_header)
	print_string(left_bracket)
	print_int($a1)
	print_string(right_bracket)
	print_string(left_bracket)
	print_int($a2)
	print_string(right_bracket)
	print_newline
	
	#check if issolution
	lw $a0,4($sp)
	lw $a1,8($sp)
	jal isSolution
	beqz $v0,not_yet
	
	# good  we reach a solution
	lw $a0,0($sp)
	jal printSolution
	lw $ra,20($fp)
	li $t0,1
	sb $t0,FINISHED
#	addi $sp,$sp,12
#	lw $ra,20($sp)
#	lw $fp,16($sp)
#	addi $sp,$sp,24
	j function_end
	
not_yet:
	lw $a0,0($sp)
	lw,$a1,4($sp)
	lw $a2,8($sp)
	
	addi $a2,$a2,1
	# if y >8 we need to go to next row
	ble $a2,8,check_blank
	# set index to next row
	addi $a1,$a1,1
	li $a2,0
	
check_blank:
	
	li $t9,9
	mul $t8,$t9,$a1
	add $t8,$t8,$a2
	add $t8,$t8,$a0
	lb $t7 0($t8)				#now $t7 get board[x][y] value
	beqz $t7,is_blank
	
	jal sudoku
	j function_end
is_blank:
	move $a3,$fp
	#because we modify x, y and we dont want to lose those value, save to stack for safety
	addi $sp,$sp,-12
	sw $a0,0($sp)
	sw $a1,4($sp)
	sw $a2,8($sp)
	
	
	jal constructCandidates
	sw $v0,12($fp)
	move $t6,$v0				# $t6 now hold the candidate length
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	addi $sp,$sp,12
	
	
	#now we are going to the for loop
	li $t5,0				# $t5 holds c
for_loop:
	lw $t6,12($fp)
	beqz $t6,backtracking
	bge $t5,$t6,function_end
	
	li $t9,9
	mul $t8,$t9,$a1
	add $t8,$t8,$a2
	add $t8,$t8,$a0
	
	add $t0,$fp,$t5
	lb $t1,0($t0)
	sb $t1,0($t8)
	addi $sp,$sp,-8
	sw $t5,0($sp)
	sw $t8,4($sp)
	
	jal sudoku
	lw $ra,20($fp)
	lw $t5,0($sp)
	lw $t8,4($sp)
	
	addi $sp,$sp,8
	li $t3,0
	sb $t3,0($t8)
	
	lb $t1,FINISHED
	beq $t1,1,function_end
	addi $t5,$t5,1
	j for_loop
	
backtracking:
	
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	addi $sp,$sp,12
	lw $ra,20($fp)
	lw $fp,16($sp)
	addi $sp,$sp,24
	jr $ra
	
function_end:	
	addi $sp,$sp,12
	lw $ra,20($sp)
	lw $fp,16($sp)
	addi $sp,$sp,24
	jr $ra

.data
F_header:	.asciiz "F: "
M_header:	.asciiz "M: "
tak_header:	.asciiz "tak: "
solution_header: 	.asciiz "Solution: "
sudoku_header:	.asciiz "Sudoku "
left_bracket:	.asciiz "["
right_bracket:	.asciiz "]"
space :		.asciiz " "
rSet: 		.byte 0:9
cSet: 		.byte 0:9
gSet: 		.byte 0:9
FINISHED: 	.byte 0
