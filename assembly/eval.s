#
# Name: Than, Michael
# Homework: # 6
# Due: 4 december 2019
# Course: cs-2640-02-f19
#
# Description: 
# This is the eval subprogram used by the expression tree program to evaluate the tree
#
		.text
eval:	
		addi		$sp, $sp, -12
		sw		$ra, ($sp)					#save ra
		sw		$a0, 4($sp)					#save root address
		lw		$a0, ($a0)					#load the root of the tree
		beqz		$a0, bcase					#root=0, return 0
		lw		$t0, 4($a0)					#get left 
		beqz		$t0, myblf					#if left is 0 check right for 0
		la		$a0, 4($a0)					#load left to pass
		jal		eval	
		sw		$v0, 8($sp)					#save lhs, lhs=eval (root.left)
		lw		$a0, 4($sp)					#reload root
		lw		$a0, ($a0)					#load root
		la		$a0, 8($a0)					#load right to pass
		jal		eval
		move		$t1, $v0					#rhs = eval (root.right)
		lw		$s0, 8($sp)					#load lhs
		lw		$t0, 4($sp)					#reload root
		lw		$t0, ($t0)					#load root
		lw		$t0, ($t0)					#load root value
		addi		$t0, $t0, -1					#subtract root code for op by 1
		sll		$t0, $t0, 2					#multiply by two
		la		$t2, switch
		add		$t0, $t0, $t2					#add increment for switch case address
		jr		$t0						#switch case

switch:		b		addx
		b		subx
		b		mulx
		b		divx
addx:		add		$v0, $s0, $t1					#result = lhs + rhs
		b		endx
subx:		sub		$v0, $s0, $t1					#result = lhs - rhs
		b		endx
mulx:		mul		$v0, $s0, $t1					#result = lhs * rhs
		b		endx
divx:		div		$v0, $s0, $t1					#result = lhs / rhs
		b		endx
myblf:
		lw		$t0, 8($a0)					#get right
		beqz		$t0, islf					#if right is also 0, return the root because it is a leaf
bcase:
		addi		$sp, $sp, 12					#pop stack
		li		$v0, 0						#return 0 for root = 0
		jr		$ra
islf:
		addi		$sp, $sp, 12					#pop stack
		lw		$a0, ($a0)					#load value
		move		$v0, $a0					#root is lead, return root
		jr		$ra
endx:
		lw		$ra, ($sp)					#reload return register 
		addi		$sp, $sp, 12					#pop stack
		jr		$ra