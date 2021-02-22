; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		muldiv.asm
;		Purpose:	Multiply/Divide fp
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

FPMultiply:	;; <fMultiply>
		debug
		jmp 	FPMultiply

FPDivide:	;; <fDivide>
		debug
		jmp 	FPDivide

FPImpossible:		;; <fImpossible>
		error 	BadType 					; can't do FP modulus/and/or/xor. Makes no sense.
		