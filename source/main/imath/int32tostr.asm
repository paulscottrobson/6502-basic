; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32tostr.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Convert string to integer on stack.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;	 Convert integer on TOS to string at (temp0). A is Base. Bit 7 is sign.
;							String is stored in ASCIIZ
;
;	  Note: with base 1 or 2 34 or 18 bytes may be required for the buffer
;
; *****************************************************************************

Int32ToString:
		pha 								; save base
		sta 	tempShort 					; save target base.
		lda 	#0
		sta 	IToSCount 					; clear character count.
		pshy 								; save Y on the stack.
		;
		lda 	tempShort 					; check if we are signed conversion
		bpl 	_I32TSUnsigned 
		pha 								; save base on stack.
		lda 	esInt3,x 					; is it actually negative
		bpl 	_I32TSNoFlip
		;
		lda 	#"-" 						; write a '-' prefix out.
		jsr 	I32WriteCharacter 			
		jsr 	Int32Negate 				; negate the value.
_I32TSNoFlip:
		pla 								; get the base back
		and 	#$7F 						; clear the sign flag so it's just a base now.		
_I32TSUnsigned:		
		jsr 	I32DivideWrite 				; recursive code to output string.
		puly 								; restore YA
		pla
		rts
;
; 		Divide value by base in A ; if result is non-zero do it again, then output the modulus.
;
I32DivideWrite:
		pha 								; save the divisor/base
		inx 								; write in the dividing position.
		jsr 	Int32Set8Bit
		dex
		jsr 	Int32UDivide 				; divide number by base.
		;
		pla 								; get the base into Y
		tay
		lda 	esInt0+2,x 					; get the remainder and push on the stack.
		pha
		;
		jsr 	Int32Zero 					; is the result zero ?
		beq 	_I32NoRecurse 				; if so, don't recurse.
		;
		tya 								; put base into A
		jsr 	I32DivideWrite 				; and jsr the dividor recursively.
_I32NoRecurse:
		pla 								; get the remainder back
		cmp 	#10  						; handle hexadecimals.
		bcc 	_I32NotHex		
		adc 	#7-1
_I32NotHex:
		clc 								; make it ASCII
		adc 	#48		
		jsr 	I32WriteCharacter 			; write the character out
		rts 								; and exit.
;
;		Write character A out to the target string (breaks Y)
;
I32WriteCharacter:
		ldy 	IToSCount 					; get position
		sta 	(temp0),y 					; write out with trailing 0
		iny
		lda 	#0
		sta 	(temp0),y
		inc 	IToSCount 					; bump count
		rts

		rts
