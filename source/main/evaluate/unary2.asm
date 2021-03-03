; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		unary2.asm
;		Purpose:	More Unary Routines
;		Created:	2nd March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;							Read the timer , which is 16 bit
;
; ************************************************************************************************

UnaryTimer:		;; [timer(]
		jsr 	CheckRightParen
		pshy
		jsr 	MInt32Zero 					; zero result
		stx 	temp0 						; returning in YA so can't use pshx
		device_timer()						; get clock.
		ldx 	temp0						; restore X and update 16 bit result
		sta 	esInt0,x
		tya
		sta 	esInt1,x
		puly
		rts

; ************************************************************************************************
;
;						Inkey() - read key if any pressed, 0 otherwise
;
; ************************************************************************************************

UnaryInkey:		;; [inkey(]
		jsr 	CheckRightParen
		stx 	temp0
		device_inkey()
		ldx 	temp0
		jsr 	MInt32Set8Bit
		rts

; ************************************************************************************************
;
;								Get() - get next key pressed
;
; ************************************************************************************************

UnaryGet:		;; [get(]
		jsr 	CheckRightParen
		stx 	temp0
_UGLoop:		
		device_inkey()
		cmp 	#0
		beq 	_UGLoop
		ldx 	temp0
		jsr 	MInt32Set8Bit
		rts

; ************************************************************************************************
;
;								Sys() - call/return 6502 code
;
; ************************************************************************************************

UnarySys: 		;; [sys(]
		jsr 	EvaluateInteger 				; get the address
		jsr 	CheckRightParen
		jsr 	TOSToTemp0 						; copy to temp0
		pshx 									; save XY
		pshy
		;
		lda 	("A"-"A")*4+SingleLetterVar 	; load AXY
		ldx 	("X"-"A")*4+SingleLetterVar
		ldy 	("Y"-"A")*4+SingleLetterVar
		jsr 	_CallTemp0
		;
		sta 	tempShort 						; restore YX
		puly
		pulx
		lda 	tempShort
		jsr 	MInt32Set8Bit 					; return result.
		rts

_CallTemp0:
		jmp 	(temp0)

		.send 	code