; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		setcase.asm
;		Purpose:	Upper$/Lower$ functions
;		Created:	6th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;					Convert string on stack to U/C (Y=0) L/C (Y=1)
;
; ************************************************************************************************

CaseString: ;; <setcase>
		pha 								; save A and copy to X
		tax
		.pshy 								; save Y on stack.
		jsr 	TOSToTemp0 					; target string -> temp0
		ldy 	#0
		lda 	(temp0),y  					; get length,
		clc
		adc 	#1 							; one more for length byte
		jsr 	AllocateSoftString 			; allocate soft string memory, set pointer.
		jsr 	CopySoftToStack 			; copy that to the stack.
		ldy 	#0
		lda 	(temp0),y 					; count to copy in X
		tax
_CSCopy:
		cpx 	#0
		beq 	_CSExit
		dex
		iny 	
		pla 								; check direction		
		pha
		beq 	_CSUpper
		lda 	(temp0),y 					; lower$() code
		cmp 	#"A"
		bcc 	_CSWrite
		cmp 	#"Z"+1
		bcs 	_CSWrite
		bcc 	_CSFlipWrite

_CSUpper:		
		lda 	(temp0),y 					; upper$() code
		cmp 	#"a"
		bcc 	_CSWrite
		cmp 	#"z"+1
		bcs 	_CSWrite
_CSFlipWrite:
		eor 	#"A"^"a"
_CSWrite:		
		jsr 	WriteSoftString
		jmp 	_CSCopy


_CSExit:
		.puly 								; restore YA.
		pla
		rts

		.send 	code