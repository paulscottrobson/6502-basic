# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokendata.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		3rd April 2021
#		Purpose:	Token class
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

# *****************************************************************************
#
#					Tokens : Raw Data as a Python Class
#
# *****************************************************************************

class TokenData(object):
	#
	#		Tokens Source. Currently done by hand.
	#
	def getSource(self):
		return """
		##
		##		Binary operators, must be first.
		##
		[1] and or xor
		[2] >= <= > < = <>
		[3] + -
		[4] >> << * / mod
		[5] ^
		[6] ! ?
		##
		##		Operators that effect the structure depth follow.
		[+] 
			repeat 	while 	for 	if 		defproc
		[-] 
			until 	wend 	next 	then 	endif 	endproc
		##
		##
		##		Then unary functions follow (not floating point ones.)
		##
		[unary]
			(
			len( 	sgn( 	abs( 	random(	page	
			true	false	min( 	max( 	sys(
			timer(	event(	get( 	inkey(	alloc( 	
			chr$(	left$(	mid$(	right$(	str$(
			val(	peek( 	deek(	leek( 	asc(
			int(	float( 	isval(	upper$(	lower$(
			@		~ 		&		get$(	inkey$(
			mem
		##
		##		Then command and syntax and so on.
		##
		[command]
			) 		: 		, 		; 		'
			to 		step 	proc 	local	dim		
			rem 	let 	input	else	vdu 	
			print	data	image 	at 		flip
			assert 	poke 	doke 	loke 	ink
			paper 	cls 	locate 	.		from
			# 		clear 	text
		##
		##		Put these in group 1.
		##
		[group1]
			load	save 	list 	new 	break	
			run 	read 	restore	end 	stop
			xemu 	goto 	gosub 	return
		##
		##		System specific commands in group 2
		##
		[group2]
			vpoke	vdoke	vload	mode 	palette
			sprite	clg		rect 	frame 	draw
			plot 	line	paint
		##
		##		Floating point functions and system unary functions in group 3.
		##
		[group3]
			vpeek( 	vdeek(	sprite.x(	sprite.y(	
			hit(	joy.x(	joy.y(		joy.b(
			clock(
"""		
