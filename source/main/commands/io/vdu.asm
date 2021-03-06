; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vdu.asm
;		Purpose:	Send character(s) to display
;		Created:	28th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										VDU Command
;
; ************************************************************************************************

Command_VDU: 	;; [vdu]
		jsr 	EvaluateRootInteger 			; get integer at root.
		lda 	esInt0
		.device_print 					
_CVNext:		
		lda 	(codePtr),y 					; what follows ?
		iny
		cmp 	#TKW_COMMA 						; comma, do again
		beq 	Command_VDU
		cmp 	#TKW_SEMICOLON 					; semicolon, print MSB
		bne 	_CVExit
		lda 	esInt1
		.device_print 					
		jmp 	_CVNext
		
_CVExit:dey
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
		