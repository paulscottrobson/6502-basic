; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		00start.asm
;		Purpose:	Start up code.
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code
Start:		
		set16 	codePtr,TestCode

		ldy 	#0
		lda 	#0
		ldx 	#0
		jsr 	EvaluateLevel
		jsr 	DeReferenceOne
		debug
halt:	jmp 	halt

Unimplemented:
		debug
		jmp 	Unimplemented
		
		.include "../generated/testcode.inc"

		.include "../generated/tokenvectors0.inc"
		.send code

