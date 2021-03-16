; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokint.asm
;		Purpose:	Tokenise an integer
;		Created:	8th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;					Tokenise string at (codePtr) into an integer base A
;								CS if tokenising successful.
;
; ************************************************************************************************

TokeniseInteger:
		;
		;		First thing is to load the tokenisable text into the convertBuffer	
		;
		sta 	temp1 						; save base
		ldx 	#0							; count of chars so far
		;
		;		Copy allowed characters into the buffer.
		;
		stx 	convertBuffer
_TIGetChars:
		lda 	(codePtr),y 				; check character is numeric
		cmp 	#"0"
		bcc 	_TIEndGet
		cmp 	#"9"+1
		bcc 	_TIHaveChar
		;
		lda 	temp1 						; fail if not hex mode
		cmp 	#10
		beq 	_TIEndGet		
		;
		lda 	(codePtr),y 				; check legitimate hex.
		cmp 	#"A"
		bcc 	_TIEndGet
		cmp 	#"Z"+1
		bcs 	_TIEndGet
_TIHaveChar:
		inx 								; write into buffer.
		stx 	convertBuffer 				
		sta 	convertBuffer,x
		iny 								; next char
		jmp 	_TIGetChars
		;
		;		Convert to integer if one character was tokenised
		;
_TIEndGet:		
		cpx 	#0 							; no char acquired.
		beq 	_TIFail

		.pshy
		set16 	temp0,convertBuffer 		; convert to integer
		lda 	#0 							; stack level 0
		ldy 	temp1 						; base Y
		.main_strtoint
		.puly
		bcc 	_TIFail 					; didn't convert.

		jsr 	TIRecursiveOut 				; recursive output ?
		sec
		rts

_TIFail:
		clc
		rts		

; ************************************************************************************************
;
;								Recursive output of value in TOS
;
; ************************************************************************************************

TIRecursiveOut:
		lda 	esInt0 						; get value to output after possible recursion
		and 	#$3F
		ora 	#$40
		pha
		;
		lda 	esInt0 						; are we recursing ?
		and 	#$C0
		ora 	esInt1
		ora 	esInt2
		ora 	esInt3
		beq 	_TIRONoRecursion
		ldx 	#6 							; shift right x 6
_TIROShift:
		lsr 	esInt3
		ror 	esInt2
		ror 	esInt1
		ror 	esInt0
		dex
		bne 	_TIROShift
		jsr 	TIRecursiveOut 				; call recursively 		 			
_TIRONoRecursion:
		pla 								; pull the old bit.
		jmp 	TokenWrite		

		.send code
		