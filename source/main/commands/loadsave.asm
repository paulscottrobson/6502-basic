; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		loadsave.asm
;		Purpose:	Save and Load functions
;		Created:	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Load file
;
; ************************************************************************************************

CommandLoad:	;; [load]
		jsr 	CLSParameters 					; get parameters for load.
		php
		.device_load 							; load filein.
		plp
		bcs 	_CLExit 						; if CC then load a program, so warm start.
		jsr 	CommandClear
		.interaction_warmstart
_CLExit		
		rts

; ************************************************************************************************
;
;										Save file
;
; ************************************************************************************************

CommandSave:	;; [save]			
		jsr 	CLSParameters					; get parameters for save
		bcc 	_CSNoOverrideAddress
		jsr 	CheckComma 						; should be a comma.
		ldx 	#2
		jsr 	EvaluateInteger 				; get save end address.
_CSNoOverrideAddress:
		.device_save
		rts

; ************************************************************************************************
;
;		Get file name, and optional load/save start address. Return CS if start address given
;
; ************************************************************************************************

CLSParameters:
		ldx 	#0 								; string
		jsr 	EvaluateString
		;
		inx 									; erase out +1 +2
		jsr 	MInt32False
		inx
		jsr 	MInt32False
		;
		lda 	basePage 						; default start address.
		sta 	esInt0+1
		lda 	basePage+1
		sta 	esInt1+1
		;
		lda 	endProgram 						; default end address
		sta 	esInt0+2
		lda 	endProgram+1
		sta 	esInt1+2
		;
		lda 	(codePtr),y 					; , following
		cmp 	#TKW_COMMA
		bne 	_CLSDefault
		;
		iny 									; skip comma
		ldx 	#1 								; get numeric value.
		jsr 	EvaluateInteger
		sec
		rts

_CLSDefault:		
		clc
		rts

		.send code