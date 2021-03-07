; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32fromstr.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Reviewed: 	7th March 2021
;		Purpose:	Convert string to integer on stack.
;
; *****************************************************************************
; *****************************************************************************

		.section storage
fs32Length: 								; length of string being converted.
		.fill 	1
		.send storage
		.section code		
		
; *****************************************************************************
;
;					Convert string at (temp0) to integer base A
;					  		Returns CS if successful.
;
; *****************************************************************************

MInt32FromString:
		sta 	tempShort 					; save base
		.pshy  								; save Y
		ldy 	#0 							; get length of string to convert
		lda 	(temp0),y
		sta 	fs32Length 
		beq 	_I32FSFail2					; fail if length zero.
		;
		ldy 	#1 							; set index into string being read
		lda 	(temp0),y 					; look at first character
		cmp 	#"-"						; is it a - character
		bne 	_I32FSNotNegative 			
		lda 	fs32Length 					; get length back.
		cmp 	#1 							; if 1 it is just a - on its own so fail.
		beq 	_I32FSFail2
		ldy 	#2 							; first digit of the number. 								
_I32FSNotNegative:
		lda 	tempShort 					; get the base back.
		cpy 	#2 							; if we read a -ve (e.g. Y == 2)
		bne 	_I32FSNN2
		ora 	#$80						; set bit 7, this indicates a negated result.
_I32FSNN2:
		pha 								; save base + final sign on stack.
		jsr 	MInt32False 				; zero the return value.		
		;
		;		Main loop - get and process one character.
		;
_I32FSMainLoop:
		pla 								; get the base back into tempShort
		pha
		and 	#$7F
		sta 	tempShort
		;
		lda 	(temp0),y 					; look at next character.
		cmp 	#"a" 						; fix up case.
		bcc 	_I32FSNotLC
		sbc 	#32
_I32FSNotLC:		
		sec 								; subtract 48 (ASCII "0") - ASCII to Hex conversion
		sbc 	#"0"
		bcc 	_I32FSFail 					; nothing more to do.
		cmp 	#9+1 						; if it is 0-9 validate vs base.
		bcc 	_I32FSValidate 			
		;
		cmp 	#17 						; is it between 58 and 64 ? if so bad.
		bcc 	_I32FSFail
		sbc 	#7 							; adjust into range so now character is 0->nnn
_I32FSValidate:
		cmp 	tempShort 					; compare against the base.
		bcs 	_I32FSFail 					; sorry, too large for this base, so fail.

		pha 								; save the new digit value.
		inx 								; put base into next slot up on stack
		lda 	tempShort
		jsr 	MInt32Set8Bit
		dex
		jsr 	MInt32Multiply 				; multiply current by the base
		inx
		pla  								; put additive into next slot
		jsr 	MInt32Set8Bit		
		dex
		jsr 	MInt32Add 					; and add it
		iny 								; bump the character pointer
		cpy 	fs32Length 					; until > length.
		beq 	_I32FSMainLoop 
		bcc 	_I32FSMainLoop
		;
_I32FSDone:
		pla 								; get base/final sign back
		bpl 	_I32FSNN3 				
		jsr 	MInt32Negate 				; negate the result.
_I32FSNN3:
		.puly 								; restore Y
		sec
		rts

_I32FSFail:
		pla
_I32FSFail2:
		.puly
		clc
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
		