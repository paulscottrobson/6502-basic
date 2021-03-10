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
		.debug		
		lda 	#$EE
		.send 	code