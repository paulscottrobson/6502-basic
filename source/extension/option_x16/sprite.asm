; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		sprite.asm
;		Purpose:	Sprite command.
;		Created:	18th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage 
currSprite:									; base address of selected sprite, MSB 0 if none.
		.fill 	2 
		.send storage

		.section code	

; ************************************************************************************************
;
;									Sprite Command
;
; ************************************************************************************************

CommandSprite:	;; [sprite]
		jsr 	CSCheckOnOff 				; look for TRUE/FALSE
		bne 	_CSCheckClear
		;
		lda 	$9F29 						; sprite enable is bit 6.
		and 	#$BF 						; clear it whatever
		bcc 	_CSNotOn 					; if CS turn on, so set it
		ora 	#$40
_CSNotOn:
		sta 	$9F29 						; write it back in new state and exit
		rts		

_CSCheckClear:
		lda 	#0 							; no sprite currently selected.
		sta 	currSprite+1
		lda 	(codePtr),y 				; check for CLEAR
		cmp 	#TKW_CLEAR
		bne 	_CSCommandLoop 				; not CLEAR, go to main loop
		jsr 	CSClearSprites 				; clear all the sprites
		iny 								; consume CLEAR token and exit.
		rts
		;
		;		Sprite command loop.
		;
_CSCommandLoop:
		jsr 	CSCheckOnOff 				; check sprite on/off
		beq 	_CSSetVisibility
		lda 	(codePtr),y 				; get and consume character
		cmp 	#TOK_EOL					; EOL exit.		
		beq 	_CSExit
		iny									; consume it
		cmp 	#TKW_COLON 					; colon exit
		beq 	_CSExit
		cmp 	#TKW_COMMA 					; semantic comma
		beq 	_CSCommandLoop
		cmp		#TKW_IMAGE 					; image ?
		beq 	_CSSetImage
		cmp 	#TKW_FLIP 					; flip ?
		beq 	_CSSetFlip
		cmp 	#TKW_TO 					; to ?
		beq 	_CSSetPos
		;
		;		Select a sprite
		;
		dey 								; unpick DEY
		lda 	#0 							; sprite # now at level 0
		.main_evaluatesmall					; now in esInt0. A = 0
		asl		esInt0 						; multiply A:esInt0 by 8
		bcs 	_CSBadValue 				; sprites only 0-127
		asl 	esInt0
		rol 	a
		asl 	esInt0
		rol 	a
		ora 	#$FC 						; MSB of address (barring $01 upper third byte)
		sta 	currSprite+1
		lda 	esInt0 						; LSB of address
		sta 	currSprite+0
		jmp 	_CSCommandLoop
_CSBadValue
		.throw	BadValue		
		;
		;		Exit
		;
_CSExit:		
		rts
		;
		;		Set visibility to On (CS) Off (CC)
		;
_CSSetVisibility:
		php 								; save carry
		lda 	#6 							; set pos to offset 6.
		jsr 	SpriteSetTarget
		;
		lda 	$9F23 						; read it.
		and 	#$F3 						; clear depth bits, disabling it.
		plp
		bcc 	_CSSetOff 					; check if carry was set
		ora 	#$0C 						; otherwise set depth bits to 11, on top.
_CSSetOff:
		sta 	$9F23 						; update and loop back
		jmp 	_CSCommandLoop
		;
		;		Flip
		;
_CSSetFlip:		
		lda 	#0 							; image # now at level 0
		.main_evaluatesmall					
		lda 	#6 							; set sprite position to +6
		jsr 	SpriteSetTarget
		lda 	esInt0 						; flip value & 3 => temp0
		and 	#3
		sta 	temp0
		lda 	$9F23 						; update the flip.
		and 	#$FC
		ora 	temp0
		sta 	$9F23
		jmp 	_CSCommandLoop
		;
		;		Set sprite position.
		;
_CSSetPos:
		lda 	#0 							; X now at level 0
		.main_evaluateint					
		.main_checkcomma
		lda 	#1 							; Y now at level 1
		.main_evaluateint
		ldx 	#0 							; coords at 0,1		
		jsr 	SpriteMove 					; move it.
		jmp 	_CSCommandLoop
		;
		;		Set Image #
		;
_CSSetImage:
		lda 	#0 							; image # now at level 0
		.main_evaluatesmall					
		lda 	#0 							; set sprite position to +0
		jsr 	SpriteSetTarget
		ldx 	esInt0 						; get image # into X
		lda 	imageAddr2Low,x 			; copy low address in.
		sta 	$9F23
		inc 	$9F20 						; bump to offset 1.
		;
		lda 	imageInfo,x 				; get 4/8 bit flag from info.
		and 	#$10
		asl 	a
		asl		a
		asl 	a 							; put into bit 7
		ora 	imageAddr2High,x 			; or high address with it.
		sta 	$9F23 						; write the high byte.

		lda 	#6
		jsr 	SpriteSetTarget 			; set sprite on.
		lda 	$9F23
		ora 	#$0C
		sta 	$9F23

		inc 	$9F20 						; point to byte 7 : height/width/palette offset
		lda 	imageInfo,x 				; get image info
		asl 	a 							; shift bits 0-3 to 4-7
		asl 	a
		asl 	a
		asl 	a
		bcs		_CSNoOffset 				; if bit 4 was set don't set the offset.
		ora 	#$0F 						; set palette offset and write back
_CSNoOffset:		
		sta 	$9F23
		jmp 	_CSCommandLoop

; ************************************************************************************************
;
;			Set R/W address to current sprite or A - no increment or decrement so can R/w
;
; ************************************************************************************************

SpriteSetTarget:
		ora 	currSprite
		sta 	$9F20
		lda 	currSprite+1
		beq 	_SSTNoSet
		sta 	$9F21
		lda 	#$01
		sta 	$9F22
		rts

_SSTNoSet:
		.throw 	NoSprite		

; ************************************************************************************************
;
;		Check for TRUE/FALSE, currently used for ON/OFF. If either returns EQ and
;		CS (true) CC (false), otherwise return NE
;
; ************************************************************************************************

CSCheckOnOff:
		lda 	(codePtr),y 				; get and consume it.
		iny
		cmp 	#TKW_FALSE					; return CC/EQ if FALSE
		clc 				
		beq 	_CSCOExit
		cmp 	#TKW_TRUE 					; return CS/EQ if TRUE
		sec 								; return NE if neither.
		beq 	_CSCOExit
		dey 								; undo consume
		cmp 	#TKW_TRUE 					; and set NE again, DEY will change it.
_CSCOExit:
		rts

; ************************************************************************************************
;
;									Clear all sprites
;
; ************************************************************************************************

CSClearSprites:
		lda 	#$11 						; set address to 1FC00 with single bump
		sta 	$9F22
		lda 	#$FC
		sta 	$9F21
		lda 	#0
		sta 	$9F20
_CSClear:
		lda 	#0 							; set everything to $00
		sta 	$9F23
		lda 	$9F21
		bne 	_CSClear
		rts
		
		.send code