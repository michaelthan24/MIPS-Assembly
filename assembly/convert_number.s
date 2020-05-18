#Name : Than, Michael
#Project: #2
#Due: october 25 2019
#Course: cs-2640-02-f19
#Description: A mips program converting c-style numbers to decimal numbers 
		.text					#if first character is not 0 then, it is decimal; if the second character is an 'X' then it is hex, if else it is an octal
convert_number:					#a0 passed through to be string to be converted, $a1 is the eos string character which is the newline
		
		lb		$t0, 0($a0)			#get the first char of the entered string
		bne		$t0, '0', dec			#if the first char is not a zero then it is a decimal, branch to dec
		add 	$a0, $a0, 1			#get the second char of the string
		lb		$t0, 0($a0)			#loads the second char
		beq		$t0, 'x', hex		#if the second char is "X" then it is a hex number, else it is a n octal
		
octal:	
		li		$t1, 8				#base will be stored into $t1
		li		$v0, 0				#load sum=0
		b		convertloop
hex:
		li		$t1, 16				#base stored into $t1
		li		$v0, 0				#load sum=0
		add		$a0, $a0, 1			#increment the pointer to third char
		b 		convertloop
dec:
		li		$t1, 10				#base store into $t1
		li		$v0, 0				#load sum=0
convertloop:						#converted number will be stored in $v0, counter will be $t2, this loop is doing sum=sum*base+digit
		lb		$t0, ($a0)			#load the first char
		beqz	$t0, endloop
		beq		$t0, $a1, endloop	#if the char is a '\n' then it will endloop
		add		$t3, $t0, -87		#converts hex letter value into its integer value; if the value is a negative number then it is not 'a-f'
		bltz	$t3, decjump		#branch to decjump if it is not 'a-f' hex number to convert integer numbers
		move	$t0, $t3			#move the integer number into $t1 be added to the product of the sum and base
deccon:	mul		$v0, $v0, $t1		#multiplying the sum of the converted number by the base then adding to the actual digit to get sum
		add		$v0, $v0, $t0		#getting digit value that was stored in $t1 and adding it to the sum
		add		$a0, $a0, 1			#increment the pointer
		b 		convertloop			#loop back to beginning
endloop:
		
		b		endsub
		
decjump:
		add		$t0, $t0, -48		#getting the digit value of the char by subtracting ascii value of '0' from the char
		b		deccon
		
endsub:		
		j		$ra					#return back to register