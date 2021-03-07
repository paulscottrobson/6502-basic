; *****************************************************************************
; *****************************************************************************
;
;		Name:		stack.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Stack manager
;
; *****************************************************************************
; *****************************************************************************

		.section zeropage
rsPointer: 									; return stack pointer, works down so always points
		.fill 	2							; to TOS, which is the current top-token.
		.send zeropage

		.section code	

; *****************************************************************************
;
;						Reset the return stack
;
; *****************************************************************************

RSReset:
		set16 	rsPointer,returnStack+retStackSize-1
		lda 	#$FF 						; put a duff marker on TOS, so nothing will pop
		sta 	returnStack+retStackSize-1
		rts

; *****************************************************************************
;
;				Claim X bytes off return stack, set marker to 'A'
;
; *****************************************************************************

RSClaim:
		sty 	tempShort 					; preserve Y
		pha 								; save marker on stack.

		txa 								; get bytes required.
		sec
		eor 	#$FF 						; add to rsPointer using 2's complement.
		adc 	rsPointer
		sta 	rsPointer
		lda 	rsPointer+1
		adc 	#$FF
		sta 	rsPointer+1
		;
		cmp 	#returnStack>>8 			; overflow. underflow actually :)
		bcc 	_RSCOverflow
		;
		pla 								; get marker back
		ldy 	#0 							; write marker out.
		sta 	(rsPointer),y
		ldy 	tempShort 					; restore Y and exit
		rts

_RSCOverflow:
		error 	RetStack
		
; *****************************************************************************
;
;						Free A bytes off returns stack
;
; *****************************************************************************

RSFree:
		clc
		adc 	rsPointer
		sta 	rsPointer
		bcc 	_RSFExit
		inc 	rsPointer+1
_RSFExit:
		rts

; *****************************************************************************
;
;				  Write position at offset A on the return stack.
;
; *****************************************************************************

RSSavePosition:
		sty 	tempShort 					; save Y position
		tay 								; this is where we write it.
		lda 	codePtr 					; write codePointer out
		sta 	(rsPointer),y
		iny
		lda 	codePtr+1
		sta 	(rsPointer),y
		iny
		lda 	tempShort 					; write the Y position out.
		sta 	(rsPointer),y
		tay 								; fix Y back again to original value
		rts

; *****************************************************************************
;
;				  Read position at offset A on the return stack.
;
; *****************************************************************************

RSLoadPosition:
		tay
		lda 	(rsPointer),y 				; read codePointer back
		sta 	codePtr
		iny
		lda 	(rsPointer),y
		sta 	codePtr+1
		iny
		lda 	(rsPointer),y 				; and the offset
		tay 								; to Y
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
		