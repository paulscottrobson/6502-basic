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
		jmp 	Unimplemented

		.send code
