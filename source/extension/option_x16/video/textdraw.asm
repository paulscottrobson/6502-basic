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

Command_Draw: 	;; [draw] 
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
		lda 	gdText+1 					; do we have a string
		bne 	_THHasString

_THCallRenderer:		
		.pshx 								; save X register and y position
		lda 	gy2
		pha
		lda 	gy2+1
		pha
		;
		lda 	#BitmapTextAccess & $FF 	; render current image (gdImage)
		ldx 	#BitmapTextAccess >> 8
		jsr 	ImageRenderer
		;
		pla 								; restore y position and x register
		sta 	gy2+1
		pla
		sta 	gy2
		.pulx
		rts
		;
		;		Handle string.
		;
_THHasString:
		ldx 	#0 							; position in string
_THStringLoop:
		lda 	gdText 						; text => temp0
		sta 	temp0
		lda 	gdText+1
		sta 	temp0+1		
		;
		txa 								; length = string length.
		ldy 	#0 					
		cmp 	(temp0),y
		beq 	_THExit 					; if so exit.
		;
		inx 								; next character, put in Y
		txa
		tay
		lda 	(temp0),y 					; char to print, override image
		sta 	gdImage
		jsr 	_THCallRenderer 			; render the text
		;
		lda 	gdSize	 					; get size, need to x by 8 as 8x8 font.
		asl		a
		asl 	a
		asl 	a
		clc
		adc 	gX2 						; add to horizontal position
		sta 	gx2
		bcc 	_THStringLoop
		inc 	gx2+1
		jmp 	_THStringLoop 				; do the whole lot.

_THExit:		
		rts


; ************************************************************************************************
;
;									8x8 Bitmap Text Handler
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
		lda 	#0
		asl 	temp0	 					; x temp0:A x 8
		rol 	a
		asl 	temp0
		rol 	a
		asl 	temp0
		rol 	a
		ora 	#DefaultFont >> 8 			; A now points into font table.
		;
		inc 	X16VeraControl 				; alternate port set.
		sta 	X16VeraAddMed 				; set up address
		lda 	#$10 						
		sta 	X16VeraAddHigh
		sty 	tempShort
		lda 	temp0 						; or Y (vertical line) into temp0
		ora 	tempShort
		sta 	X16VeraAddLow 				; address set up.
		lda 	X16VeraData1 				; get bitmap
		dec 	X16VeraControl 				; original port set back
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
		rts
		.send 	code
