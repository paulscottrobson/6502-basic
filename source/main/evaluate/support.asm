; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		support.asm
;		Purpose:	Support/Link for evaluate
;		Created:	22nd February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;									Evaluate various terms
;
; ************************************************************************************************

EvaluateTerm:
		lda 	#15 						; no binary operator has this high a precedence.
		jsr 	EvaluateLevel
		jsr 	DereferenceOne
		rts

EvaluateNumericTerm:
		jsr 	EvaluateTerm
		lda 	esType,x
		asl 	a 							; see if it's a string.
		bmi 	ENTType
		rts

EvaluateIntegerTerm:
		jsr 	EvaluateTerm
		lda 	esType,x
		bne 	ENTType
		rts

ENTType:
		error 	BadType

; ************************************************************************************************
;
;									Evaluate various expressions
;
; ************************************************************************************************

EvaluateRoot: 								; evaluate at bottom stack level
		ldx 	#0
Evaluate:
		lda 	#0
		jsr 	EvaluateLevel
		jsr 	DereferenceOne
		rts

EvaluateNumeric:
		jsr 	Evaluate
		lda 	esType,x
		asl 	a 							; see if it's a string.
		bmi 	ENTType
		lsr 	a 							; shift float flag into carry.
		lsr 	a
		rts

EvaluateString:
		jsr 	Evaluate
		lda 	esType,x
		asl 	a 							; see if it's a string.
		bpl 	ENTType
		rts

EvaluateRootInteger:
		ldx 	#0
EvaluateInteger:
		jsr 	Evaluate
		lda 	esType,x
		bne 	ENTType
		rts

EvaluateSmallInteger:
		jsr 	EvaluateInteger
		lda 	esInt1,x
		ora 	esInt2,x
		ora 	esInt3,x
		bne 	_ESIValue
		lda 	esInt0,x
		rts

_ESIValue:
		error 	BadValue

; ************************************************************************************************
;
;											Links
;
; ************************************************************************************************

LinkEvaluate: 	;; <evaluate>
		tax
		jsr 	Evaluate
		txa
		rts

LinkEvaluateTerm: 	;; <evaluateterm>
		tax
		jsr 	EvaluateTerm
		txa
		rts

LinkEvaluateInteger: 	;; <evaluateint>
		tax
		jsr 	EvaluateInteger
		txa
		rts

LinkEvaluateSmallInt: 	;; <evaluatesmall>
		tax
		jsr 	EvaluateSmallInteger
		txa
		rts

; ************************************************************************************************
;
;									Evaluate a reference
;
; ************************************************************************************************
				
EvaluateReference:
		;
		;		Get the precedence level of !, also ?, to evaluate a refrence
		;
		lda 	ELBinaryOperatorInfo+TKW_PLING-TOK_BINARYST
		sec 								; sub 1 to allow a!x b?x to work.
		sbc 	#1
		jsr 	EvaluateLevel
		lda 	esType,x
		bpl 	_ERFail
		rts
_ERFail:
		error 	NoReference		

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
		