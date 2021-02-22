; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		binary.asm
;		Purpose:	Binary Routines
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;								Macro to do binary operation
;
; ************************************************************************************************

binop 	.macro
		jsr 	BinaryProcess 				; check to see if either is float
		bcs 	_IsFPOperation 				; if so do the whole thing as float.
		jmp 	\1 							; else do it as integer.
_IsFPOperation:
		txa 								; call the relevant fp routine
		floatingpoint_\2
		tax
		rts
		.endm

; ************************************************************************************************
;
;		Handler for binary ops. Check they are numbers. If both ints, return CC.  If one is 
;		float, make both floats and return CS.
;	
; ************************************************************************************************

BinaryProcess:
		lda 	esType,x 					; or type bytes together and check bit 6.
		ora 	esType+1,x
		asl 	a		
		bmi 	_BPStringType 				; if one is set, then string type.
		;
		clc 								; return CC for integer
		and 	#$02 						; $02 because of ASL A.
		beq 	_BPExit 					; if both integer then return with CC.
		jsr 	_BPMakeFloat 				; one is a float, so we do both as floats.
		inx
		jsr 	_BPMakeFloat
		dex
		lda 	#$01 						; set result type to float
		sta 	esType,x
		sec 								; and return with carry set.
_BPExit:
		rts		

_BPMakeFloat:
		lda 	esType,x 					; get type bit.
		lsr 	a
		bcs 	_BPIsFloat
		txa
		floatingpoint_intTofloat 			; if int, convert to float
		tax
_BPIsFloat:
		rts
_BPStringType:
		error 	BadType

; ************************************************************************************************
;
;						Add is a special case because you can add strings
;
; ************************************************************************************************

AddHandler:	;; [+]
		jsr 	DereferenceTwo 				; dereference top two on stack.
		lda 	esType,x 					; check two strings.
		and 	esType+1,x
		and 	#$40 						; if both have bit 6 set ...
		bne 	_AHStringConcat				; concatenate strings.
		;
		binop 	MInt32Add,fadd
		;
		;		Two strings, so concatenate them.
		;
_AHStringConcat:
		txa
		string_concat
		tax
		rts

; ************************************************************************************************
;
;										All the others
;
; ************************************************************************************************

SubHandler:	;; [-]
		jsr 	DereferenceTwo 			
		binop 	MInt32Sub,fSubtract

MulHandler:	;; [*]
		jsr 	DereferenceTwo 			
		binop 	MInt32Multiply,fMultiply
		
DivHandler:	;; [/]
		jsr 	DereferenceTwo 			
		binop 	MInt32SDivide,fDivide

ModHandler:	;; [mod]
		jsr 	DereferenceTwo 			
		binop 	MInt32Modulus,fImpossible

XorHandler: ;; [xor]		
		jsr 	DereferenceTwo 			
		binop 	MInt32Xor,fImpossible

OrHandler: ;; [or]		
		jsr 	DereferenceTwo 			
		binop 	MInt32Or,fImpossible

AndHandler: ;; [and]		
		jsr 	DereferenceTwo 			
		binop 	MInt32And,fImpossible



