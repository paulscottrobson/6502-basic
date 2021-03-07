; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		identifier.asm
;		Purpose:	Detokenise an identifier
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;							Show identifier at (codePtr),y
;
; ************************************************************************************************

DTIdentifier:
		lda 	#0 							; now text, may need spaces
		jsr 	DTSwitchMode
		settype LTYIdentifier
_DTILoop:
		lda 	(codePtr),y 				; output main bit of identifier.
		jsr 	ListOutputCharacter		
		iny
		lda 	(codePtr),y 				; until end identifier marker.
		cmp 	#$3A
		bcc 	_DTILoop
		iny

		cmp 	#$3A 						; is it integer non array
		beq 	_DTIExit 					; no postfix.
		pha
		lda  	#1 							; it ends in punctuation
		sta 	LastCharacterClass
		setType LTYPunctuation
		pla
		cmp 	#$3B
		beq 	_DTIArray

		lsr 	a 							; array flag in C
		php
		eor 	#$3C/2 						; check if $
		beq 	_DTIDollar
		lda 	#"$"^"#" 					; this if #, 0 if $
_DTIDollar:
		eor 	#"$"
		jsr 	ListOutputCharacter
		plp
		bcc 	_DTIExit
_DTIArray:		
		lda 	#"("
		jsr 	ListOutputCharacter
_DTIExit:
		rts

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
