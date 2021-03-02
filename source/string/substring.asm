; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		substring.asm
;		Purpose:	Substring code for mid$ left$ right$
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;					Create substring of (p1,p2,p3) MID$ format for stack A
;										(e.g. indices from 1)
;
; ************************************************************************************************

StringSubstring:	;; <substring>
		pha
		tax 								; access stack.
		pshy 								; save Y
		jsr 	CopyStringTop 				; point temp0 to the string.

		ldy 	#0 							; get length.
		lda 	(temp0),Y 					
		sta 	temp1

		lda 	esInt0+1,x 					; get the initial offset
		cmp 	temp1 						; 
		beq 	_SSBOkay
		bcs 	_SSBReturnNull
_SSBOkay:
		lda 	temp1 						; get the total length +1
		clc 
		adc 	#1 							
		sec
		sbc 	esInt0+1,x 					; the anything >= this is bad.
		cmp 	esInt0+2,x  				; check bad >= required
		bcc		_SSBTrunc
		lda 	esInt0+2,x
_SSBTrunc:
		sta 	temp1+1 					; characters to copy.
		clc 
		adc 	#1 							; add 1 
		jsr 	AllocateSoftString 			; allocate soft string memory, set pointer.
		jsr 	CopySoftToStack 			; copy that to the stack.
		ldy 	esInt0+1,x 					; get initial position of char to copy
_SSBCopyLoop:
		lda 	temp1+1 					; done them all
		beq 	_SSBExit		
		dec 	temp1+1
		lda 	(temp0),y 					; get and write character
		jsr 	WriteSoftString
		iny
		jmp 	_SSBCopyLoop

_SSBReturnNull:
		jsr 	ReturnNull
_SSBExit:
		puly 								; restore Y
		pla
		rts

; ************************************************************************************************
;
;								Return NULL string ""
;
; ************************************************************************************************

ReturnNull:
		lda 	#0 							; clear null string
		sta 	NullString
		lda 	#NullString & $FF 			; set a pointer to it
		sta 	esInt0,x
		lda 	#NullString >> 8
		sta 	esInt1,x
		rts



		.send 	code