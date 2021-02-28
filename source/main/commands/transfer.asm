; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		transfer.asm
;		Purpose:	GOTO GOSUB and RETURN (compatibility only)
;		Created:	28h February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
	
		.section code

; ************************************************************************************************
;
;										GOTO command
;
; ************************************************************************************************

CommandGOTO:	;; [goto]
		jsr 	EvaluateRoot 				; get GOTO line from stack top.
		;
		;		GOTO tos
		;
GotoTOS:
		jsr 	ResetCodeAddress 			; simple search.
_GotoSearch:
		ldy 	#0 							; get offset
		lda 	(codePtr),y
		beq 	_GotoError 					; not found.
		;
		iny									; check LSB match
		lda 	(codePtr),y
		cmp 	esInt0,x
		bne 	_GotoNext 		
		;
		iny
		lda 	(codePtr),y
		cmp 	esInt1,x
		beq 	_GotoFound
		;
_GotoNext:	
		ldy 	#0 							; go next line
		lda 	(codePtr),y		
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_GotoSearch
		inc 	codePtr+1
		jmp 	_GotoSearch
		;
_GotoFound:
		ldy 	#3 							; continue from that line
		rts		

_GotoError:
		error 	LineNumber

		.send code
