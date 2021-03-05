; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		find.asm
;		Purpose:	Locate a variable
;		Created:	1st March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;		+0,+1 		Link to next variable or $0000
;		+2,+3 		Address of variable name in code
;		+4 			Hash value for this
;		+5 ....		Data
;
; ************************************************************************************************
;
;					(codePtr),y points to the variable and it is already setup
;
; ************************************************************************************************

CreateVariable:
		tya 								; push Y on the stack twice.
		pha
		pha

		ldx 	varType 					; get var type 0-5
		lda		_CVSize-$3A,x 				; the bytes for this new variable.
		pha 								; save length
		;
		lda 	lowMemory 					; set low Memory ptr to temp0
		sta 	temp0 						; (address of the new variable)
		lda 	lowMemory+1
		sta 	temp0+1
		;
		pla 								; get length
		jsr 	AdvanceLowMemoryByte 		; shift alloc memory forward by the length.

		lda 	varHash 					; store hash at offset 4.
		ldy 	#4
		sta 	(temp0),y

		pla 								; offset, work out where the variable name is.
		clc
		adc 	codePtr
		ldy 	#2 							; copy that into slots 2 + 3.
		sta 	(temp0),y
		lda 	codePtr+1
		adc 	#0
		iny
		sta 	(temp0),y
		;
		ldy 	#0 							; copy current hash pointer in link
		lda 	(hashList),y
		sta 	(temp0),y
		iny
		lda 	(hashList),y
		sta 	(temp0),y
		;
		lda 	temp0+1 					; set new link
		sta 	(hashList),y
		dey
		lda 	temp0
		sta 	(hashList),y
		lda 	varType 					; type in A
		ldy 	#5 							; offset in Y
		jsr 	ZeroTemp0Y 					; zero (temp0),y with whatever type.
		.puly 								; restore Y
		rts
;
;		Size look up table.
;
_CVSize:.byte 	VarHSize+VarISize,VarHSize+VarISize 					; <storage for integer>
		.byte 	VarHSize+VarSSize,VarHSize+VarSSize 					; <storage for string>
		.byte 	VarHSize+VarFSize,VarHSize+VarFSize 					; <storage for float>

; ************************************************************************************************
;
;							Write a blank at (temp0),y, allowing for type A.
;
; ************************************************************************************************
		
ZeroTemp0Y:
		and 	#$FE 						; convert array type to base type
		cmp 	#$3C 						; check string		
		beq 	_ZTWriteNullString 			; write "" string
		cmp 	#$3E 						; check float
		beq 	_ZTWriteFloat
		;
		;		Null Integer.
		;
		.pshy
		lda 	#0
		sta 	(temp0),y
		iny
		sta 	(temp0),y
		iny
		sta 	(temp0),y
		iny
		sta 	(temp0),y
		.puly
		rts
		;
		;		Null string at (temp0),Y
		;
_ZTWriteNullString:
		lda 	#0 							; put a reference to null string as the default value.
		sta 	NullString
		lda 	#NullString & $FF
		sta 	(temp0),y
		lda 	#NullString >> 8
		iny
		sta 	(temp0),y
		dey
		rts
		;
		;		Float write done by floating point module.
		;
_ZTWriteFloat:
		.floatingpoint_setzero
		rts

		.send 	code
