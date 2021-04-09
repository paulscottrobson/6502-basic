; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		sndunary.asm
;		Purpose:	Sound unary functions
;		Created:	9th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;									Playing(x) is sound playing ?
;
; ************************************************************************************************

Unary_Playing:		;; [playing(]
		pha 						; save stack position
		lda 	(codePtr),y 		; check for playing()
		cmp 	#TKW_RPAREN
		beq 	_UPCount
		pla 						; get SP back.
		pha
		.main_evaluatesmall 		; get address.
		.main_checkrightparen 		; check right bracket
		.pulx 						; get stack back in X.
		stx 	tempShort 			; save X
		lda 	esInt0,x 			; check level, must be < 16
		cmp 	#16
		bcs 	_UPValue
		tax 						; get the time
		lda 	ChannelTime,x 		; 0 if zero, 255 if non-zero.
		beq 	_UPZero
		lda 	#255
_UPZero:		
		ldx 	tempShort 			; stack pointer back
		sta 	esInt0,x 			; return value
_UPSet13:		
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		rts
_UPValue:
		.throw 	BadValue

_UPCount:
		iny 						; skip )
		.pulx 						; get stack back in X.
		lda 	LiveChannels
		sta 	esInt0,x
		lda 	#0
		beq 	_UPSet13

		.send 	code