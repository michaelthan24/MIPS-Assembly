#
# Name: Than, Michael
# Homework: # 6
# Due: 4 december 2019
# Course: cs-2640-02-f19
#
# Description: 
# This is an expression tree that takes a tree from the data section to solve the expression tree
#
		.data								# node data could be 1 +, 2 -, 3 *, 4 / .... or int
e1: 		.word t1a 							# 10 + 8 / 2
t1a:		.word 1, t10, t1b 						# 10 + t1b
t1b:		.word 4, t8, t2 						# 8 / 2
t10:		.word 10, 0, 0
t8: 		.word 8, 0, 0
t2: 		.word 2, 0, 0 
e2:		.word r1a							#20 - 9 * 3 + 4 / 2
r1a:		.word 1, r1a1, r1a2
r1a1:		.word 2, r20, r2a
r2a:		.word 3, r9, r3
r1a2:		.word 4, r4, r2
r9:		.word 9, 0, 0
r3:		.word 3, 0, 0
r20: 		.word 20, 0, 0
r4:		.word 4, 0, 0
r2:		.word 2, 0, 0

header:	.asciiz "Expression Tree by M.Than\n"
exp1:	.asciiz "\n10 + 8 / 2 = "
exp2:	.asciiz	"\n20 - 9 * 3 + 4 / 2 = "
		.text
main:	
		la		$a0, header
		li		$v0, 4
		syscall								#print header
		
		la		$a0, e1						#load root of tree into a0 to pass
		jal		eval
		
		move		$t0, $v0
			
		la		$a0, exp1
		li		$v0, 4						
		syscall								#print expression
		
		move		$a0, $t0
		li		$v0, 1						
		syscall								#print result
		
		la		$a0, e2
		jal		eval
		
		move		$t0, $v0
		
		la		$a0, exp2
		li		$v0, 4						
		syscall								#print expression
		
		move		$a0, $t0
		li		$v0, 1						
		syscall								#print result
		
		
		li		$v0, 10
		syscall