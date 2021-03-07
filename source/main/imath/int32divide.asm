; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32divide.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Reviewed: 	7th March 2021
;		Purpose:	32 bit unsigned/signed divide
;
; *****************************************************************************
; *****************************************************************************

		.section code		
		
; *****************************************************************************
;
;							 32 bit signed divide
;
; *****************************************************************************

MInt32SDivide:
		tya  								; save Y, which is the count of negations		
		pha 
		ldy 	#0 							; zero count
		jsr 	_MInt32SRemSign 			; unsign TOS
		inx 								; unsign TOS+1
		jsr 	_MInt32SRemSign
		dex
		tya 								; save sign count on stack
		pha
		jsr 	MInt32UDivide 				; unsigned division
		pla 								; get sign count back
		and 	#1 							; if it is odd, then negate result
		beq 	_I32SNoNeg
		jsr 	MInt32Negate 				
_I32SNoNeg:
		pla 								; restoe Y and exit
		tay
		rts
		;
_MInt32SRemSign:
		lda 	esInt3,x 					; is it -ve
		bpl 	_MInt32SRSExit 				
		iny 								; increment the sign count
		jsr 	MInt32Negate 				; negate the value.
_MInt32SRSExit:
		rts				

; *****************************************************************************
;
;							32 bit unsigned divide
;
;			Divide TOS by TOS+1, result in TOS, modulus in TOS+2
;
; *****************************************************************************

MInt32UDivide:
		;
		;		TOS = Q TOS+1 = M TOS+2 = A
		;
		lda 	esInt0+1,x 					; check for division by zero
		ora 	esInt1+1,x
		ora 	esInt1+2,x
		ora 	esInt1+3,x
		beq 	_MInt32DZero
		inx 								; clear A
		inx
		jsr 	MInt32False
		dex
		dex
		tya 								; save Y on the stack
		pha		
		ldy 	#32 						; number of division passes
_MInt32UDLoop:
		asl 	esInt0,x					; shift QA left. First Q
		rol 	esInt1,x
		rol 	esInt2,x
		rol 	esInt3,x		
		rol 	esInt0+2,x 					; then A.
		rol 	esInt1+2,x
		rol 	esInt2+2,x
		rol 	esInt3+2,x
		;
		sec 								; calculate A-M saving result on the stack
		lda 	esInt0+2,x
		sbc 	esInt0+1,x
		pha
		lda 	esInt1+2,x
		sbc 	esInt1+1,x
		pha
		lda 	esInt2+2,x
		sbc 	esInt2+1,x
		pha
		lda 	esInt3+2,x
		sbc 	esInt3+1,x
		bcc		_MInt32NoSubtract 			; if A < M (e.g. carry clear) then reject this.
		;
		sta 	esInt3+2,x 					; write result back to A
		pla 				
		sta 	esInt2+2,x
		pla 				
		sta 	esInt1+2,x
		pla 				
		sta 	esInt0+2,x
		;
		inc 	esInt0,x 					; sets bit 0 of Q - it was shifted left previously.
		jmp 	_MInt32Next 					; do the next iteration
		;
_MInt32NoSubtract:							; A < M so throw away the subtraction
		pla
		pla
		pla
		;
_MInt32Next:
		dey 								; do this 32 times.
		bne 	_MInt32UDLoop
		pla 								; restore Y and exit
		tay
		rts

_MInt32DZero:
		Error 	DivZero
		
; *****************************************************************************
;
;					32 bit modulus of unsigned divide
;
; *****************************************************************************

MInt32Modulus:
		jsr 	MInt32UDivide 				; do the division.
		;
		lda 	esInt3+2,x 					; copy 2nd on stack (the remainder) to the top.
		sta 	esInt3,x		
		lda 	esInt2+2,x
		sta 	esInt2,x		
		lda 	esInt1+2,x
		sta 	esInt1,x		
		lda 	esInt0+2,x
		sta 	esInt0,x		
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
		