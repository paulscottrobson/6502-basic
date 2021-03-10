; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		warm.asm
;		Purpose:	Warm start
;		Created:	10th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

WarmStartEntry:	;; <warmstart>
		ldx 	#$FF
		txs
		lda 	#2							; green text.
		.device_ink
		.device_inputline					; input line, put address in temp0
		;
		lda 	temp0	 					; copy temp0 to codePtr
		sta 	codePtr
		lda 	temp0+1
		sta 	codePtr+1
		;
		.device_crlf
		;
		.tokeniser_tokenise 				; tokenise the line.
		bcc 	WSEError 					; failed.
		;
		set16 	codePtr,tokenHeader 		; set the exec pointer to the token buffer.
		;
		lda 	tokenBuffer 				; is it a blank line, go get another line.
		cmp 	#$80
		beq 	WarmStartEntry 				
		and 	#$C0						; does it start with a number
		cmp 	#$40
		beq 	HasLineNumber
		;
		lda 	#0 							; zero the token header, so it will look like a
		sta 	tokenHeader 				; fake program line.
		sta 	tokenHeader+1
		sta 	tokenHeader+2

		.main_runfrom 						; run code at (codePtr), which will end because 
											; it will have an offset $00, causing END
											; and then a new warm start.

WSEError:
		error 	Tokenise

		;
		;		Line Number prefixes the line.
		;											
HasLineNumber:
		ldy 	#3 							; get line number
		ldx 	#0
		jsr 	EvaluateInteger
		lda 	esInt2		 				; check in range.
		ora 	esInt3
		bne 	WSEError
		;
		tya 								; make codePtr point to code after the line number.
		clc
		adc 	codePtr
		sta 	codePtr
		bcc		_HLNNoCarry
		inc 	codePtr+1
_HLNNoCarry:		
		tya 								; subtract that offset from the code buffer index
		sec
		eor 	#$FF
		adc 	tokenBufferIndex
		clc 								; add space allowing for header & $80 trailer
		adc 	#4
		sta 	tokenBufferIndex 			; this is the number of bytes occupied.
		jsr 	DeleteLine 					; always delete the line, it's deleted and reinserted.
_HLNNoDelete:	
		lda 	tokenBufferIndex 			; if line was empty, then don't insert
		cmp 	#1 							; (the one character is the EOL marker)
		beq 	_HLMEditDone
		jsr 	InsertLine 					; insert the line in
_HLMEditDone:
		jsr 	CommandClear 				; clear all variables etc.
		jmp 	WarmStartEntry		

		.send 	code

