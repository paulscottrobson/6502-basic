; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		coldwarmstart.asm
;		Purpose:	Handle cold/warm start
;		Created:	10th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;										Cold Start
;
; ************************************************************************************************

ColdStart:
		ldx 	#$FF 						; clear the stack
		txs	
		.device_initialise 					; initialise any hardware devices
		set16 	basePage,programMemory 		; where program code is stored
		set16  	endMemory,$9800 			; top of memory used.
		;
		;		If interaction installed or built with autorun=1, execute cold start
		;		otherwise go directly to run program.
		;
		.if installed_interaction == 1 && autorun == 0
		.interaction_coldstart
		.else
		jmp 	Command_Run
		.endif

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
