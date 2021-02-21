; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32fromstr.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Convert string to integer on stack.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Convert string at (temp0) to integer base A
;					  Returns A => Number of characters read
;
; *****************************************************************************

MInt32FromString:
		sta 	tempShort 					; save base
		pshy  								; save Y
		ldy 	#0 							; set index into string being read
		lda 	(temp0),y 					; look at first character
		cmp 	#"-"						; is it a - character
		bne 	_I32FSNotNegative 			
		iny 								; if so consume it.
_I32FSNotNegative:
		lda 	tempShort 					; get the base back.
		cpy 	#0 							; if we read a -ve (e.g. Y != 0)
		beq 	_I32FSNN2
		ora 	#$80						; set bit 7, this indicates a negated result.
_I32FSNN2:
		pha 								; save base + final sign on stack.
		jsr 	MInt32False 					; zero the return value.		
		;
		;		Main loop - get and process one character.
		;
I32FSMainLoop:
		pla 								; get the base back into tempshort
		pha
		and 	#$7F
		sta 	tempShort
		;
		lda 	(temp0),y 					; look at next character.
		cmp 	#"a" 						; fix up case.
		bcc 	_I32FSNotLC
		sbc 	#32
_I32FSNotLC:		
		sec 								; subtract 48 (ASCII "0")
		sbc 	#"0"
		bcc 	_I32FSDone 					; nothing more to do.
		cmp 	#9+1 						; if it is 0-9 validate vs base.
		bcc 	_I32FSValidate 			
		;
		cmp 	#17 						; is it between 58 and 64 ? if so bad.
		bcc 	_I32FSDone
		sbc 	#7 							; adjust into range so now character is 0->nnn
_I32FSValidate:
		cmp 	tempShort 					; compare against the base.
		bcs 	_I32FSDone 					; sorry, too large for this base.
		pha 								; save the new digit value.

		inx 								; put base into next slot.
		lda 	tempShort
		jsr 	MInt32Set8Bit
		dex
		jsr 	MInt32Multiply 				; multiply current by the base
		inx
		pla  								; put additive into next slot
		jsr 	MInt32Set8Bit		
		dex
		jsr 	MInt32Add 					; and add it
		iny 								; look at next character
		jmp 	I32FSMainLoop 				; and go round again.
		;
_I32FSDone:
		pla 								; get base/final sign back
		bpl 	_I32FSNN3 				
		;
		dey 								; one fewer character to allow for the - prefix.
		jsr 	MInt32Negate 				; negate the result.
_I32FSNN3:
		sty 	tempShort 					; save the count of characters read
		puly 								; restore Y
		lda 	tempShort 					; get the count of characters read into A and exit		
		rts
