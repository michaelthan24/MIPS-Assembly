#Name : Than, Michael
#Homework: #4
#Due: october 18 2019
#Course: cs-2640-02-f19
#Description: A mips program calculating the fibonacci number 0-12 using a subprogram
		.data
name: 	.asciiz "Fibonacci by M.Than\n"
newline:.asciiz "\n"
		
		.text		
main: 
		la 		$a0, name
		li 		$v0, 4
		syscall						#print out name

		la		$a0, newline
		li		$v0, 4			
		syscall						#print out newline
		
		li 		$t0, 12				#load the n times for fibonacci sequence which is 12 into $t0
		li		$t1, 0 				#the counter from 0
floop:								#for loop for fibonacci sequence n times
		move	$a0, $t1			#moving n into argument register
		jal		fib					#calls fib subprogram
		
		move	$a0, $v0			#moves returned fib number into register to be printed
		li		$v0, 1				#prints fib number
		syscall
		
		la		$a0, newline
		li		$v0, 4
		syscall						#prints newline
		
		beq		$t0, $t1, endfloop	#end loop if counter equals 0
		add		$t1, $t1, 1			#decrements counter
		b floop
		
endfloop:
		
		li		$v0, 10
		syscall						#end program
		
		
fib:								#returns fib number in $v0, takes in n in $a0, $a0 will also be the counter
		li		$a1, 1				#load base case as arguments
		li		$a2, 0	
		
		beqz	$a0, basecase		#takes care of base cases if n is 0 or 1	
		beq		$a0, 1, basecase		
fibloop:							#loop to calculate fibonacci number if n > 1
		beq		$a0, 1, endfibloop
		add		$a3, $a1, $a2		#finds new fib number then stores into $a3
		move	$a2, $a1			#storing new n-2 into $a2
		move	$a1, $a3			#storing new n-1 into $a1, at end of loop, final fibonacci number should be in $a1
		add		$a0, $a0, -1		#decrement the counter
		b		fibloop
		
endfibloop:							#if counter>0 then continue loop, else continue
		move 	$v0, $a1			#fib number is stored in $a1
		b		endfib
		
basecase:
		move 	$v0, $a0		#fib number is stored in $a0, or n
		
endfib:
		jr		$ra					#jump back to register address