; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32tostr.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Reviewed: 	7th March 2021
;		Purpose:	Convert string to integer on stack.
;
; *****************************************************************************
; *****************************************************************************

		.section storage
MCharCount:	.fill 	1						; count of converted characters
		.send storage

; *****************************************************************************
;
;	 Convert integer on TOS to string at (temp0). A is Base. Bit 7 is sign.
;				String is stored in ASCIIZ with leading count
;
;	  Note: with base 1 or 2 34 or 18 bytes may be required for the buffer
;
; *****************************************************************************

		.section code		
		
MLInt32ToString: ;; <inttostr>						
		tax									; module passes stack in A, base in Y
		tya
		jsr 	MInt32ToString
		txa
		rts
		
MInt32ToString: 
		pha 								; save base
		sta 	tempShort 					; save target base.
		lda 	#0
		sta 	MCharCount 					; clear character count to 0
		.pshy 								; save Y on the stack.
		;
		lda 	tempShort 					; check if we are signed conversion
		bpl 	_I32TSUnsigned 
		pha 								; save base on stack.
		lda 	esInt3,x 					; is it actually negative
		bpl 	_I32TSNoFlip
		;
		lda 	#"-" 						; write a '-' prefix out.
		jsr 	MI32WriteCharacter 			
		jsr 	MInt32Negate 				; negate the value, so now it's positive.
_I32TSNoFlip:
		pla 								; get the base back
		and 	#$7F 						; clear the sign flag so it's just a base now.		
_I32TSUnsigned:		
		jsr 	MI32DivideWrite 			; recursive code to output string.
		ldy 	#0 							; write charcount to first character.
		lda 	MCharCount 
		sta 	(temp0),y	
		.puly 								; restore YA
		pla
		rts
;
; 		Divide value by base in A ; if result is non-zero do it again, then output the modulus.
;
MI32DivideWrite:
		pha 								; save the divisor/base
		inx 								; write in the dividing position.
		jsr 	MInt32Set8Bit
		dex
		jsr 	MInt32UDivide 				; divide number by base.
		;
		pla 								; get the base into Y
		tay
		lda 	esInt0+2,x 					; get the remainder and push on the stack.
		pha
		;
		jsr 	MInt32Zero 					; is the result zero ?
		beq 	_I32NoRecurse 				; if so, don't recurse.
		;
		tya 								; put base into A
		jsr 	MI32DivideWrite 				; and jsr the dividor recursively.
_I32NoRecurse:
		pla 								; get the remainder back
		cmp 	#10  						; handle hexadecimals, now converting to ASCII
		bcc 	_I32NotHex		
		adc 	#7-1
_I32NotHex:
		clc 								; make it ASCII
		adc 	#48		
		jsr 	MI32WriteCharacter 			; write the character out
		rts 								; and exit.
;
;		Write character A out to the target string (breaks Y)
;
MI32WriteCharacter:
		inc 	MCharCount 					; bump count (space for leading count)
		ldy 	MCharCount 					; get position
		sta 	(temp0),y 					; write out with trailing 0
		iny
		lda 	#0
		sta 	(temp0),y
		rts

		.send code		
				
; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
				