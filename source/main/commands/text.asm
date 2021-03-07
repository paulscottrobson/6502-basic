; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		text.asm
;		Purpose:	Simple Text I/O functions
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;									Simple Text Functions
;
; ************************************************************************************************

Command_CLS:	;; [cls]
		.device_clear
		rts

Command_Ink:	;; [ink]
		ldx 	#0
		jsr 	EvaluateSmallInteger
		.device_ink
		rts

Command_Paper:	;; [paper]
		ldx 	#0
		jsr 	EvaluateSmallInteger
		.device_paper
		rts

Command_Locate: ;; [locate]
		ldx 	#0
		jsr 	EvaluateSmallInteger
		jsr 	CheckComma
		inx
		jsr 	EvaluateSmallInteger
		.pshy
		ldy 	esInt0+1
		lda 	esInt0
		.device_locate
		.puly
		rts

		.send code