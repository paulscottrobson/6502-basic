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
		.debug
		lda 	(codePtr),y 				; get and consume character
		cmp 	#TOK_EOL					; EOL exit.		
		iny									; consume it
		cmp 	#TKW_COLON 					; colon exit
		beq 	_CSExit
		cmp 	#TKW_COMMA 					; semantic comma
		beq 	_CSCommandLoop
		;
		;
		;
		lda 	#0 							; sprite # now at level 0
		.main_evaluatesmall					; now in esInt0. A = 0

_CSExit:		
		rts

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