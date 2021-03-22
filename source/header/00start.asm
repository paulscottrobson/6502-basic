; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		00start.asm
;		Purpose:	Start up code.
;		Created:	21st February 2021
;		Reviewed: 	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code
Start:	
		jmp 	GoColdStart 				; +0 	boot BASIC
		jmp 	GoTokTest					; +3 	run tokeniser test code.
		.if 	installed_tokeniser==1 		; +6 	address of table of token texts.
		.word 	TokenTableAddress
		else
		.word 	0
		.endif

GoColdStart:
		.set16 basePage,programMemory 		; set up
		.set16 endMemory,endOfMemory
		jsr 	InitialiseAll 				; initialise everything.

		.if installed_interaction == 0 && autorun != 0
		.main_run
		.else		
		.interaction_coldstart
		.endif

		.include "../generated/initialiseall.asm"

GoTokTest:
		.tokeniser_test
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
