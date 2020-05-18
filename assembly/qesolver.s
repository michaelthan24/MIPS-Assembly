#Name: Than, Michael
# Project: # 5
# Due: 6 december 2019
# Course: cs-2640-02-f19
# Description: this project uses subprogram square root to find use the quadtratic formula
		.data
name:	.asciiz "QE by M.Than\n\n"
newline:.asciiz "\n"
entera:	.asciiz "Enter a? "
enterb:	.asciiz "Enter b? "
enterc: .asciiz "Enter c? "
errz:	.asciiz "Not quadtratic"
imag:	.asciiz "Imaginary roots"
x1:		.asciiz "\nx1 = "
x2: 	.asciiz "\nx2 = "
		.text
main:
		la		$a0, name
		li		$v0, 4
		syscall								#print out header
		
		la		$a0, entera
		li		$v0, 4
		syscall								#prompt user for a
		
		li		$v0, 6						#read float for a
		syscall
		mov.s		$f20, $f0					#move read float into another register, a > $f20
		
		li.s		$f0, 0.0					#load 0 to check a for zero
		c.eq.s		$f20, $f0					#if f4 = f0/a = 0 then end; not quadtratic
		bc1t 		notquad						#branch to not quad if a=0
		
		la		$a0, enterb	
		li		$v0, 4
		syscall								#prompt user for b
		
		li		$v0, 6						#read float for b
		syscall
		mov.s 		$f21, $f0					#move read float into another register, b > $f21
		
		la		$a0, enterc
		li		$v0, 4
		syscall								#prompt user for c
		
		li		$v0, 6						#read float for c
		syscall
		mov.s		$f22, $f0					#move read float into another register, c > $f22
		
		mul.s		$f4, $f21, $f21					# compute b^2 and store into f4
		mul.s		$f5, $f22, $f20					# compute a*c and store into $f5
		li.s		$f7, 4.0
		mul.s		$f6, $f5, $f7					# compute 4 * (a*c) and store into $f6
		sub.s		$f4, $f4, $f6					# compute b^2 -4ac and store discriminant into f4
		li.s		$f0, 0.0					#load 0 to compare discriminant
		c.lt.s		$f4, $f0					#if discriminant < 0, then imaginary roots
		bc1t		imgrts
		mov.s		$f12, $f4					#move the discriminant into f12 to pass into square root
		jal		bsqrt						#f0 will return the square root
		li.s		$f1, -1.0				
		mul.s		$f21, $f21, $f1					#get -b
		li.s		$f1, 2.0
		mul.s		$f20, $f20, $f1					#get 2a
		sub.s		$f4, $f21, $f0					# -b - discriminant
		div.s		$f4, $f4, $f20					# divide by 2a, x1 is in f4
		add.s		$f5, $f21, $f0					# -b + discriminant
		div.s		$f5, $f5, $f20					#divide by 2a, x2 is in f5
		
		la		$a0, x1
		li		$v0, 4
		syscall								#print x1 message
		
		mov.s		$f12, $f4					#move x1 into f0 to print
		li		$v0, 2
		syscall
		
		la		$a0, x2		
		li		$v0, 4	
		syscall								#print x2 message
		
		mov.s		$f12, $f5					#move x2 into f0 to print
		li		$v0, 2
		syscall
		b		endpro
imgrts:	
		la		$a0, imag					#discriminant < 0 message
		li		$v0, 4
		syscall
		b		endpro
notquad:
		la		$a0, errz					# a=0 error message
		li		$v0, 4
		syscall
		
endpro:		li		$v0, 10						#end program
		syscall