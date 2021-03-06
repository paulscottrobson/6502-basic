; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		unarystr.asm
;		Purpose:	Unary Routines
;					The functionality is in the string library.
;		Created:	28th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;										CHR$() handler
;
; ************************************************************************************************

ExecChr:	;; [chr$(]
		jsr 	EvaluateSmallInteger		; character number 0-255		
		jsr 	CheckRightParen				; right bracket
ChrCode:		
		.pshy 								; save Y
		txa 								; A = stack
		ldy 	esInt0,x					; Y = character
		.string_chrs		 				; make it
		tax 								; X = stack
		.puly 								; restore Y.
		rts

; ************************************************************************************************
;
;							LOWER$()/UPPER$() handler
;
; ************************************************************************************************

ExecLower:	;; [lower$(]
		sec 								; set carry is lower
		bcs 	ExecUpperLower
ExecUpper:  ;; [upper$(]		
		clc 								; clear carry is upper
ExecUpperLower:		
		php 								; save carry
		jsr 	EvaluateString 				; string to stack,X
		jsr 	CheckRightParen 			; check closing right bracket.
		plp 								; restore carry, save Y
		.pshy
		lda 	#0 							; A zero if upper, 1 if lower.
		rol 	a
		tay 								; now in Y
		txa 								; do the substring and exit.
		.string_setcase
		tax	
		.puly	
		rts

; ************************************************************************************************
;
;										LEFT$() handler
;
;		These three all set up MID$ in the three stack spaces - string, start, size
;
; ************************************************************************************************

ExecLeft:	;; [left$(]
		jsr 	EvaluateString 				; string to stack,X
		jsr 	CheckComma
		inx
		lda 	#1 							; 1 for 2nd parameter.
		jsr 	MInt32Set8Bit 	
		inx
		jsr 	EvaluateSmallInteger 		; smallint 3rd parameter
ExecSubstring:
		dex 								; fix up X
		dex
		jsr 	CheckRightParen 			; check closing right bracket.
		txa 								; do the substring and exit.
		.string_substring 
		tax		
		rts


; ************************************************************************************************
;
;										MID$() handler
;
; ************************************************************************************************

ExecMid:	;; [mid$(]
		jsr 	EvaluateString 				; string to stack,X
		jsr 	CheckComma
		inx
		jsr 	EvaluateSmallInteger 		; smallint 2nd parameter
		cmp 	#0
		beq 	_EMValue
		inx
		lda 	#255 						; 255 default for 3nd parameter - this is optional.
		jsr 	MInt32Set8Bit 	
		lda 	(codePtr),y 				; is there a ) next
		cmp 	#TKW_RPAREN 				; if so, just MID$(a$,2)
		beq 	ExecSubString
		jsr 	CheckComma
		jsr 	EvaluateSmallInteger 		; smallint 2nd parameter
		jmp 	ExecSubString

_EMValue:
		.throw 	BadValue
		
; ************************************************************************************************
;
;										RIGHT$() handler
;
; ************************************************************************************************

ExecRight:	;; [right$(]
		jsr 	EvaluateString 				; string to stack,X
		jsr 	CheckComma
		inx
		jsr 	EvaluateSmallInteger 		; smallint 2nd parameter.
		dex
		;
		.pshy 								; save Y
		lda 	esInt0,x 					; copy address of string to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1

		ldy 	#0 							; point to length
		lda 	(temp0),y 					; get the length.
		clc 								; add 1.
		adc 	#1 
		sec
		sbc 	esInt0+1,x  				; subtract right count.
		beq		_ERMake1 					; if zero, make it 1.
		bcs		_EROkay
_ERMake1:
		lda 	#1 							; start position.					
_EROkay:
		inx 								; set start pos.
		sta 	esInt0,x		
		inx
		lda 	#255 						; 255 default for 3nd parameter.
		jsr 	MInt32Set8Bit 	

		.puly
		jmp 	ExecSubString 				; do the substring code.

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
		