; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		binary.asm
;		Purpose:	Binary Routines
;		Created:	22nd February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;					Macro to do binary operation - float or int (not string)
;
; ************************************************************************************************

binop 	.macro
		jsr 	BinaryProcess 				; check to see if either is float
		bcs 	_IsFPOperation 				; if so do the whole thing as float.
		jmp 	\1 							; else do it as integer.
_IsFPOperation:
		txa 								; call the relevant fp routine
		.floatingpoint_\2
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
		ora 	esType+1,x 					; (the float bit)
		asl 	a		
		bmi 	_BPStringType 				; if bit 6 is set, then string type, error
		;
		clc 								; return CC for integer
		and 	#$02 						; $02 because of ASL A. check original bit 1.
		beq 	_BPExit 					; if both integer then return with CC.
		jsr 	BPMakeBothFloat 			; make both float
		lda 	#$01 						; set result type to float
		sta 	esType,x
		sec 								; and return with carry set.
_BPExit:
		rts		

_BPStringType:
		error 	BadType

; ************************************************************************************************
;
;						Make the top two or top one a floating point number
;
; ************************************************************************************************

BPMakeBothFloat:
		inx
		jsr 	BPMakeFloat 				; one is a float, so we do both as floats.
		dex
BPMakeFloat:
		lda 	esType,x 					; get type bit which is in bit 0
		lsr 	a
		bcs 	_BPIsFloat 					; already a float if set.
		txa
		.floatingpoint_intTofloat 			; if int, convert to float
		tax
_BPIsFloat:
		rts

; ************************************************************************************************
;
;						Add is a special case because you can add strings
;
; ************************************************************************************************

AddHandler:	;; [+]
		jsr 	DereferenceTwo 				; dereference top two on stack.
		lda 	esType,x 					; check two strings.
		and 	esType+1,x
		and 	#$40 						; if both have bit 6 set ... we have two strings
		bne 	_AHStringConcat				; concatenate strings.
		;
		binop 	MInt32Add,fadd
		;
		;		Two strings, so concatenate them.
		;
_AHStringConcat:
		txa 								; handled by the string module.
		.string_concat
		tax
		rts

; ************************************************************************************************
;
;		All the others are identical, some operations (mod,and,or,xor,shift,ref) floats don't work.
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

ShlHandler: ;; [<<]		
		jsr 	DereferenceTwo 			
		binop 	Mint32ShiftLeftX,fImpossible

ShrHandler: ;; [>>]		
		jsr 	DereferenceTwo 			
		binop 	MInt32ShiftRightX,fImpossible

WordRefHandler: ;; [!]
		jsr 	DereferenceTwo 			
		binop 	MInt32WordIndirect,fImpossible

ByteRefHandler: ;; [?]
		jsr 	DereferenceTwo 			
		binop 	MInt32ByteIndirect,fImpossible

PowerHandler:	;; [^]
		jsr 	DereferenceTwo
		binop 	PowerInteger,fPower
PowerInteger:
		jsr 	BPMakeBothFloat				; make them float.
		txa
		.floatingpoint_fpower				; do the power calculation
		.floatingpoint_floatToInt			; convert back to integer.
		tax
		lda 	#0 							; make type integer
		sta 	esType,x
		rts

; ************************************************************************************************
;
;										Byte/Word Indirect
;
; ************************************************************************************************

Mint32WordIndirect:
 		lda 	#$80 				 		; word reference type (bit 7 set)
		bne 	Min32Indirect
Mint32ByteIndirect:
		lda 	#$A0 						; byte reference type (bit 7, bit 5 set)
Min32Indirect:
		pha 								; save the indirection
		jsr 	MInt32Add 					; add a!b a?b
		pla 								; and set the type to reference.
		sta 	esType,x 	 				; so a!b => a+b and it's a reference....
		rts		

; ************************************************************************************************
;
;										Shift left or right
;
; ************************************************************************************************

Mint32ShiftLeftX:
		clc 								; CC shift left
		bcc 	Mint32Shift
Mint32ShiftRightX:
		sec 								; CS shift right

Mint32Shift:								; at this point, CS is right, CC is left
		php 								; save carry flag on stack.
		lda 	esInt1+1,x 					; if shift >= 32 then it is zero.
		ora 	esInt2+1,x
		ora 	esInt3+1,x		
		bne 	_MShiftZero
		lda 	esInt0+1,x		
		cmp 	#32
		bcs 	_MShiftZero
_MShiftLoop:
		lda 	esInt0+1,x 					; check count is zero
		beq 	_MShiftExit
		dec 	esInt0+1,x
		plp 								; restore and save carry
		php
		bcc 	_MShiftLeft 				; and shift left/right accordingly.
		jsr 	Mint32ShiftRight
		jmp 	_MShiftLoop
_MShiftLeft:		
		jsr 	Mint32ShiftLeft
		jmp 	_MShiftLoop
_MShiftExit:
		plp	 								; throw saved carry and exit
		rts

_MShiftZero:
		jmp 	MInt32False 				; return 0 as shifted >= 32 times.

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
		