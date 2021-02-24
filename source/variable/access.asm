; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		access.asm
;		Purpose:	Access a variable.
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;					Put a reference on the stack at A, returns stack level in A.
;
; ************************************************************************************************

AccessVariable:	;; <access>

		tax 								; stack in X
		iny							
		lda 	(codePtr),y
		dey
		cmp 	#TYPE_INT 					; is it one of the end markers ?
		bne 	_AVLong
		;
		;		Integer variable A-Z which are much quicker.
		;
		lda 	(codePtr),y 				; this is the 6 bit ASCII of A-Z 1-26
		sec 	 							; make it 0-25
		sbc 	#1
		asl 	a 							; x 4 is LSB of address
		asl 	a
		sta 	esInt0,x
		lda 	#SingleLetterVar >> 8 		; make it an address
		sta 	esInt1,x
		lda 	#$80 						; type is integer reference.
		sta 	esType,x
		iny 								; skip over the variable reference in the code.
		iny 
		txa 								; stack in A to return.
		rts
		;
		;		The second character isn't integer variable, so it can't be a default integer
		;
_AVLong:
		bra 	_AVLong

