; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		cold.asm
;		Purpose:	Cold start
;		Created:	10th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

ColdStartEntry:	;; <coldstart>
		ldx 	#$FF
		txs
		;
		;		If coldstartnew = 0 then a NEW command is executed on cold start
		;		otherwise it just executes a CLEAR.		
		;
		.if coldstartnew == 1
		.main_new	
		.else
		.main_clear
		.endif
		;
		jmp 	WarmStartEntry

		.send code

