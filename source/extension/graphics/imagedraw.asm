; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		imagedraw.asm
;		Purpose:	Drawing Utilities for images and bitmaps
;		Created:	4th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;											Test Image
;
; ************************************************************************************************

TestImageAccess:
		cpx 	#255 						; get information
		beq 	_TIAGetInfo
		txa 								; fake up a pattern using the X/Y coordinates.
		lsr 	a
		lsr 	a
		sta 	tempShort
		tya
		lsr 	a
		lsr 	a
		clc
		adc 	tempShort
		rts
;
_TIAGetInfo:
		lda 	#1 							; image (1) bitmap (0)
		ldx 	#16 						; pixel width
		ldy 	#32							; pixel height
		rts

		.send 	code
				