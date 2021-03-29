; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		collide.asm
;		Purpose:	Collision Detection
;		Created:	29th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

hitSprite1:									; the two sprites being checked. theoretically
		.fill 	1 							; this won't work ... if you nest HIT() which
hitSprite2: 								; makes no sense
		.fill 	1
hitRange: 									; hit range if specified, 0 otherwise
		.fill 	1
		.send storage

		.section code	

; ************************************************************************************************
;
;										HIT(s1,s2<,range>)
;
; ************************************************************************************************

FunctionCollide: 	;; [hit(]
		pha 								; save and put index into X		
		tax
		lda 	#0 							; set hit range to default.
		sta 	hitRange
		;
		jsr 	_FCGetSpriteID
		sta 	hitSprite1
		.pshx 								; check comma.
		.main_checkcomma
		.pulx
		jsr 	_FCGetSpriteID
		sta 	hitSprite2
		;
		lda 	(codePtr),y 				; is there a third parameter
		cmp 	#TKW_RPAREN
		beq 	_FCParam2
		;
		.pshx 								; if so check comma, get it , this is the range.
		.main_checkcomma
		pla
		.main_evaluatesmall
		tax
		lda 	esInt0,x
		sta 	hitRange
_FCParam2:
		.main_checkrightparen 				; check the right parenthesis.		
		pla 								; set X to point to the stack again.
		pha
		tax		
		.pshy 								; save Y

		clc 								; do it with the horizontal values.
		jsr 	_FCCheck
		bcc 	_FCFail
		sec 								; do it with the vertical values.
		jsr 	_FCCheck
		bcc 	_FCFail
		lda 	#255 						; pass, return -1
		bne 	_FCReturnA

_FCFail:
		lda 	#0 							; return 0, it didn't work.
_FCReturnA:
		sta 	tempShort 					; put result in tempShort
		.puly 								; restore Y
		pla 								; restore stack, return result and exit.
		tax 
		lda 	tempShort
		sta 	esInt0,x
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		rts

; ************************************************************************************************
;
;		Do a check on horizontal/X (carry clear) vertical/Y (carry set)
;		Return CS if in range.
;
; ************************************************************************************************

_FCCheck:
		php 								; save the H/V flag twice
		php
		;
		lda 	hitSprite1 					; select sprite 1 and read its location 
		jsr 	SelectSpriteA 				; into X
		plp 		
		jsr 	SpriteReadCoordinate
		;
		lda 	hitSprite2					; now repeat for sprite 2 and location X+1
		jsr 	SelectSpriteA
		inx
		plp
		jsr 	SpriteReadCoordinate
		dex
		;
		sec 								; calculate |s1.c-s2.c| put in temp0
		lda 	esInt0,x
		sbc 	esInt0+1,x
		sta 	temp0
		lda 	esInt1,x
		sbc 	esInt1+1,x
		sta 	temp0+1
		bpl 	_FCCIsPositive
		sec 								; if -ve calculate |difference|
		lda 	#0
		sbc 	temp0
		sta 	temp0
		lda 	#0
		sbc 	temp0+1
		sta 	temp0+1
		;		
_FCCIsPositive:
		lda 	temp0+1 					; if range >= 256 then definitely fail.
		bne 	_FCCFail

		clc 								; work out required min distance which is 
		lda 	esInt3,x 					; the sum of the half width/heights
		adc 	esInt3+1,x
		;
		ldy 	hitRange 					; get the hit range
		beq 	_FCCNoSetRange 				; override if non zero.
		tya
_FCCNoSetRange:		 	
		cmp 	temp0 						; result is range > distance
		beq 	_FCCFail
		rts

_FCCFail:
		clc
		rts

;
;		Get one sprite ID.
;
_FCGetSpriteID:
		txa
		.main_evaluatesmall
		tax
		lda 	esInt0,x
		bmi 	_FCGSValue
		rts
_FCGSValue:
		.throw 	BadValue		

		.send code