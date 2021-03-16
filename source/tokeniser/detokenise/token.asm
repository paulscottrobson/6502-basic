; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		token.asm
;		Purpose:	Detokenise a single token
;		Created:	7th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;					Decode token at (codePtr),y, may be shifted.
;
; ************************************************************************************************

DTDecodeToken:
		;
		;		Identify if shift $81..83 and select correct table to use.
		;
		ldx 	#0 							; table number to use
		lda 	(codePtr),y
		cmp 	#$84 				
		bcs 	_DTNotShift
		and 	#3 							; get the shift 1..3
		asl 	a 							; put 2 x in X
		tax
		iny
		;
		;		Get token table address into temp0
		;
_DTNotShift:
		lda 	TokenTableAddress,x 		; get the token table to use to decode it.
		sta 	temp0 						; point into temp0
		lda 	TokenTableAddress+1,x 
		sta 	temp0+1
		;
		;		Get the token into X
		;	
		lda 	(codePtr),y 				; get the token value.
		iny 								; consume it.
		tax
		;
		;		Find the text for this token by working through the table.
		;
		.pshy 								; save Y position.
_DTFindText:
		cpx 	#$86 						; finished ?
		beq 	_DTFoundText
		dex
		;
		ldy 	#0 							; add length+1 to temp0
		sec
		lda 	(temp0),y
		adc 	temp0
		sta 	temp0
		bcc 	_DTFindText
		inc 	temp0+1
		jmp 	_DTFindText
		;
		;		temp0 now points to the text
		;
_DTFoundText:
		ldy 	#1 							; get first character
		lda 	(temp0),y
		and 	#$7F 						; will have bit 7 set.		
		cmp 	#"A" 						; check for punctuation.
		bcc 	_DTIsPunctuation 
		cmp 	#"Z"+1
		bcs 	_DTIsPunctuation
		lda 	#0 							; now text, may need spaces
		jsr 	DTSwitchMode
		settype LTYKeyword
		jmp 	_DTPrint
_DTIsPunctuation:		
		lda 	#1 							; now punctuation, may need spaces
		jsr 	DTSwitchMode
		setType LTYPunctuation
_DTPrint:		
		;
		lda 	#1 							; fix case.
		jsr 	DTPrintLengthPrefix 		; print it out.
		ldy 	#0 						
		lda 	(temp0),y
		tay
		lda 	(temp0),y
		and 	#$7F 						; will have bit 7 set.		
		cmp 	#"A" 						; check for punctuation.
		bcc 	_DTIsNowPunctuation 
		cmp 	#"Z"+1
		bcc 	_DTPExit
_DTIsNowPunctuation:						; if so, set current to last character.
		lda 	#1
		sta		LastCharacterClass

_DTPExit:
		.puly
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
		