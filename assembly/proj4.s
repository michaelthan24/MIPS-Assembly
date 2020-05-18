#Name : Than, Michael
#Project: #4
#Due: november 27 2019
#Course: cs-2640-02-f19
#Description: This mips program takes a file of the periodic table elements and lists them in alphabetical order after storing them in a BST
		.data
name:	.asciiz "Periodic Table by M.Than\n"
numele:	.asciiz " Elements\n"
colon:	.asciiz ":"
newline:.asciiz "\n"
fname: 	.asciiz 								#removed file path
root:	.word 0
elname:	.space 64
atno: 	.word 0
		.text
main:
		la		$a0, name	
		li		$v0, 4
		syscall									#print name
		
		la		$a0, fname
		jal		openfile						#opening file, file name passed to $a0
		
		bltz	$v0, endpro						#if file cannot be found
		move	$s0, $v0						#saving file handle
		li		$s1, 0							#use s1 as the element counter
mainloop:										#reads the elements in the file and adds it to the tree
		move	$a0, $s0						#loads the file handler to pass 
		jal		nextint							#returns the next int in the file
		beq		$v1, -1, endpro					#ends loop if eof
		sw		$v0, atno						#save int into atno
		move	$a0, $s0						#load file handler
		la		$a1, elname						#load buffer
		jal		nextcstr						#returns strlen in $v0
		lw		$a0, atno						
		la		$a1, elname						#load the atno and elname to to create element
		jal		create_element					#the element will be returned in v0
		la		$a0, root						#load root and element to be passed
		move	$a1, $v0						
		jal		insert							#returns the new root
		lw		$v0, ($v0)
		sw		$v0, root						#saves the binary node in the root
		addi	$s1, $s1, 1						#increment element counter
		b		mainloop
endpro:
		move	$a0, $s1	
		li		$v0, 1	
		syscall									#print number of elements
		
		la		$a0, numele			
		li		$v0, 4							#print elements
		syscall
		
		la		$a0, root
		la		$a1, print_element				#load the root and procedure for in order traversal
		jal		inorder_traversal

		jal		closefile						#close the file
		
		li		$v0, 10
		syscall




##############################
nextint:										#a0 contains the file handler
		li		$t0, 0							#use $t0 as the sum for int 
		addi	$sp, $sp, -4					#allocate memory on stack to store first byte of int on file
		move	$a1, $sp						#buffer for read is on stack
		li		$a2, 1							#length for reading
		li		$v0, 14 
		syscall									#read first byte from file, byte is in $sp fter being read
		bne		$v0, 1, eof						#if the number of chars read does not equal 1 then end of file
intdo:	lb		$t1, ($sp)						#load first byte
		sub		$t1, $t1, '0'					#getting integer value of inputed string number
		mul		$t0, $t0, 10					#multiplying sum by base 
		add		$t0, $t0, $t1					#adding integer to sum to get integer value of string input
		move	$a1, $sp
		li		$a2, 1					
		li		$v0, 14							#reading next char
		syscall									#char is returned in $sp
		lb		$t2, ($sp)						#load next char to compare
		beq		$t2, '\n', endint				#if the newline is read then the subprogram is done, otherwise branch to intdo			
		b		intdo
eof:	
		addi	$sp, $sp, 4						#pop stack
		li		$v1, -1							#end of file status
		jr		$ra			
endint:	
		addi	$sp, $sp 4
		li		$v1, 0							#good status
		move	$v0, $t0						#move sum to $v0 to be returned
		jr		$ra
###		
nextcstr:										#a0 has file handle, #a1 has the buffer passed
		li		$t1, 0							# t1 will store string length
		li		$a2, 1							#read byte from file
nsloop:	li		$v0, 14
		syscall	
		lb		$t0, ($a1)						#load first char to see if it is not eof
		beq		$t0, -1, eofcstr
		beq		$t0, '\n', endcsloop			#check for newline char
		addi	$a1, $a1, 1						#increment pointer to buffer
		addi	$t1, $t1, 1						#increment strlen
		b		nsloop
endcsloop:
		sb		$0, ($a1)						#getting rid of newline char
		move	$v0, $t1
		li		$v1, 0							#good status
		jr		$ra								#return the strlen in $v0
eofcstr:
		li		$v1, 1							#eof status
		jr		$ra	
###		
openfile:										#a0 has the file name
		li		$a1, 0
		li		$a2, 0
		li		$v0, 13
		syscall									#open file
		jr		$ra								#$v0 is the handler
###		
closefile:										#a0 has the file handler
		li		$v0, 16
		syscall
		jr		$ra								#close file
###		
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
###		
strdup:											#string is passed through in $a0
		addi	$sp, $sp, -8
		sw		$ra, 4($sp)						#saving register onto stack
		sw		$a0, 0($sp)						#saving parameter onto stack
		jal		strlen							#passes string through to get length, returns the length is $v0
		lw		$ra, 4($sp)						#reloading return register
		move 	$a1, $v0						#move length into $a1 to be used as counter later
		li		$a0, 64							#allocate 64 bytes on the heap*********
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
		jr		$ra								#duplicated string's address will be stored in $v0
###		
create_element:									#a0 has anto, a1 has element name 
		addi	$sp, $sp, -8					#push stack to save atno onto stack
		sw		$a0, 4($sp)				
		sw		$ra, ($sp)						#save $ra
		move	$a0, $a1						#move a1 to a0 to duplicate string
		jal		strdup							#address of duplicated string in $v0
		move	$t0, $v0						#save the duplicated string in $t0
		li		$a0, 8							#allocate 8 bytes to store two datas
		li		$v0, 9							
		syscall									#allocate heap for element, address of allocated heap is in v0
		lw		$t1, 4($sp)						#reload atno from stack
		sw		$t1, ($v0)						#save atno to element
		sw		$t0, 4($v0)						#save element name to element
		lw		$ra, ($sp)						#reload $ra
		addi	$sp, $sp, 8						#pop stack
		jr		$ra								#v0 has the address of the new element; offset 0 has atno, offset 4 has element name
###
create_binarynode:								#a0 has the element to create a binary node
		move 	$t0, $a0						#move the element to t0 save 
		li		$a0, 12							#load 12 bytes to create space for data, right, and left
		li		$v0, 9							
		syscall									#create memory on heap for binary node with three datas, v0 has the address of the data node
		sw		$t0, ($v0)						#save the element into the data part of the binary node
		sw		$0, 4($v0)						#set the left and right nodes to null
		sw		$0, 8($v0)						
		jr		$ra								#v0 has the address to the new binary node created
###
strcmp:											#a0 has the new string to compare to, a1 has the string the new string is being compared to
		beqz	$a1, bcase						#if a1 have no string
cloop:	lb		$t0, ($a0)						#load a byte of first string 
		lb		$t1, ($a1)						#load a byte of second string 
		beqz	$t0, checks2					#if s1 is 0, check if s2 is also 0
		slt		$v0, $t1, $t0					#if s2 is less than s1/s1 is greater than s2, then load $v0 with 1
		beq		$v0, 1, greaterthan				#if s1 is greater than s2 then return
		slt		$v0, $t0, $t1					#if s1 is less than s2, load $v0 with 1
		beq		$v0, 1, lessthan				#if s1 is less than s2 then return
		addi	$a0, $a0, 1						#else increment s1 and s2
		addi	$a1, $a1, 1
		b		cloop
lessthan:
		li		$v0, -1							#load -1 to state s1 is less than s2
greaterthan:									#if greater than just return with $v0 as 1
		jr		$ra
checks2:
		bnez	$t1, lessthan					#if s2 is not zero then s1 is less than s2, else strings are the same
bcase:	li		$v0, 0							#base case if s2 has no string
		jr		$ra
###
insert:											#a0 will have the root node address, a1 has the element to be added
		lw		$t1, 0($a0)						#load the element of the root
		bnez	$t1, inltrt						#if the root node is empty continue, else branch to inltrt
		addi	$sp, $sp, -8					#allocate stack to store the root node, and ra
		sw		$ra, ($sp)						#save ra on stack
		sw		$a0, 4($sp) 					#save root node on stack
		move	$a0, $a1    					#move element to a0 to pass to create binary node
		jal		create_binarynode				#create binary node using the element, will return binary node in v0
		lw		$a0, 4($sp)						#reload rootnode address
		sw		$v0, ($a0)						#binarynode will be set as root
		lw		$ra, ($sp)						#reload return address
		move	$v0, $a0						#move root to v0 to return
		addi 	$sp, $sp, 8						#pop stack
		jr		$ra								#$v0 will have the new root node
inltrt:
		addi	$sp, $sp, -12					#allocate stack for a0, a1, ra
		sw		$ra, ($sp)						#save ra
		sw		$a0, 4($sp)						#save the root onto stack
		sw		$a1, 8($sp)						#save the new element to be added
		lw		$a0, ($a0)						#load the binary node
		lw		$a0, ($a0)						#load the element
		lw		$a0, 4($a0)						#load the element name
		lw		$a1, 4($a1)						#load the element from the new element
		jal strcmp								#compare the element name from the root to the new element name
		bgtz	$v0, inlt						#if root element name is greater than new element name insert to leftnode, else insert rightnode
		lw		$a0, 4($sp)						#restore the root node
		lw		$a0, ($a0)						#load bin node ############
		la		$a0, 8($a0)						#load right node of the root
		lw		$a1, 8($sp)						#restore the new element to be added
		jal		insert							#insert(root.right,element)
		lw		$a0, 4($sp)						#restore the root node
		lw		$ra, ($sp)						#restore ra
		move	$v0, $a0						#move root to return
		addi	$sp, $sp, 12					#pop stack
		jr		$ra
inlt:	lw		$a0, 4($sp)						#restore the root node
		lw		$a0, ($a0)						#loads the bin node
		la		$a0, 4($a0)						#load left node of the root
		lw		$a1, 8($sp)						#restore the new element to be added
		jal		insert							#insert(root.left,element)
		lw		$a0, 4($sp)						#restore the root node, $v0 has pointer to new node
		lw		$ra, ($sp)						#restore ra
		move	$v0, $a0						#move root to return
		addi	$sp, $sp 12						#pop stack
		jr		$ra								#$v0 will have the root
###
inorder_traversal:								#a0 has the root of the tree, a1 has the procedure
		addi	$sp, $sp, -8
		sw		$a0, 4($sp)						#save the root node
		sw		$ra, ($sp)						#save ra
		lw		$t0, ($a0)						
		bnez	$t0, inotrav					#if the root is 0 then return, else do in order traversal
		addi	$sp, $sp, 8						#pop stack
		jr		$ra								#return 
inotrav:
		lw		$a0, ($a0)						#loads root node
		la		$a0, 4($a0)						#load the left node	
		jal		inorder_traversal				#traverse left nodes
		lw		$a0, 4($sp)						#restore the root
		jalr	$a1								#prints element
		lw		$a0, 4($sp)						#restore the root again
		lw		$a0, ($a0)
		la		$a0, 8($a0)						#load right node
		jal		inorder_traversal				#traverse right nodes
		lw		$a0, 4($sp)						#restore the root
		lw		$ra, ($sp)						#restore return address
		addi	$sp, $sp, 8						#pop stack
		jr		$ra						
###
print_element:									#a0 has the element node
		move	$t0, $a0 						#move the element to t0 to save
		lw		$a0, ($a0)						#load the bin node
		lw		$a0, ($a0)						#load element
		lw		$a0, ($a0)						#load the anto of element
		li		$v0, 1						
		syscall									#print atno
		la 		$a0, colon						
		li		$v0, 4							#print colon
		syscall
		lw		$a0, ($t0)						#loads the bin node
		lw		$a0, ($a0)						#loads the element
		lw		$a0, 4($a0)						#load the element name
		li		$v0, 4							#print element name
		syscall
		la		$a0, newline					#print newline
		li		$v0, 4
		syscall
		jr		$ra								#return