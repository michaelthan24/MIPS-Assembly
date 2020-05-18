#Name : Than, Michael
#Project: #3
#Due: november 8 2019
#Course: cs-2640-02-f19
#Description: This mips program takes lines from the user to create a link list to print out using subprograms and recursion
		.data
name: 	.asciiz "M.Than's Link List\n\n"
inline:	.asciiz "Enter text? "
input:	.space 30
newline:.asciiz "\n"
		.text
main:
		la 		$a0, name						#printing out name
		li 		$v0, 4
		syscall		
		la		$t1, 0							#$t1 will serve as the head pointer
do:												#do while look until the user enters a new line to end text input
		la		$a0, inline						#ask user to enter line of text
		li		$v0, 4
		syscall
		
		li		$v0, 8			
		la		$a0, input						#stores user input
		li		$a1, 31							#allow 31 characters for 30 characters plus the new line character
		syscall
		
		lb		$t0, 0($a0)						#loads the first character of the string, if it is a newline then, break loop
		beq		$t0, '\n', enddo				#else continue
		jal		strdup							#string input is duplicated into $v0, $a0 has the string to duplicate
		move	$a0, $v0						#move the duplicated string into $a0 to be passed
		move 	$a1, $t1						#load head into $a1 as next node
		jal		addnode							#adds the duplicated user input into the beginning of the linked list
		move	$t1, $v0						#addnode returns the new node in $v0, then it will be set as the head
		b		do
enddo:
		la		$a0, newline					#print newline
		li		$v0, 4
		syscall
		move	$a0, $t1						#moves the head of the list to $a0 to be passed
		la 		$a1, print						#load address of the print procedure to be passed
		jal		traverse						#traverse the linked list and print out nodes
		
		li		$v0, 10							#end program
		syscall					
###

print:											#a0, string is loaded into $a0 to be printed
		lw		$a0, ($a0)						#load value of the passed node to be printed
		li		$v0, 4
		syscall
		la		$a0, newline					#print newline
		syscall
		jr		$ra

strlen:											#gets length of the string, string passed in $a0
		li		$v0, 0							# v0 : strlen
while:	lb		$a1, 0($a0)						# a1 <- char
		beq		$a1, '\n', endw					# while char != '\n'
		beqz	$a1, endw						# while char != '\0'
		addi	$v0, $v0, 1						# v0++ (len)
		addi	$a0, $a0, 1						# next char
		b		while
endw:											# len in $v0
		jr		$ra
		
strdup:											#string is passed through in $a0
		addi	$sp, $sp, -8
		sw		$ra, 4($sp)						#saving register onto stack
		sw		$a0, 0($sp)						#saving parameter onto stack
		jal		strlen							#passes string through to get length, returns the length is $v0
		lw		$ra, 4($sp)						#reloading return register
		move 	$a1, $v0						#move length into $a1 to be used as counter later
		li		$a0, 30							#allocate 30 bytes on the heap
		li		$v0, 9
		syscall									#syscall sbrk to create dynamic memory to duplicate string, the address to the memory is in $v0
		lw		$a0, 0($sp)						#load the string back into $a0
		addi	$sp, $sp, 8						#deallocate the stack
		move	$a3, $v0						#$a3 will be the moving pointer
copy: 	
		lb 		$a2, ($a0) 						#loading the first char of the string into $a2 
		sb 		$a2, ($a3)						#saving the byte into the address of the allocated memory
		addi	$a0, $a0, 1						#increment the source pointer
		addi  	$a3, $a3, 1						#increment target pointer
		addi 	$a1, $a1, -1					#decrement the counter, which is the length of the string
		bgtz	$a1, copy						#if the counter>0 then it will branch to copy, else it will continue
		
		jr		$ra								#duplicated string's address will be stored in $v0, then returned to main
		
addnode:
		addi	$sp, $sp, -4					#allocate memory on stack to save the data while we do sbrk
		sw		$a0, ($sp)	
		li		$a0, 8							#allocate 8 bytes to store data and next in heap
		li		$v0, 9		
		syscall
		lw		$a0, ($sp)
		addi	$sp, $sp, 4						#deallocate memory on stack	
		sw		$a0, ($v0)						#saving data into linked list
		sw		$a1, 4($v0)						#saving the linked next 

		
		jr		$ra								#returns the new node added in $v0

traverse:										#will traverse the list to the last node then print it out recursively
		addi	$sp, $sp, -8					#saving return register and head node onto stack
		sw		$ra, 4($sp)						
		sw		$a0, 0($sp)			
		bnez	$a0, iftrav						#if the node has 0, then the traverse will end
		addi	$sp, $sp 8						#pop stack
		jr		$ra	
iftrav:	
		lw		$a0, 4($a0)						#call traverse function with the next node
		jal		traverse						#traverse(node.next)
		lw		$a0, 0($sp)						#restore node
		addi	$sp, $sp, 4						#pop stack
		jalr	$a1								#pass node to be printed, the jump register to procedure 
		lw		$ra, ($sp)						#restore return register
		addi	$sp, $sp, 4						#pop stack
		jr		$ra								#jump to return register
