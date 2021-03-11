; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokentext.asm
;		Purpose:	Text tables for tokens
;		Created:	7th March 2021
;		Reviewed: 	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Token text.
;
;		We have four pointers to the text list of tokens. This address is accessible from 
;		offset 6 and 7 of the executable, so you can decode programs.
;
; ************************************************************************************************

TokenTableAddress:
		.word 	Group0Text
		.word 	Group1Text
		.word 	Group2Text
		.word 	Group3Text

		.include "../generated/tokentext0.inc"
		.include "../generated/tokentext1.inc"
		.include "../generated/tokentext2.inc"
		.include "../generated/tokentext3.inc"

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
		