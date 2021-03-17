; *****************************************************************************
; *****************************************************************************
;
;		Name:		for.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		1st March 2021
;		Reviewed: 	8th March 2021
;		Purpose:	For/Next
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;								For/Next usage.
; *****************************************************************************
;
;		+7..+10	 	Terminal value
;		+6			Step (-128..127 maximum)
;		+4..+5 		Address of index.
;		+1..+3 		Loop position (end of the command)
;		+0			Marker (consumes 11 bytes)
;
; *****************************************************************************

		.section 	code

; *****************************************************************************
;
;								FOR Command
;
; *****************************************************************************

Command_FOR:		;; [for]
		lda 	#markerFOR 					; allocate the space and set the marker
		ldx 	#11
		jsr 	RSClaim
		jsr 	CommandLET 					; do the same as LET FOR [a = 4]
		;
		lda 	esType 						; check type should be integer reference.
		cmp 	#$80 						; we do not do FOR floats.
		bne 	_CFType
		;
		lda 	#TKW_TO 					; check TO present.
		jsr 	CheckToken
		;
		ldx 	#1 							; keep the variable address in stack 0
		jsr 	EvaluateInteger				; get terminal value in stack 1
		;
		;		Set up the FOR stack frame.
		;
		.pshy 								; copy things into the area with the default STEP
		ldy 	#4
		lda		esInt0 						; copy the address of the index variable into 4 and 5
		sta 	(rsPointer),y
		iny
		lda		esInt1
		sta 	(rsPointer),y
		iny
		;
		lda 	#1  						; the default step in 6, (-128 .. 127 only)
		sta 	(rsPointer),y
		iny
		;
		lda		esInt0+1 					; terminal value in 7 to 11.
		sta 	(rsPointer),y
		iny
		lda		esInt1+1 					
		sta 	(rsPointer),y
		iny
		lda		esInt2+1 					
		sta 	(rsPointer),y
		iny
		lda		esInt3+1 					
		sta 	(rsPointer),y
		.puly
		;
		;		Check for STEP
		;
		lda 	(codePtr),y 				; followed by STEP.
		cmp 	#TKW_STEP
		bne 	_CFDone
		;
		;		Calculate STEP
		;
		iny									; skip over step.
		jsr 	EvaluateInteger 			; get step
		.pshy
		lda 	esInt0,x 					; copy it into step (bit lazy here)
		ldy 	#6
		sta 	(rsPointer),y
		.puly
_CFDone:
		lda 	#1
		jsr 	RSSavePosition 				; save position.
		rts

_CFType:
		.throw	BadType

; *****************************************************************************
;
;								NEXT Command
;
; *****************************************************************************

Command_NEXT:		;; [next]
		rscheck markerFOR,nextErr 			; check TOS is a FOR

		lda 	(codePtr),y 				; is it NEXT <index>
		cmp 	#$40 						; e.g. a variable follows 00-3F
		bcs 	_CNNoIndex

		;
		;		Check NEXT <something> is right.
		;
		ldx 	#0 							; start on stack
		jsr 	EvaluateReference 			; this is the variable/parameter to localise.
		;
		.pshy
		ldy 	#4 							; check same variable as that stored at +4,+5
		lda 	(rsPointer),y
		cmp 	esInt0,x
		bne 	_CNBadIndex
		iny
		lda 	(rsPointer),y
		cmp 	esInt1,x
		bne 	_CNBadIndex
		.puly
		;
		;		Main NEXT code.
		;
_CNNoIndex:		
		.pshy 								; don't need this for the rest of the instruction.
		;
		;		Adjust the variable by the STEP
		;
		ldy 	#4 							; make temp0 point to the index
		lda 	(rsPointer),y
		sta 	temp0
		iny
		lda 	(rsPointer),y
		sta 	temp0+1
		;
		iny
		ldx 	#0 							; X is the sign extend part of the step.
		lda 	(rsPointer),y 				; get the step.
		sta 	temp2+1 					; save for later.
		bpl 	_CNSignX
		dex  								; X = $FF		
_CNSignX:
		clc 								; add to the LSB
		ldy 	#0
		adc 	(temp0),y
		sta 	(temp0),y
_CNPropogate:
		iny  								; add the sign extended in X to the rest.
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		iny  								
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		iny  							
		txa
		adc 	(temp0),y
		sta 	(temp0),y
		;
		;		Do the terminal value check.
		;
		clc 								; point temp1 to the terminal value stored in the stack.
		lda 	rsPointer 
		adc 	#7
		sta 	temp1
		lda 	#0
		sta 	temp2 						; clear temp2, which is the OR of all the subtractions.
		tay 								; and clear the Y register again.
		adc 	rsPointer+1
		sta 	temp1+1
		;
		sec 								; calculate current - limit oring interim values.
		jsr 	_CNCompare 					; each of these does a byte.
		jsr 	_CNCompare 					; we calculate the OR of all these subtractions.
		jsr 	_CNCompare 					; and the carry of the subtraction.
		jsr 	_CNCompare
		;
		;		At this point temp2 zero if the same, and CS if current >= limit.
		;
		bvc 	_CNNoOverflow 				; converts to a signed comparison on the sign bit.
		eor 	#$80
_CNNoOverflow:		
		ldy 	temp2+1						; get step back
		bmi 	_CNCheckDownto
		;
		;		Test for positive steps
		;
		cmp 	#0
		bmi 	_CNLoopRound 				; loop round if < = 
		lda 	temp2
		beq 	_CNLoopRound
		;
		;		Exit the loop as complete
		;
_CNLoopExit:
		.puly		
		lda 	#11
		jsr 	RSFree
		rts
		;
		;		Loop back 
		;		
_CNLoopRound:
		.puly		
		lda 	#1
		jsr 	RSLoadPosition				; go back to the loop top
		rts			

_CNBadIndex:
		.throw 	BadIndex

		;
		;		Test for negative steps
		;
_CNCheckDownto:
		cmp 	#0
		bpl 	_CNLoopRound
		jmp 	_CNLoopExit

_CNCompare:
		lda 	(temp0),y 					; do the subtraction - compare don't care about answer
		sbc 	(temp1),y
		ora 	temp2 						; Or into temp2 (does not affect carry)
		sta 	temp2
		iny
		rts

		.send 	code

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
