; *****************************************************************************
; *****************************************************************************
;
;		Name:		while.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		1st March 2021
;		Purpose:	While/Wend
;
; *****************************************************************************
; *****************************************************************************

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
		jsr 	EvaluateInteger				; get the conditional
		jsr 	MInt32Zero 	 				; if zero, skip forward.
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
