; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		clock.asm
;		Purpose:	RTC Reading Code
;		Created:	30th March 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;								clock(n) n = 0-5, clock part
;
; ************************************************************************************************

Unary_Clock:	;; [clock(]
		.main_evaluatesmall					; get clock element
		pha 								; save stack pos
		.main_checkrightparen
		.pshy								; call RTC preserving Y.
		jsr 	X16KReadRTC
		.puly
		pla 								; restore, repush, put into X to read offset
		pha
		tax
		lda 	esInt0,x 					; must be 0-5
		cmp 	#6		
		bcs 	_UCValue
		tax 								; index in X and read RTC.
		lda 	2,x
		sta 	tempshort
		pla 								; restore number stack index.
		tax 
		lda 	tempShort
		sta 	esInt0,x 					; rest are set up.
		txa
		rts

_UCValue:
		.throw 	BadValue

		.send 	code
		