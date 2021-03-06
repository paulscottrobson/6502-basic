; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		warmstart.asm
;		Purpose:	Handle Warm start
;		Created:	10th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;										Warm Start
;
; ************************************************************************************************

WarmStart:
		;
		;		If interaction installed, execute warm start, otherwise
		;		stop program running completely.
		;
		.if installed_interaction == 1		
		.interaction_warmstart
		.else
_WSHalt:
		jmp 	_WSHalt
		.endif	

		.send code
