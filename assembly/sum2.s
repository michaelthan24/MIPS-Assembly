#Name : Than, Michael
#Homework: #1
#Due: september 25 2019
#Course: cs-2640-02-f19
#Description: A mips program adding two integers inputed by the user
.data
userInput1: .asciiz "Enter an integer? "
userInput2: .asciiz "Enter an integer? "
outputSum: .asciiz "Sum is "
.text
main:	
	la $a0, userInput1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	la $a0, userInput2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t2, $v0
	
	add $t3, $t1, $t2
	
	la $a0, outputSum
	li $v0, 4
	syscall
	
	move $a0, $t3
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall
# end 