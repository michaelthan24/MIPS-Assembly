#Name : Than, Michael
#Homework: #3
#Due: october 11 2019
#Course: cs-2640-02-f19
#Description: This mips program takes a string from the user and counts the letters in the string and prints out the string in reverse order
		.data
strIn:	.asciiz "String by M. Than\n"
prompt:	.asciiz "\nEnter a string? "
newline:.asciiz "\n"
colon:	.asciiz ":"
input:	.space 128
		.text
main: 	
		la		$a0, strIn
		li 		$v0, 4
		syscall 					#print out name
		
		la 		$a0, prompt
		li		$v0, 4
		syscall  					#prompt user to enter an integer
		
		li		$v0, 8				#storing user input into input
		la		$a0, input			#input limited to 128 bytes
		li		$a1, 128
		syscall						#reads user input
		
		la	 	$t0, input 			#loading address of input
		li		$t3, '\n'			#newline loaded for branch argument
		
countLen:
		lb		$t2, 0($t0)			#loading the first byte from the address
		beqz	$t2, countExit		#if $t2 is equal to 0 then go to countExit
		beq 	$t2, $t3, countExit	#if $t2 is equal to newline then go to countExit
		add		$t1, $t1, 1			#increment counter by one
		add		$t0, $t0, 1 		#increment the address by one
		b 		countLen			#when the loop is over the length of the inputed string is stored in $t1

countExit:
		move 	$a0, $t1			#printing out string length
		li		$v0, 1
		syscall
		
		la		$a0, newline		#printing new line
		li 		$v0, 4			
		syscall
		
		la		$t4, input			#loading input $t4
prinIn:								#printing out the user input
		beq		$t1, $t6, prinInX	#branch if the counter equals the string length
		lb 		$t5, 0($t4)			#loading char into $t5
		move	$a0, $t5
		li		$v0, 11				#printing the char 
		syscall
		add		$t6, $t6, 1			#increment the counter
		add		$t4, $t4, 1			#increment the address
		b		prinIn
		
prinInX:		
		la 		$a0, colon			#printing out colon
		li		$v0, 4
		syscall

revPrint:							#branch to print out string in reverse
		addi 	$t0, $t0, -1		#decrement the address because of the newline by input
		lb 		$t2, 0($t0)			#load the char into $t2
		move	$a0, $t2			
		li 		$v0, 11				#printing out the character reverse order
		syscall	
		addi	$t1, $t1, -1		#decrement the counter
		beqz	$t1, endPrint		#if the counter is less than 0 then it will branch to endPrint
		b 		revPrint		
		
endPrint:
		li 		$v0, 10 			#end program
		syscall