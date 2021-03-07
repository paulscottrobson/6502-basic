; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		unary.asm
;		Purpose:	Unary Routines
;		Created:	26th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;										String Length
;
; ************************************************************************************************

UnaryLen:	;; [len(]
		jsr 	ULStart
ULFinish:		
		lda 	(temp0),y 					; get length prefix
		ldy 	tempShort 					; get Y back 
		jsr 	MInt32Set8Bit 				; write it out.
		jsr 	CheckRightParen
		rts
;
;		Gets a string, and copies its address to temp0, and saves Y in tempShort
;		shared by LEN() and ASC()
;
ULStart:jsr 	EvaluateString
		lda 	esInt0,x 					; copy address of string to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		sty 	tempShort 					; get length
		ldy 	#0
		rts

; ************************************************************************************************
;
;										String ASCII first
;
; ************************************************************************************************

UnaryAsc:	;; [asc(]
		jsr 	ULStart 					; same as LEN() get string, save Y, point to length.
		lda 	(temp0),y 					; read length
		iny 		 						; point to first character, we can do LEN code after that
		cmp 	#0  	
		bne 	ULFinish 					; if length = 0 then error : asc("") -> error.
		error 	BadValue

; ************************************************************************************************
;
;										Absolute value
;
; ************************************************************************************************

UnaryAbs:	;; [abs(]
		jsr 	EvaluateNumeric 			; some numeric value
		bcs 	_UAFloat 					; CS then float, so use that function
		jsr 	MInt32Absolute 				; int version
		jsr 	CheckRightParen
		rts 
_UAFloat:
		txa 								; float version
		.floatingpoint_fabs		
		tax
		jsr 	CheckRightParen
		rts

; ************************************************************************************************
;
;										Sign
;
; ************************************************************************************************

UnarySgn:	;; [sgn(]
		jsr 	EvaluateNumeric 			; same as above but sign of value
		bcs 	_USFloat
		jsr 	MInt32Sign
		jsr 	CheckRightParen
		rts
_USFloat:
		txa
		.floatingpoint_fsgn
		tax
		jsr 	CheckRightParen
		rts

; ************************************************************************************************
;
;										Peek,Deek,Leek
;
; ************************************************************************************************

UnaryPeek:	;; [peek(]
		jsr 	PDLCode 					; each has common setup code put reads 1,2 or 4 bytes
		jmp 	PDLByte0

UnaryDeek:	;; [deek(]
		jsr 	PDLCode
		jmp 	PDLByte1

UnaryLeek:	;; [leek(]
		jsr 	PDLCode

		ldy 	#3							; read 3-2
		lda 	(temp0),y
		sta 	esInt3,x
		dey
		lda 	(temp0),y
		sta 	esInt2,x
PDLByte1: 									; read 1
		ldy 	#1
		lda 	(temp0),y
		sta 	esInt1,x
PDLByte0:									; read 0
		ldy 	#0
		lda 	(temp0),y
		sta 	esInt0,x
		ldy 	tempShort 					; restore Y
		jsr 	CheckRightParen 			; check right and return
		rts

PDLCode:
		jsr 	EvaluateInteger 			; some address
		lda 	esInt0,x 					; copy address of string to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		lda 	#0 							; zero upper 3 bytes of result, type okay.
		sta 	esInt1,x 					; PEEK needs upper 3 cleared
		sta 	esInt2,x
		sta 	esInt3,x
		sty 	tempShort 					; save Y
		rts

; ************************************************************************************************
;
;								random() or random(r)
;
; ************************************************************************************************

Unary_Random:	;; [random(]
		jsr 	MInt32Random 				; generate random number.

		lda 	(codePtr),y 				; check followed by )
		cmp 	#TKW_RPAREN
		beq 	_URExit
		inx 								; load range 0..r-1 into +1
		jsr 	EvaluateInteger
		dex
		jsr 	MInt32Modulus 				; calculate random % modulus
_URExit:
		jsr 	CheckRightParen 			; check right and return
		rts

; ************************************************************************************************
;
;										min() and max()
;
; ************************************************************************************************

Unary_Min:	;; [min(]
		lda 	#1 							; c1 cmp c2 needs to be > e.g. c1 > c2
		bne 	UnaryMBody
Unary_Max: ;; [max(]
		lda 	#$FF 						; c1 cmp c2 needs to be < e.g. c1 < c2
UnaryMBody:
		pha 								; save comparator on stack, shows min or max
		jsr 	Evaluate 					; get the first thing to check
		;
_UnaryMLoop:
		lda 	(codePtr),y 				; found ), indicates end.
		iny
		cmp 	#TKW_RPAREN 				
		beq 	_UnaryMExit 
		cmp 	#TKW_COMMA 					; found , indicates more.
		beq 	_UnaryMCompare
		error 	Syntax 						; syntax error.
		;
_UnaryMExit:
		pla 								; done so throw comparator and return.
		rts
		;
_UnaryMCompare:
		inx 								; get the 2nd thing to evaluate
		jsr 	Evaluate
		dex
		;
		jsr 	PerformComparison 			; this is part of evaluate/compare.asm
		sta 	tempShort 					; save result
		pla 								; get what we need
		pha		
		cmp 	tempShort 					; did we get it
		bne 	_UnaryMLoop 				; no, try another value.
		jsr 	MInt32False 				; promote 2nd to 1st.
		jsr 	MInt32Add
		jmp 	_UnaryMLoop

; ************************************************************************************************
;
;												PAGE
;
; ************************************************************************************************

Unary_Page: ;; [page]
		jsr 	MInt32False 				; zero
		lda 	basePage 					; copy base page address in.
		sta 	esInt0,x
		lda 	basePage+1
		sta 	esInt1,x		
		rts

; ************************************************************************************************
;
;											@<reference>
;
; ************************************************************************************************

UnaryReference: ;; [@]
		lda 	#15
		jsr 	EvaluateLevel 				; evaluate term and don't deference.
		lda 	esType,x 					; check it's a reference.
		bpl 	UType		
		lda 	#0 							; make it an integer
		sta 	esType,x
		rts

UType:	error 	BadType

; ************************************************************************************************
;
;									&<term> hex marker
;
; ************************************************************************************************

UnaryHexMarker: ;; [&]
		jmp 	EvaluateIntegerTerm

; ************************************************************************************************
;
;									~<term> one's complement
;
; ************************************************************************************************

UnaryComplement: ;; [~]
		jsr 	EvaluateIntegerTerm
		jsr 	MInt32Not
		rts

; ************************************************************************************************
;
;								Float->Int, Int->Float conversion
;
; ************************************************************************************************

UnaryIntToFloat: ;; [int(]
		jsr 	EvaluateNumeric				; some number
		lda 	esType,x 					; if float already, exit
		bne 	_UIFExit
		txa 								; convert and set type
		.floatingpoint_intToFloat
		tax
		lda 	#1
		sta 	esType,x
_UIFExit:		
		rts

UnaryFloatToInt: ;; [float(]
		jsr 	EvaluateNumeric 			; the number
		lda 	esType,x 					; if int already exit
		beq 	_UFIExit
		txa 								; convert to int
		.floatingpoint_floatToInt		
		tax
		lda 	#0 							; set type
		sta 	esType,x
_UFIExit:
		rts

; ************************************************************************************************
;
;										String allocate
;
; ************************************************************************************************

UnaryAlloc: ;; [alloc(]
		inx 								; evaluate memory required 
		jsr 	EvaluateInteger
		jsr 	CheckRightParen
		dex
		;
		lda 	esInt2+1,x 					; check at least in 64k range.
		ora 	esInt3+1,x
		bne 	_UABadValue
		;
		jsr 	MInt32False					; zero return.
		lda 	lowMemory+1 				; copy low memory in
		sta 	esInt1,x
		lda 	lowMemory
		sta 	esInt0,x
		;
		clc 								; add alloc required.
		adc 	esInt0+1,x
		sta 	lowMemory
		;
		lda 	lowMemory+1
		adc 	esInt1+1,x
		sta 	lowMemory+1
		bcs		_UABadValue 				; overflow definitely bad.
		rts

_UABadValue:
		error	BadValue		
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
		