; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokpunct.asm
;		Purpose:	Tokenise punctuation
;		Created:	8th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;					Tokenise string at (codePtr) into a punctuation token
;								CS if tokenising successful.
;
; ************************************************************************************************

TokenisePunctuation:
		lda	 	(codePtr),y 				; copy next 2 chars into convertBuffer
		sta 	convertBuffer+1
		iny
		lda 	(codePtr),y
		sta 	convertBuffer+2
		iny 								; Y is +2
		lda 	#2 							; 2 character string.
		sta 	convertBuffer
		jsr 	TokenSearch 				; search for that token.
		bcs 	_TIFound
		;
		dec 	convertBuffer 				; make it a 1 character string
		dey 								; Y is now +1
		jsr 	TokenSearch 				; search for that token.
		bcs 	_TIFound
		dey 								; Y is now +0, carry clear indicating failure.
_TIFound:
		rts		

		.send 	code