; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		unary.asm
;		Purpose:	Unary Routines
;		Created:	26th February 2021
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
		lda 	(temp0),y
		ldy 	tempShort 					
		jsr 	MInt32Set8Bit
		jsr 	CheckRightParen
		rts

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
		lda 	(temp0),y
		iny 		 						; point to first character, we can do LEN code after that
		cmp 	#0 
		bne 	ULFinish
		error 	BadValue

; ************************************************************************************************
;
;										Absolute value
;
; ************************************************************************************************

UnaryAbs:	;; [abs(]
		jsr 	EvaluateNumeric
		bcs 	_UAFloat
		jsr 	MInt32Absolute
		jsr 	CheckRightParen
		rts
_UAFloat:
		txa
		floatingpoint_fabs		
		tax
		jsr 	CheckRightParen
		rts

; ************************************************************************************************
;
;										Sign
;
; ************************************************************************************************

UnarySgn:	;; [sgn(]
		jsr 	EvaluateNumeric
		bcs 	_USFloat
		jsr 	MInt32Sign
		jsr 	CheckRightParen
		rts
_USFloat:
		txa
		floatingpoint_fsgn
		tax
		jsr 	CheckRightParen
		rts

; ************************************************************************************************
;
;										Peek,Deek,Leek
;
; ************************************************************************************************

UnaryPeek:	;; [peek(]
		jsr 	PDLCode
		jmp 	PDLByte0

UnaryDeek:	;; [deek(]
		jsr 	PDLCode
		jmp 	PDLByte1

UnaryLeek:	;; [leek(]
		jsr 	PDLCode
		ldy 	#3
		lda 	(temp0),y
		sta 	esInt3,x
		dey
		lda 	(temp0),y
		sta 	esInt2,x
PDLByte1:
		ldy 	#1
		lda 	(temp0),y
		sta 	esInt1,x
PDLByte0:		
		ldy 	#0
		lda 	(temp0),y
		sta 	esInt0,x
		ldy 	tempShort 					; restore Y
		jsr 	CheckRightParen 			; check right and return
		rts

PDLCode:
		jsr 	EvaluateInteger
		lda 	esInt0,x 					; copy address of string to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		lda 	#0 							; zero upper 3 bytes of result, type okay.
		sta 	esInt1,x
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
		pha 								; save comparator on stack.
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
		pla 								; throw comparator and return.
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

		.send code		
		