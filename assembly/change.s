#
#Name: Than, Michael
#Project: #1
#Due: september 30 2019
#Course: cs-2640-02-f19
#Description: A mips program printing out change in form of quarters, dimes, nickels, and pennies
.data
name: .asciiz "M. Than's Change\n"
promptUser: .asciiz "\nEnter the change? "
quarter: .asciiz "\nQuarter: "
dime: .asciiz "\nDime: "
nickel: .asciiz "\nNickel: "
penny: .asciiz "\nPenny: "
newline: .asciiz "\n"
.text
main:
	la $a0, name #printing out name
	li $v0, 4
	syscall

	la $a0, promptUser #ask user to input change amount
	li $v0, 4
	syscall
	
	li $v0, 5 #read the change entered
	syscall
	move $t2, $v0 #store change into $t2
	li $s1,0 #will be used in beq arguments
	
	# number of quarters will be stored in $t3
	# number of dimes will be stored in $t4
	# number of nickels will be stored in $t5
	# number of pennies will be stored in $t6
	
	li $s0, 25 #calculating quarters
	div $t2, $s0
	mfhi $t0 #remainders will be stored in $t0
	mflo $t1 #quotients will be stored in $t1
	move $t3, $t1 #move number of quarters into quarter register
	
	la $a0, quarter #print out message for quarters
	li $v0, 4
	syscall
	
	beq $t3, $s1, L1 #if no quarters are needed program will jump to L1
	move $a0, $t3 #print out number of quarters
	li $v0, 1
	syscall
	
	L1:
	li $s0, 10 #calculating dimes
	div $t0, $s0
	mfhi $t0 #remainder
	mflo $t1 #quotient 
	move $t4, $t1 #move number of dimes into dime register
	
	la $a0, dime #print message for dimes
	li $v0, 4
	syscall
	
	beq $t4, $s1, L2 #if no dimes are needed program will jump L2
	move $a0, $t4 #print out number of dimes
	li $v0, 1
	syscall
	
	L2:
	li $s0, 5 #calculating nickels
	div $t0, $s0
	mfhi $t0 #remainder
	mflo $t1 #quotient
	move $t5, $t1 #move number of nickels into nickel register
	
	la $a0, nickel #print out message for nickels
	li $v0, 4
	syscall
	
	beq $t5, $s1, L3 #if no nickels are needed program will jump L3
	move $a0, $t5 #print out numder of nickels
	li $v0, 1
	syscall
	
	L3:
	la $a0, penny #print out message for pennies
	li $v0, 4
	syscall
	
	move $t6, $t0 #move remainders into pennies register
	
	beq $t6, $s1, L4 #if no pennies are needed then program will jump to L4 
	move $a0, $t6 #print out pennies
	li $v0, 1
	syscall
	
	L4:
	la $a0, newline # end program on new line
	li $v0, 4
	syscall 
	
	li $v0, 10
	syscall 
	#end program 