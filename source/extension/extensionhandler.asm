; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		extensionhandler.asm
;		Purpose:	Handles extension calls.
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

ExtensionHandler:
		cmp 	#$FF						; A = $FF command, otherwise unary function stack level.
		bne 	_ExtensionUnary
		lda 	(codePtr),y
		iny
		asl 	a
		tax
		jmp 	(Group2Vectors-12,X)

_ExtensionUnary:
		pha 								; save stack pos in A
		lda 	(codePtr),y 				; get shifted token
		iny
		asl 	a
		tax
		pla
		jmp 	(Group3Vectors-12,X)

		.include "../generated/tokenvectors2.inc"
		.include "../generated/tokenvectors3.inc"

; ************************************************************************************************
;
;									Link functions
;
; ************************************************************************************************

XEvaluateInteger:
		txa
		.main_evaluateInt
		tax
		rts

		.send code
