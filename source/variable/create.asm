; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		create.asm
;		Purpose:	Create a new variable.
;		Created:	1st March 2021
;		Reviewed: 	9th March 2021
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
		pha									; position in code of the new variable.
		pha

		ldx 	varType 					; get var type 0-5 from the var type
		lda		_CVSize-$3A,x 				; the bytes required for this new variable.
		pha 								; save length
		;
		lda 	lowMemory 					; set low Memory ptr to temp0
		sta 	temp0 						; (address of the new variable)
		lda 	lowMemory+1
		sta 	temp0+1
		;
		pla 								; get length
		clc 								; add to low memory.
		adc 	lowMemory
		sta 	lowMemory
		bcc 	_CVNoCarry
		inc 	lowMemory+1
_CVNoCarry:

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
		cmp 	basePage+1 					; compare against the program base.
		bcs 	_CVNotImmediate
		jsr 	CloneVariableName 			; we need to clone the variable name (immediate mode)
_CVNotImmediate:		
		;
		ldy 	#0 							; copy current hash pointer in link
		lda 	(hashList),y 				; so we're inserting it in the front of a linked list
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
_CVSize:.byte 	VarHSize+VarISize,VarHSize+VarASize 					; <storage for integer>
		.byte 	VarHSize+VarSSize,VarHSize+VarASize 					; <storage for string>
		.byte 	VarHSize+VarFSize,VarHSize+VarASize 					; <storage for float>

; ************************************************************************************************
;
;							Write a blank at (temp0),y, allowing for type A.
;
; ************************************************************************************************
		
ZeroTemp0Y:
		lsr 	a 							; bit 0 in carry
		asl 	a
		bcs 	_ZTExit 					; we don't initialise arrays.
		;
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
_ZTExit:		
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
		.pshx
		.floatingpoint_setzero
		.pulx
		rts

; ************************************************************************************************
;
;						Clone the variable name at (temp0),2/3
;	Required when a new variable is defined from the command line, as we cannot then use the
;	"in code" address.
;
; ************************************************************************************************

CloneVariableName:
		ldy 	#2 							; copy vname address to temp2
		lda 	(temp0),y
		sta 	temp2
		iny
		lda 	(temp0),y
		sta 	temp2+1
		;
		lda 	lowMemory+1 				; copy lowMemory address to (temp0),2/3
		sta 	(temp0),y
		dey
		lda 	lowMemory
		sta 	(temp0),y
		;
		ldy 	#0 							; copy data from (temp2) to (lowMemory)
_CVNCopy:
		lda		(temp2),y
		sta 	(lowMemory),y
		iny
		cmp 	#$3A 						; until the whole name has been copied.
		bcc 	_CVNCopy
		;
		tya 								; add Y to low memory
		clc
		adc 	lowMemory
		sta 	lowMemory
		bcc 	_CVNNoCarry
		inc 	lowMemory+1
_CVNNoCarry:		
		rts

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
