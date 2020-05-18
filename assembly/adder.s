#Name : Than, Michael
#Project: #2
#Due: october 25 2019
#Course: cs-2640-02-f19
#Description: a mips program using a convert_number subprogam to add two c-ctyle integers
		.data
name: 	.asciiz "Adder by M.Than\n"
lt:		.asciiz "\nEnter lhs? "
rt:		.asciiz "Enter rhs? "
newline:.asciiz "\n"
lhs:	.space 10
rhs:	.space 10						#read the string until there is \n or 0, jal convert number after passing the string through
		
		.text
main:
		la 		$a0, name				#print out name
		li		$v0, 4
		syscall
		
		la		$a0, lt
		li		$v0, 4
		syscall							#prompt user to enter left hand side
		
		li		$v0, 8				
		la		$a0, lhs
		la		$a1, 11
		syscall							#stores user input into lhs
		
		la		$a0, rt
		li		$v0, 4		
		syscall							#prompt user to enter right hand side
		
		li		$v0, 8
		la		$a0, rhs
		la		$a1, 11
		syscall							#stores user input into rhs
		
		la		$a0, rhs				#passing rhs through $a0
		li		$a1, '\n'			#passing newline for eos argument
		jal		convert_number
		
		move	$s0, $v0				#storing return value into register from return register $v0
		
		la		$a0, lhs				#passing lhs to $a0 to convert_number
		la		$a1, '\n'			#passing eos argument to $a1
		jal		convert_number
		
		move	$s1, $v0				#storing return value into register from return register $v0
		
		add		$t0, $s0, $s1			#adding the two number converted from c-style string from the user and storing sum into $t0
		
		move	$a0, $t0				#printing out sum of the two added numbers
		li		$v0, 1
		syscall
		
		li		$v0, 10
		syscall