#Name: Than, Michael
# Homework: #5
# Due: 11/20/19
# Course: cs-2640-02-f19
# Description: subprograms openfile, closefile, nextint, nextcstr to use in bigger project
		.data
fname: 	.asciiz 						#removed path 
name:	.asciiz "Periodic Tabble by M. Than\n"
elem:	.asciiz " elements"
col:	.asciiz ":"
tild:	.asciiz "~"
newline:.asciiz	"\n"
ano:	.word	0
elename:.space 32
		.text
main:
		la		$a0, name
		li		$v0, 4
		syscall							#print name
		
		la		$a0, fname
		jal		openfile				#opening file, file name passed to $a0
		
		bltz	$v0, endpro				#if file cannot be found
		move	$s0, $v0				#saving file handle
		move	$a0, $s0				#passing file handle use next int subprogram
		jal		nextint		
		bnez	$v1, endpro
		sw		$v0, ano
		
do:
		move	$a0, $s0				#load parameters to call nextcstr
		la		$a1, elename
		jal		nextcstr
		move	$t0, $v0				#moving strlen into $t0
		li		$v0, 1					#printing ano
		lw		$a0, ano
		syscall
		la		$a0, col
		li		$v0, 4					#print colon
		syscall
		li		$v0, 1					
		move	$a0, $t0				#printing out strlen
		syscall
		la		$a0, tild				#print tild
		li		$v0, 4
		syscall
		li		$v0, 4
		la		$a0, elename			#printout element name
		syscall
		la		$a0, newline
		syscall
		move	$a0, $s0
		jal		nextint					#get the next ano in file
		beq		$v1, -1, endpro			#if end of file end loop
		sw		$v0, ano
		beqz	$v1, do					#if end of file continue, else loop back to do
endpro:	
		la		$a0, newline
		li		$v0, 4
		syscall
		lw		$a0, ano
		li		$v0, 1
		syscall
		la		$a0, elem	
		li		$v0, 4
		syscall							#print elem		
		li		$v0, 10					#end program
		syscall	





openfile:								#a0 has the file name
		li		$a1, 0
		li		$a2, 0
		li		$v0, 13
		syscall							#open file
		jr		$ra						#$v0 is the handler
closefile:								#a0 has the file handler
		li		$v0, 16
		syscall
		jr		$ra						#close file
nextint:								#a0 contains the file handler
		li		$t0, 0					#use $t0 as the sum for int 
		addi	$sp, $sp, -4			#allocate memory on stack to store first byte of int on file
		move	$a1, $sp				#buffer for read is on stack
		li		$a2, 1					#length for reading
		li		$v0, 14 
		syscall							#read first byte from file, byte is in $sp fter being read
		bne		$v0, 1, eof				#if the number of chars read does not equal 1 then end of file
intdo:	lb		$t1, ($sp)				#load first byte
		sub		$t1, $t1, '0'			#getting integer value of inputed string number
		mul		$t0, $t0, 10			#multiplying sum by base 
		add		$t0, $t0, $t1			#adding integer to sum to get integer value of string input
		move	$a1, $sp
		li		$a2, 1					
		li		$v0, 14					#reading next char
		syscall							#char is returned in $sp
		lb		$t2, ($sp)				#load next char to compare
		beq		$t2, '\n', endint		#if the newline is read then the subprogram is done, otherwise branch to intdo			
		b		intdo
eof:	
		addi	$sp, $sp, 4				#pop stack
		li		$v1, -1					#end of file status
		jr		$ra			
endint:	
		addi	$sp, $sp 4
		li		$v1, 0					#good status
		move	$v0, $t0				#move sum to $v0 to be returned
		jr		$ra
nextcstr:								#a0 has file handle, #a1 has the buffer passed
		li		$t1, 0					# t1 will store string length
		li		$a2, 1					#read byte from file
nsloop:	li		$v0, 14
		syscall	
		lb		$t0, ($a1)				#load first char to see if it is not eof
		beq		$t0, -1, eofcstr
		beq		$t0, '\n', endcsloop	#check for newline char
		addi	$a1, $a1, 1				#increment pointer to buffer
		addi	$t1, $t1, 1				#increment strlen
		b		nsloop
endcsloop:
		sb		$0, ($a1)				#getting rid of newline char
		move	$v0, $t1
		li		$v1, 0					#good status
		jr		$ra						#return the strlen in $v0
eofcstr:
		li		$v1, 1					#eof status
		jr		$ra						
		