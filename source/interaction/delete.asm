; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		delete.asm
;		Purpose:	Delete line esInt0,esInt1
;		Created:	10th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;							Delete line esInt0/1 from program
;
; ************************************************************************************************

DeleteLine:
		;
		;		Find line to delete.
		;
		lda 	basePage 					; copy program base to temp0
		sta 	temp0
		lda 	basePage+1
		sta 	temp0+1
_DLLoop:ldy 	#1 							; see if found line ?
		lda 	esInt0
		cmp 	(temp0),y
		bne 	_DLNext
		iny
		lda 	esInt1
		cmp 	(temp0),y
		beq 	_DLFound
_DLNext:jsr 	IAdvanceTemp0 				; shift temp0 forward, return Z flag set if end.
		bne 	_DLLoop
		ldy 	#0 							; size of chunk to cut out.
		lda 	(temp0),y
		rts
		;
		;	 	Found line, chop it out.		
		;
_DLFound:
		ldy 	#0 							; from here (temp0),y
		lda 	(temp0),y
		tay
		ldx 	#0  						; to (temp0,x)
_DLCopyDown:
		lda 	(temp0),y
		sta 	(temp0,x)
		inc 	temp0 						; advance pointer
		bne 	_DLNoCarry
		inc 	temp0+1
_DLNoCarry:
		lda 	temp0 						; until hit low memory
		cmp 	lowMemory
		bne 	_DLCopyDown
		lda 	temp0+1
		cmp 	lowMemory+1
		bne 	_DLCopyDown
		rts

; ************************************************************************************************
;
;					Advance temp0 one program step, Z flag set if end.
;
; ************************************************************************************************

IAdvanceTemp0:
		sty 	tempShort
		clc
		ldy 	#0
		lda 	(temp0),y
		adc 	temp0
		sta 	temp0
		bcc 	_IATNoCarry
		inc 	temp0+1
_IATNoCarry:
		lda 	(temp0),y
		ldy 	tempShort
		cmp		#0
		rts		

		.send 	code

		