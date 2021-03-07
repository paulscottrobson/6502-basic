; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		createarray.asm
;		Purpose:	Create an array
;		Created:	6th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		


; ************************************************************************************************
;
;					Dim Definition - (codePtr),y points to the variable
;
; ************************************************************************************************

CreateArray:	;; <createarray>
		jsr 	AccessSetup 				; set up the basic stuff.
		;
		lda 	varType 					; is the variable type an array
		lsr 	a
		bcc 	_CANotArray 				; no, cause an error.
		;
		jsr 	FindVariable 				; does the variable exist already
		bcs 	_CAFound 					; cannot redefine it.
		;
		jsr 	CreateVariable 				; create the variable entry.
		ldy 	varEnd 						; point Y to the end of the variable entry.
		;
		lda 	temp0 						; push address of new variable entry on the stack
		pha
		lda 	temp0+1
		pha
		lda 	varType 					; push variable type on the stack.
		pha
		;
		lda 	#0 							; work out the array dimension on TOS.
		.main_evaluateint 
		.main_checkrightparen
		;
		pla 		 						; restore type and position.						
		sta 	varType
		pla
		sta 	temp0+1
		pla
		sta 	temp0
		;
		lda 	esInt1 						; limit array max to 4096.
		and 	#$E0
		ora 	esInt2
		ora 	esInt3
		beq 	_CASizeOk

_CASize:		
		error 	BadValue
_CAFound:	
		error 	DupArray
_CANotArray:		
		error 	NotArray

_CASizeOk:
		;
		inc 	esInt0 						; bump it by one, as we index from 0
		bne 	_CANoCarry 					; e.g. DIM A(10) ... A(0) - A(10)
		inc 	esInt0+1
_CANoCarry:		
		;
		.pshy
		ldy 	#5
		lda 	lowMemory 					; copy low memory address in +5,+6
		sta 	(temp0),y 					; this is where it will come from
		iny
		lda 	lowMemory+1
		sta 	(temp0),y
		iny
		lda 	esInt0 						; copy maximum index value to +7,+8
		sta 	(temp0),y
		iny
		lda 	esInt1
		sta 	(temp0),y
		iny
		;
		ldx 	varType 					; get the length per element
		lda 	_CAActualSize-$3A-1,x
		sta 	(temp0),y
		tax 								; save size in X
		;
		lda 	lowMemory 					; set temp0 to low memory.
		sta 	temp0
		lda 	lowMemory+1
		sta 	temp0+1
		;
		lda 	#0 							; temp1 is the counter.
		sta 	temp1
		sta 	temp1+1
_CAInitialiseArray:
		ldy 	#0 							; write a null record at temp0
		lda 	varType 					; base type of array in A.
		and 	#$FE
		jsr 	ZeroTemp0Y
		;
		txa 								; add X to temp0, also updating lowMemory
		clc
		adc 	temp0 					
		sta 	temp0
		sta 	lowMemory
		lda 	temp0+1
		adc 	#0
		sta 	temp0+1
		sta 	lowMemory+1
		;
		inc 	temp1 						; bump the counter.
		bne 	_CAIANoCarry
		inc 	temp1+1
_CAIANoCarry:
		lda 	esInt0 						; counter reached max index
		cmp 	temp1
		bne 	_CAInitialiseArray
		lda 	esInt1
		cmp 	temp1+1
		bne 	_CAInitialiseArray		
		.puly
		rts

_CAActualSize:
		.byte 	VarISize,0
		.byte 	VarSSize,0
		.byte 	VarFSize,0
		.debug

		.send 	code

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
