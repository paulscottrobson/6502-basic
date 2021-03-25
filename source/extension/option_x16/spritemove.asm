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
		jsr 	_SMWritePosition 					; write X position out.
		lsr 	temp0 								; shift height bits into 0,1
		lsr 	temp0
		inx 										; get the y position
		jsr 	_SMWritePosition 					; and write that out.
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

_SMWritePosition:
		lda 	temp0 								; get dim size
		and 	#3 									; in range into Y
		tay
		sec
		lda 	esInt0,x
		sbc 	_SMHalfSize,y
		sta 	$9F23
		inc 	$9F20
		lda 	esInt1,x
		sbc 	#0
		sta 	$9F23
		inc 	$9F20
		rts

_SMHalfSize:
		.byte 	4,8,16,32 							; half size each dimension.
		.send code