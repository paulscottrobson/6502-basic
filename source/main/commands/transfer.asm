; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		transfer.asm
;		Purpose:	GOTO GOSUB and RETURN (compatibility only)
;		Created:	28th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
	
		.section code

; ************************************************************************************************
;
;									GOSUB command
;
; ************************************************************************************************

CommandGOSUB:	;; [gosub]
		jsr 	EvaluateRootInteger			; get GOSUB line on stack top.
		ldx 	#4 							; allocate 4 bytes on stack for GOSUB
		lda 	#markerGOSUB  				; <marker> <return addr/offset>
		jsr 	RSClaim

		lda 	#1 							; save position at offset 1.
		jsr 	RSSavePosition
		ldx 	#0 							; point back at GOSUB line
		beq 	GotoTOS 					; and do a GOTO there.

; ************************************************************************************************
;
;										RETURN command
;
; ************************************************************************************************

CommandRETURN:	;; [return]
		rscheck markerGOSUB,returnErr 		; check TOS is a GOSUB
		lda 	#1
		jsr 	RSLoadPosition 				; reload the position from offset 1.
		lda 	#4 							; throw 4 bytes from stack.
		jsr 	RSFree 
		rts

; ************************************************************************************************
;
;										GOTO command
;
; ************************************************************************************************

CommandGOTO:	;; [goto]
		jsr 	EvaluateRootInteger 		; get GOTO line on stack top.
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
