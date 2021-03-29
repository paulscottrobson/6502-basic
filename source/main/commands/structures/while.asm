; *****************************************************************************
; *****************************************************************************
;
;		Name:		while.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		1st March 2021
;		Reviewed: 	7th March 2021
;		Purpose:	While/Wend
;
; *****************************************************************************
; *****************************************************************************

		.section 	code

; *****************************************************************************
;
;									WHILE
;
; *****************************************************************************

Command_While: 	;; [While]
		lda 	#markerWhile 				; gosub marker allocate 4 bytes.
		ldx 	#4
		jsr 	RSClaim 					; create on stack.
		;
		dey
		lda 	#1
		jsr 	RSSavePosition 				; save position before the WHILE keyword.
		iny
		jsr 	EvaluateRootInteger			; get the conditional
		jsr 	MInt32Zero 	 				; if zero, skip forward to the fail code.
		beq 	_CWFail
		rts
		;
_CWFail:
		lda 	#4
		jsr 	RSFree 						; close the just opened position.		
		lda 	#TKW_WEND 					; scan forward past WEND.		
		tax
		jsr 	ScanForward
		rts

; *****************************************************************************
;
;									WEND
;
; *****************************************************************************

Command_Wend:	;; [wend]
		rscheck markerWHILE,wendErr 		; check TOS is a WHILE
		lda 	#1
		jsr 	RSLoadPosition				; go back until true
		lda 	#4
		jsr 	RSFree 						; close the loop
		rts

		.send 	code
		
; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;		29-Mar-21 		Was using EvaluateInteger rather than EvaluateRootInteger and X
;						was set to 4 - worked but wasted half the number stack.
;
; ************************************************************************************************
