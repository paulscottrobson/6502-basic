; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		textdraw.asm
;		Purpose:	Drawing Utilities for text
;		Created:	5th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
		
DefaultFont = $F800

		.section code	

; ************************************************************************************************
;
;									Draw Image (Sprite Graphic)
;
; ************************************************************************************************

Command_Text: 	;; [Text] 
		lda 	#TextHandler & $FF
		ldx 	#TextHandler >> 8
		jsr 	GHandler
		rts

; ************************************************************************************************
;
;									Handler to Image
;
; ************************************************************************************************

TextHandler:
		lda 	#BitmapTextAccess & $FF
		ldx 	#BitmapTextAccess >> 8
		jmp 	ImageRenderer

; ************************************************************************************************
;
;									Sprite Image Handler
;
; ************************************************************************************************

BitmapTextAccess:
		cpy 	#$FF 						; get information
		bne 	_BTABitmap
		lda 	#0 							; bitmap 8x8
		ldx 	#8
		ldy 	#8
		rts
;
;		Get bitmap data.
;
_BTABitmap:
		lda 	gdImage 					; Image => temp0:A
		jsr 	DrawCharacterA
		rts

; ************************************************************************************************
;
;						Draw A at current size, ink, paper and position.
;
; ************************************************************************************************

DrawCharacterA:
		sta 	temp0
		;
		lda 	gY2
		pha
		lda 	gY2+1
		pha
		;
		lda 	#0
		asl 	temp0	 					; x temp0:A x 8
		rol 	a
		asl 	temp0
		rol 	a
		asl 	temp0
		rol 	a
		ora 	#DefaultFont >> 8 			; A now points into font table.
		;
		inc 	$9F25 						; alternate port set.
		sta 	$9F21 						; set up address
		lda 	#$10 						
		sta 	$9F22
		sty 	tempShort
		lda 	temp0 						; or Y (vertical line) into temp0
		ora 	tempShort
		sta 	$9F20 						; address set up.
		lda 	$9F24 						; get bitmap
		dec 	$9F25 						; original port set back
		;
		ldx 	#7 							; index into rendercache
		sta 	temp0 						; bitmap in temp 0
_BTADoCache:
		lda 	#0
		lsr 	temp0
		bcc 	_BTANotSet
		lda 	#255
_BTANotSet:
		sta 	renderCache,x
		dex
		bpl 	_BTADoCache
		;
		pla
		sta 	gY2+1
		pla
		sta 	gY2
		rts
		.send 	code
