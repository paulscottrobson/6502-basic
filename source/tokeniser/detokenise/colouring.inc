; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		colouring.inc
;		Purpose:	Colour scheme and macros
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

LTYLineNumber = $84
LTYPunctuation = $82
LTYIdentifier = $87
LTYConstant = $86
LTYKeyword = $83
LTYString = $81

setType .macro
		lda 	#\1
		jsr 	ListOutputCharacter
		.endm

