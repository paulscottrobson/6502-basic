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
