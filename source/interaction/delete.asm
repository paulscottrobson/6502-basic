; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		delete.asm
;		Purpose:	Delete line esInt0,esInt1
;		Created:	10th March 2021
;		Reviewed: 	16th March 2021
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
		;
_DLLoop:ldy 	#1 							; see if found line ?
		lda 	esInt0 						; e.g. the linenumbers match
		cmp 	(temp0),y
		bne 	_DLNext
		iny
		lda 	esInt1
		cmp 	(temp0),y
		beq 	_DLFound
_DLNext:jsr 	IAdvanceTemp0 				; shift temp0 forward, return Z flag set if end.
		bne 	_DLLoop
		rts
		;
		;	 	Found line, chop it out.		
		;
_DLFound:
		ldy 	#0 							; this is the line to cut, so this offset is the bytes to remove
		lda 	(temp0),y
		tay 								; so we copy from (temp0),y
		ldx 	#0  						; to (temp0,x)
_DLCopyDown:
		lda 	(temp0),y 					; copy one byte.
		sta 	(temp0,x)
		inc 	temp0 						; advance pointer
		bne 	_DLNoCarry
		inc 	temp0+1
_DLNoCarry:
		lda 	temp0 						; until hit low memory
		cmp 	lowMemory 					; which is comfortably after End Program.
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
		ldy 	#0 							; get offset
		lda 	(temp0),y 					; add to temp0
		adc 	temp0
		sta 	temp0
		bcc 	_IATNoCarry
		inc 	temp0+1
_IATNoCarry:
		lda 	(temp0),y
		ldy 	tempShort
		cmp		#0 							; Z set if program end.
		rts		

		.send 	code
		