; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		errorhandler.asm
;		Purpose:	Handles errors.
;		Created:	21st February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Handle error X
;
; ************************************************************************************************

ErrorHandler:		
		.pshx
		lda 	#1 							; red
		.device_ink
		.pulx
		set16 	temp0,ErrorTextList 		; list of length-prefixed strings, scan down them.
_EHFind:dex									; errors start at 1
		beq 	_EHFound
		ldy 	#0 							; goto next text message, add length + 1 to the pointer.
		sec
		lda 	temp0
		adc 	(temp0),y
		sta 	temp0
		bcc 	_EHFind
		inc 	temp0+1
		jmp 	_EHFind
_EHFound:
		jsr 	EHPrintAscii 				; print the string "temp0" now points to.
		ldy 	#0 							; in a line, e.g. the offset to next is non zero.
		lda 	(codePtr),y
		beq 	_EHNoLine

		lda 	codePtr+1 					; code running from the command line.
		cmp 	basePage+1
		bcc 	_EHNoLine

		set16 	temp0,EHAtMsg 				; print " @ "
		jsr 	EHPrintAscii

		ldy 	#1 							; set up line number in TOS
		ldx 	#0
		lda 	(codePtr),y
		sta 	esInt0,x
		iny
		lda 	(codePtr),y
		sta 	esInt1,x
		lda 	#0
		sta 	esInt2,x
		sta 	esInt3,x
		set16 	temp0,convertBuffer 		; convert to string and print
		ldy 	#10 						; in base 10.
		lda 	#0							; stack position zero.
		.main_inttostr
		jsr 	EHPrintAscii	
_EHNoLine: 									
		.device_crlf
		.interaction_warmstart
EHAtMsg:
		.text 	3," @ "
;
;		List of error messages in order.
;
		.include "../generated/errortext.inc"

;
;		String printer for ASCII output.
;
EHPrintAscii:
		ldy 	#0
		lda 	(temp0),y
		tax
		beq 	_EHPExit
_EHPLoop:
		iny
		.pshx
		lda 	(temp0),y
		.device_printascii
		.pulx
		dex
		bne 	_EHPLoop
_EHPExit:
		rts

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
