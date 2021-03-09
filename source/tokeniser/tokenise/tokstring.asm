; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokstring.asm
;		Purpose:	Tokenise Quoted String
;		Created:	9th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;					Tokenise quoted string at (codePtr) into internal format
;									CS if tokenising successful.
;
; ************************************************************************************************

TokeniseString:		
		iny 								; skip opening quote
		ldx 	#255 						; count length of string.
		sty 	temp0 						; save start.
_TSGetLength:
		lda 	(codePtr),y 				; get next
		beq 	_TSFail						; end of line, fail
		iny
		inx
		cmp 	#'"' 						; until end quote found.
		bne 	_TSGetLength
		;
		lda 	#TOK_STR 					; write string token out
		jsr 	TokenWrite
		txa 								; output length
		jsr 	TokenWrite
		ldy 	temp0 						; get original position
		cpx 	#0 							; check ended
		beq 	_TSExit
_TSOutput:
		lda 	(codePtr),y					; output character
		jsr 	TokenWrite
		iny
		dex
		bne 	_TSOutput
_TSExit:		
		iny 								; skip ending quote
		sec 								; return CS.
		rts

_TSFail:
		clc
		rts


		.send code
