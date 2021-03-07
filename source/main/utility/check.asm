; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		check.asm
;		Purpose:	Various checking 
;		Created:	25th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;									Check generic
;	
; ************************************************************************************************

CheckToken:
		cmp 	(codePtr),y
		bne 	_CTError
		iny
		rts
_CTError:
		error 	Syntax
		
; ************************************************************************************************
;
;								Check and consume right bracket
;	
; ************************************************************************************************

CheckRightParen: ;; <checkrightparen>
		lda 	(codePtr),y
		iny
		cmp 	#TKW_RPAREN
		bne 	_CRPError
		rts
_CRPError:
		error 	MissingRP

; ************************************************************************************************
;
;								Check and consume comma
;	
; ************************************************************************************************

CheckComma:
		lda 	(codePtr),y
		iny
		cmp 	#TKW_COMMA
		bne 	_CCError
		rts
_CCError:
		error 	MissingComma

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
		