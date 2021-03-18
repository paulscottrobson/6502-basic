; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		extensionhandler.asm
;		Purpose:	Handles extension calls.
;		Created:	21st February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

ExtensionHandler:
		cmp 	#$FE 						; check for force mode 0
		beq 	_ExtensionForce
		cmp 	#$FF						; A = $FF command, otherwise unary function stack level.
		bne 	_ExtensionUnary 			; is passed in A.
		lda 	(codePtr),y 				; so this is a command, using Group 2.
		iny
		asl 	a
		tax
		jmp 	(Group2Vectors-12,x)

_ExtensionUnary:
		pha 								; save stack pos in A
		lda 	(codePtr),y 				; get shifted token, double into X
		iny
		asl 	a
		tax
		pla 								; restore stack pos and call group3 command.
		jmp 	(Group3Vectors-12,X)

_ExtensionForce:
		jmp 	ForceMode0

		;
		;		Vectors for system specific commands
		;
		.include "../generated/tokenvectors2.inc"
		;
		;		Vectors for rare and system specific unary functions.
		;
		.include "../generated/tokenvectors3.inc"

; ************************************************************************************************
;
;									Link functions
;
; ************************************************************************************************

XEvaluateInteger: 							; we'll probably use this a lot.....
		txa
		.main_evaluateInt
		tax
		rts

		.send code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
