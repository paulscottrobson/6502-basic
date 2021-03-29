; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		spritemove.asm
;		Purpose:	Move Physical Sprite
;		Created:	25th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;					Move current sprite to be centered on esInt0,x esInt1,x
;
; ************************************************************************************************

SpriteMove:
		.pshy
		lda 	#7 									; point to height/width byte and read it.
		jsr 	SpriteSetTarget
		lda 	$9F23
		lsr 	a 									; A now contains bits 0-1 (width) 2-3 (height)
		lsr 	a
		lsr 	a
		lsr 	a
		sta 	temp0 								; save these bits so we can work out the centre.
		lda 	#2 									; point to X position.Low
		jsr 	SpriteSetTarget
		jsr 	SMWritePosition 					; write X position out.
		lsr 	temp0 								; shift height bits into 0,1
		lsr 	temp0
		inx 										; get the y position
		jsr 	SMWritePosition 					; and write that out.
		dex 										; fix X and quit.
		.puly
		rts

; ************************************************************************************************
;
;		Position is at esInt0,x esInt1,x
;		VRAM pointer points to low byte
;		temp0:0,1 are the size of this sprite in the current axis
;		On exit points to next coordinate pair.
;
; ************************************************************************************************

SMWritePosition:
		lda 	temp0 								; get dim size
		and 	#3 									; in range into Y
		tay
		sec
		lda 	esInt0,x
		sbc 	SMHalfSize,y
		sta 	$9F23
		inc 	$9F20
		lda 	esInt1,x
		sbc 	#0
		sta 	$9F23
		inc 	$9F20
		rts

SMHalfSize:
		.byte 	4,8,16,32 							; half size each dimension.

; ************************************************************************************************
;
;		Read position into esInt0,x esInt1,x. Currently selected sprite. 
;		CS : Read X (CC) Y (CS)
;
; ************************************************************************************************

SpriteReadCoordinate:
		.pshy
		php 										; save CTR on stack
		lda 	#7 									; point to height/width byte and read it.
		jsr 	SpriteSetTarget
		lda 	$9F23
		lsr 	a 									; A now contains bits 0-1 (width) 2-3 (height)
		lsr 	a
		lsr 	a
		lsr 	a
		plp 										; restore CTS
		php
		bcc 	_SPRCNotY1 							; if it is Y, e.g. CS, shift twice more.
		lsr 	a
		lsr 	a
_SPRCNotY1:		
		and 	#3 									; point into half width/height 
		tay
		;
		plp 										; CS Y CC X
		lda 	#0 									; A = 0 X A = 2 Y
		rol 	a
		rol 	a
		adc 	#2 									; A = 2 X A = 4 Y
		jsr 	SpriteSetTarget 					; set data pointer offset by that
		;
		clc 										; read and unfix centre.
		lda 	$9F23
		adc 	SMHalfSize,y
		sta 	esInt0,x
		inc 	$9F20 								; do MSB
		lda 	$9F23
		adc 	#0
		sta 	esInt1,x
		.puly 										; restore Y and exit
		rts

		.send code