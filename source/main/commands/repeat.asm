; *****************************************************************************
; *****************************************************************************
;
;		Name:		repeat.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		1st March 2021
;		Reviewed: 	7th March 2021
;		Purpose:	Repeat/Until
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;									REPEAT
;
; *****************************************************************************

Command_Repeat: 	;; [Repeat]
		ldx 	#4 							; allocate 4 bytes on stack for REPEAT
		lda 	#markerREPEAT 				; repeat marker allocate 4 bytes
		jsr 	RSClaim
		lda 	#1 							; save position at offset 1.
		jsr 	RSSavePosition
		rts

; *****************************************************************************
;
;									UNTIL
;
; *****************************************************************************

Command_Until:	;; [until]
		rscheck markerREPEAT,untilErr 		; check TOS is a REPEAT
		jsr 	EvaluateRootInteger 		; at the bottom.
		jsr 	MInt32Zero					; check if TOS zero
		bne 	_CUExit
		lda 	#1
		jsr 	RSLoadPosition 				; reload the position from offset 1.
		rts
		;
_CUExit:		
		lda 	#4 							; throw 4 bytes from stack.
		jsr 	RSFree 
		rts

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
