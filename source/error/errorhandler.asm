; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		errorhandler.asm
;		Purpose:	Handles errors.
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

ErrorHandler:		
		set16 	temp0,ErrorTextList
_EHFind:dex
		beq 	_EHFound
		ldy 	#0 							; goto next text message
		sec
		lda 	temp0
		adc 	(temp0),y
		sta 	temp0
		bcc 	_EHFind
		inc 	temp0+1
		jmp 	_EHFind
_EHFound:
		.main_printstring 					; print that string.
		ldy 	#0 							; in a line ?
		lda 	(codePtr),y
		beq 	_EHNoLine

		set16 	temp0,EHAtMsg
		.main_printstring		
_EHNoLine: 									; set up line number in TOS
		ldy 	#1
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
		ldy 	#10
		lda 	#0
		.main_inttostr
		.main_printstring		

_EHHalt:jmp 	_EHHalt

EHAtMsg:
		.text 	9," AT LINE "
;
;		List of error messages in order.
;
		.include "../generated/errortext.inc"

		.send code

