; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		poke.asm
;		Purpose:	Poke Doke and Loke.
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Remark command
;
; ************************************************************************************************

Command_Poke: 	;; [Poke]
		lda 	#1
		bne 	PokeGeneral
Command_Doke: 	;; [Doke]
		lda 	#2
		bne 	PokeGeneral
Command_Loke: 	;; [Loke]
		lda 	#3

PokeGeneral:	
		pha 								; save size
		jsr 	EvaluateRootInteger 		; target address
		jsr	 	CheckComma		
		inx
		jsr 	EvaluateInteger 			; what value to POKE ?
		dex
		jsr 	TOSToTemp0 					; temp0 points to the target address
		sty 	tempShort 					; save Y

		pla 								; get copy type and dispatch
		tax
		dex
		beq 	_Poke1
		dex
		beq 	_Poke2

		ldy 	#3
		lda 	esInt3+1
		sta 	(temp0),y
		dey
		lda 	esInt2+1
		sta 	(temp0),y
_Poke2:
		ldy 	#1
		lda 	esInt1+1
		sta 	(temp0),y
_Poke1:		
		ldy 	#0
		lda 	esInt0+1
		sta 	(temp0),y

		ldy 	tempShort 					; restore Y and exit
		rts

		.send code