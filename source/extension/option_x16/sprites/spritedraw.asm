; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		spritedraw.asm
;		Purpose:	Drawing Utilities for sprites
;		Created:	3rd April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************

; ************************************************************************************************
;
;		This file is here because it's optional like sprites. No sprites, PAINT won't work.
;
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;									Draw Image (Sprite Graphic)
;
; ************************************************************************************************

Command_Paint: 	;; [paint]
		lda 	#ImageHandler & $FF
		ldx 	#ImageHandler >> 8
		jsr 	GHandler
		rts

; ************************************************************************************************
;
;									Handler to Image
;
; ************************************************************************************************

ImageHandler:
		lda 	#SpriteImageAccess & $FF
		ldx 	#SpriteImageAccess >> 8
		jmp 	ImageRenderer

; ************************************************************************************************
;
;									Sprite Image Handler
;
; ************************************************************************************************

SpriteImageAccess:
		cpx 	#255
		bne 	_SIAGetPixel
;
;		Get information on sprite. (X,Y) size A type image
;
		ldx 	gdImage 					; get the image #
		lda 	imageInfo,x 				; get the image information.
		pha
		and 	#3 							; LSB x 2 width
		tax
		lda 	_SIASizeTable,x
		tax
		pla 								; get back next 2 bits are height
		lsr 	a
		lsr 	a
		and 	#3
		tay
		lda 	_SIASizeTable,y
		tay
		lda 	#1 							; image is type 1, e.g. colour.
		rts

_SIASizeTable:
		.byte 	8,16,32,64 					; size of sprites from 2 bits,

;
;		Get pixel for (X,Y), 0 for transparent. 
;
_SIAGetPixel:
		sty 	temp0 						; this is the Y size 8,16,32,64 => temp0
		lda 	#0
		sta 	temp0+1
		stx 	temp1+1 					; save X into temp1+1
		;
		ldy 	gdImage 					; get image info into A
		lda 	imageInfo,y
		pha
		and 	#$10 						; save the 4 bit flag part in temp1
		sta 	temp1
		;
		pla 								; get width of sprite as 00-11 (8-64)
		and 	#3 							; we shift left +3 e.g. 2^(A+3)
		clc
		adc 	#3
		tay
		;
_SIAMultiply:
		asl 	temp0
		rol 	temp0+1
		dey
		bne 	_SIAMultiply		
		;
		txa 								; add X to it.
		clc
		adc 	temp0
		sta 	temp0
		bcc 	_SIANoCarry1
		inc 	temp0+1
_SIANoCarry1:
		;
		lda 	temp1 						; if the mode bit is 0 then halve this value
		bne 	_SIANoHalf 					; because we pack 2 pixels in every byte.
		lsr 	temp0+1
		ror 	temp0
_SIANoHalf:		
		;
		ldx 	gdImage 					; copy the image address / 32 into temp2/temp3
		lda 	imageAddr32Low,x
		sta 	temp2
		lda 	imageAddr32High,x
		sta 	temp2+1
		lda 	#0
		sta 	temp3
		ldx 	#5 							; multiply by 32 e.g. 2^5
_SIMult32:
		asl 	temp2
		rol 	temp2+1
		rol 	temp3
		dex
		bne 	_SIMult32

		inc 	$9F25 						; select alternate data port

		clc
		lda 	temp0 						; add offset to sprite address x 32 and write to address
		adc 	temp2
		sta 	$9F20
		lda 	temp0+1
		adc 	temp2+1
		sta 	$9F21
		lda 	#0
		adc 	temp3
		sta 	$9F22
		lda 	$9F24 						; read the sprite data port 1
		dec 	$9F25 						; select original data port.
		ldx 	temp1 						; is it 8 bit ? if so, then exit
		bne 	_SIExit

		lsr 	temp1+1 					; get even/odd X and shift A accordingly
		bcs 	_SIHalf
		lsr 	a
		lsr 	a
		lsr 	a
		lsr 	a
_SIHalf:
		and 	#15 						; if 0 (e.g. would paint 240, return 0 transparent)		
		beq 	_SIExit
		ora 	#$F0
_SIExit:		
		rts



		.send 	code
				