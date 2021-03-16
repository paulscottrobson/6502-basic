; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		insert.asm
;		Purpose:	Insert line number esint0/1, at (codePtr), length tokenBufferIndex
;		Created:	10th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;							Insert line esInt0/1 from program
;	Tokenised code is at (codePtr), length is in tokenBufferIndex (not including offset,line#)
;
; ************************************************************************************************

InsertLine:
		;
		;		Find insert point. which is first line# > insert line#. Cannot be equal
		; 		already would have been deleted.
		;
		lda 	basePage 					; copy program base to temp0
		sta 	temp0
		lda 	basePage+1
		sta 	temp0+1
_ILLoop:									; insert position is first line# > required
		ldy 	#1
		lda 	(temp0),y 					
		cmp 	esInt0
		iny
		lda 	(temp0),y
		sbc 	esInt1
		bcs 	_ILFound 					; we know it cannot be equal, it would have been deleted		
		jsr 	IAdvanceTemp0 				; shift temp0 forward, return Z flag set if end.
		bne 	_ILLoop
_ILFound:									; (temp0) points to the insert point.
		;
		;		Make space for new line.
		;
		lda 	lowMemory 					; shift lowMemory up to make space for it.
		sta 	temp1             			; this pointer goes backwards
		lda 	lowMemory+1
		sta 	temp1+1
		;
		lda 	tokenBufferIndex 			; space to make in Y, 0 in X.
		clc 								; add 3 for the line number and offset. 
		adc 	#3 							; tokenbuffer already has $80
		tay
		ldx 	#0 									
_ILMove:lda 	(temp1,x)					; shift up
		sta 	(temp1),y
		;
		lda 	temp1 						; check reached the insert point ?
		cmp 	temp0
		bne 	_ILMNext
		lda 	temp1+1
		cmp 	temp0+1
		beq 	_ILMCopy
		;
_ILMNext:									; decrement temp1 copying pointer if not
		lda 	temp1
		bne 	_ILNoBorrow
		dec 	temp1+1
_ILNoBorrow:	
		dec 	temp1
		jmp 	_ILMove 					; and go round again
		;
		;		Copy code into new line.
		;		
_ILMCopy:
		tya 								; Y is the offset of the new line.
		sta 	(temp0,x)					; X = 0 still.
		;
		ldy 	#1 							; copy in line number.
		lda 	esInt0		
		sta 	(temp0),y
		iny
		lda 	esInt1		
		sta 	(temp0),y
		;
		ldy 	#0 							; copy the body in
_ILMCopy2:
		lda 	(codePtr),y
		iny
		iny
		iny
		sta 	(temp0),y
		dey
		dey
		cpy 	tokenBufferIndex
		bne 	_ILMCopy2
		rts

		.send code
		