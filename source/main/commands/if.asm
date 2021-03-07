; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		if.asm
;		Purpose:	Conditional execution
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										If command
;
; ************************************************************************************************

CommandIf: ;; [if]
		jsr 	EvaluateRootInteger 		; if what ?
		;
		lda 	(codePtr),y 				; check for IF .. THEN or IF .. GOTO which are single lines.
		cmp 	#TKW_GOTO
		beq 	_IfSimple
		cmp 	#TKW_THEN
		bne 	_IfComplex
		;
		;		The simple standard single line IF .. THEN or IF .. GOTO
		;
_IfSimple:
		jsr 	MInt32Zero					; check if TOS zero
		beq 	_IfEOL 						; go to next line.

		lda 	(codePtr),y 				; get and skip token.
		iny
		cmp 	#TKW_GOTO 					; was it if GOTO ?
		beq 	_IfGoto 					; do the Goto code
		;
		lda 	(codePtr),y 				; what follows the THEN ?
		and 	#$C0 						; check $40-$7F
		cmp 	#$40 						; e.g. number IF x = 0 THEN 170
		beq 	_IfGoto 					
		;
		rts 								; else continue on this line.

_IfEOL:	
		jmp 	AdvanceNextLine 			; go to next line		
_IfGoto:
		jmp 	CommandGoto

; ************************************************************************************************
;
;								IF .. ELSE .. ENDIF structure
;
; ************************************************************************************************

_IfComplex:
		jsr 	MInt32Zero 					; is it true ?
		beq 	_IFSkip 					; if non-zero then skip to ELSE/ENDIF
		rts 								; else continue.

_IFSkip:
		lda	 	#TKW_ELSE 					; test failed, go to ELSE or ENDIF whichever comes first.
		ldx 	#TKW_ENDIF	
		jmp		ScanForward

;
;		Else is executed after passing a test, and skip forward to ENDIF
;
Command_ELSE:	;; [else]	
		ldx 	#TKW_ENDIF		
		txa
		jmp		ScanForward
	
;
;		ENDIF is just a No-op, it's a marker for the structure end.
;
Command_ENDIF:	;; [endif]
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
