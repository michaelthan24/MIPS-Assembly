#Name : Than, Michael
#Homework: #2
#Due: october 4 2019
#Course: cs-2640-02-f19
#Description: A mips program calculating the fibonacci number of a user inputed number
.data
	name: .asciiz "M. Than's Fibonacci\n"
	userPrompt: .asciiz "\nEnter n? "
	fib: .asciiz "\nF"
	newline: .asciiz "\n"
.text

main:
	
	la $a0, name #printing out name
	li $v0, 4
	syscall 
	
	la $a0, userPrompt #asking user to enter n
	li $v0, 4
	syscall 
	
	la $v0, 5 #reading user inputed
	syscall
	move $t8, $v0 #n is stored in $t8
	
	beqz $t8, baseCase #if n is equal to 1 or 0
	beq $t8, 1, baseCase
	
	li $t1, 1 #loading 1 and 0 values into registers
	li $t2, 0
	
loop:
	beq $t8, 1, loopexit
	add $t0, $t1, $t2 # storing the fibonacci number in $t0
	move $t2, $t1 #now storing the new n-2 into $t1
	move $t1, $t0 #storing the new n-1 into $t0
	add $t8, $t8, -1 #subtract loop count by 1
	b loop # by the end of the loop the fibonacci number should be in $t1

loopexit: #will print out fibonacci number if user inputs a number greater than 1
	la $a0, fib #prints F 
	li $v0, 4
	syscall

	move $a0, $t1 #prints out fibonacci number that will be stored in $t1
	li $v0, 1
	syscall
	
	b endFib
	
baseCase: #will just print out 1 or 0 IF user inputs 1 or 0
	la $a0, fib #prints F 
	li $v0, 4
	syscall
 
	move $a0, $t8
	li $v0, 1
	syscall
	
endFib:
	la $a0, newline #ending in newline
	li $v0, 4
	syscall
	
	li $v0, 10 #ending program
	syscall
	
	
	