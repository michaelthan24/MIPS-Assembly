#Name: Than, Michael
# Project: # 5
# Due: 6 december 2019
# Course: cs-2640-02-f19
# Description: this subprogram is used to find the squareroot of a passed floating number
		.text
bsqrt:										#takes from f12 the discriminant, "n" to find squareroot
		li.s	$f4, 0.000001						#load precision for squareroot
		li.s	$f7, 2.0
		div.s	$f5, $f12, $f7						#divide the discriminant by 2 to get first guess-> "y"
		mov.s	$f0, $f12						#move discriminant into f0 -> "x"
sqloop:
		sub.s	$f6, $f0, $f5				
		c.lt.s	$f6, $f4						# if (x-y < precision) then end loop, and squareroot is in $f12
		bc1t	endloop	
		add.s	$f0, $f0, $f5	
		li.s	$f7, 2.0
		div.s	$f0, $f0, $f7						# x = (x+y) / 2
		div.s	$f5, $f12, $f0						# y = n / x
		b	sqloop
endloop:									#at the end of the loop the square root will be in f0
		jr	$ra							#square root already in f0 to be returned