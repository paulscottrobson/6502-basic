; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		concat.asm
;		Purpose:	String concatenation
;		Created:	22nd February 2021
;		Reviewed: 	8th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;					Join top two strings on stack in soft string memory
;
; ************************************************************************************************

StringConcat:	;; <concat>
		tax									; stack pos in X
		.pshy 								; save Y on stack.
		jsr 	CopyStringPair 				; temp0 and temp1 point to strings to concat.
		;
		sec 								; calculate alloc strings. lengths added + 1 for size.
		ldy 	#0
		lda 	(temp0),y
		adc 	(temp1),y
		bcs 	_SCError 					; just too many characters here.
		cmp 	#MaxStringSize
		bcs 	_SCError
		
		jsr 	AllocateSoftString 			; allocate soft string memory, set pointer.
		jsr 	CopySoftToStack 			; copy that to the stack.
		jsr 	SCCopyTemp0 				; copy temp0
		lda 	temp1 						; copy temp1 to temp0
		sta 	temp0
		lda 	temp1+1
		sta 	temp0+1
		jsr 	SCCopyTemp0 				; copy temp0 e.g. what was temp1.

		.puly 								; restore Y
		txa 								; and A
		rts

_SCError:
		.throw 	StrLen		

;
;		Copy string at temp0 to current soft string
;
SCCopyTemp0:
		ldy 	#0 							; put count in temp2
		lda 	(temp0),y
		sta 	temp2
_SCCopyLoop:
		lda 	temp2 						; done the lot		
		beq 	_SCCopyExit
		dec 	temp2
		iny 								; get next char
		lda 	(temp0),y
		jsr 	WriteSoftString 			; write to soft string.
		jmp 	_SCCopyLoop
_SCCopyExit:
		rts
;
;		Copy soft mem pointer to stack.
;
CopySoftToStack:
		lda 	SoftMemAlloc 				; copy the memory allocation pointer to the stack.
		sta 	esInt0,x 					; type is already string.
		lda 	SoftMemAlloc+1
		sta 	esInt1,x
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
				