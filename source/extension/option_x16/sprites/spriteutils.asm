; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		spriteutils.asm
;		Purpose:	Sprite Information Functions
;		Created:	29th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;							Sprite positions sprite.x(n) sprite.y(n)
;
; ************************************************************************************************

Sprite_GetX:	;; [sprite.x(]
		clc
		bcc 	SpriteGetCode
Sprite_GetY:	;; [sprite.y(]		
		sec
SpriteGetCode:
		php 								; CLC : X SEC: Y, save on stack.
		pha 								; save stack position
		jsr 	GetSpriteNumber 			; get # of sprite.
		.main_checkrightparen 				; check right bracket
		.pulx 								; get X back
		lda 	#0 							; zero upper 2 bytes
		sta 	esInt2,x
		sta 	esInt3,x
		plp 								; which one ?
		jsr 	SpriteReadCoordinate 		; read appropriate coordinate into esInt0,x
		txa 								; return NSP in A
		rts

; ************************************************************************************************
;
;		Get Sprite Number and make that sprite current.
;
; ************************************************************************************************

GetSpriteNumber:
		pha
		.main_evaluatesmall 				; get address.
		.pulx 					
		lda 	esInt0,x
		jsr 	SelectSpriteA
		rts

		.send 	code
