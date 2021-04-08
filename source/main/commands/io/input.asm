; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		input.asm
;		Purpose:	Input command
;		Created:	7th March 2021
;		Reviewed: 	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

MaxInputSize = 32

		.section Storage
InputBuffer:								; input text goes here.
		.fill 	MaxInputSize+1
		.send Storage
		.section code

; ************************************************************************************************
;
;										Input Command
;
; ************************************************************************************************

Command_Input: 	;; [input]
		lda 	(codePtr),y 			; see what's next.
		iny
		cmp 	#TKW_COMMA 				; ignore commas.
		beq 	Command_Input
		dey 							; undo consume		
		cmp 	#TKW_COLON
		beq 	_CIExit 				; : or EOL, exit
		cmp 	#TOK_EOL
		beq 	_CIExit
		;
		cmp 	#$40 					; variable ?
		bcc 	_CIVariable
		cmp 	#TOK_STR 				; if not quoted string syntax error.
		bne 	_CISyntax
		;
		;		Handle the "prompt" bits.
		;
		ldx 	#0
		jsr 	EvaluateString 			; evaluate and print string
		jsr 	TOSToTemp0
		jsr 	PrintString	
		jmp 	Command_Input
		;
		;		Handle the variable bits. First identify the variable
		;
_CIVariable:
		ldx 	#0 						; evaluate a reference.
		jsr 	EvaluateReference  		; this is where its going
		;
		;		Get some input and try to convert to the write format.
		;
_CIRetry:		
		lda 	#"?"					; print prompt
		.device_print
		.pshy
		jsr 	InputString 			; input a string (manually)
		ldx 	#1
		jsr 	BufferToStackX 			; make stack,x ref input string.
		;
		lda 	esType 					; if target type numeric
		and 	#$40 					; then convert to number
		bne 	_CIWrite

		ldx 	#1
		jsr 	TOSToTemp0 				; string address in temp0, goes here.
		lda 	#10
		;
		jsr 	MInt32FromString 		; convert it back from a string.
		.puly
		bcs 	_CIWrite 				; successfully converted.
		clc 							; default fail FP conversion
		.if installed_floatingpoint == 1
		lda 	#1						; try FP conv if fp installed
		.floatingpoint_stringToFloat 
		.endif
		bcc		_CIRetry				; failed, try again.
		;
		;		If convert successfully write it to the reference.
		;
_CIWrite:
		ldx 	#0
		jsr 	WriteValue		
		jmp 	Command_Input
		
_CISyntax:
		.throw 	Syntax
_CIExit:		
		rts

; ************************************************************************************************
;
;							   Copy input buffer to stack,x as a string
;
; ************************************************************************************************

BufferToStackX:
		lda 	#InputBuffer & $FF
		sta 	esInt0,x
		lda 	#InputBuffer >> 8
		sta 	esInt1,x
		lda 	#0
		sta 	esInt2,x
		sta 	esInt3,x
		lda 	#$40
		sta 	esType,x
		rts

; ************************************************************************************************
;
;								Input string into the buffer.
;
; ************************************************************************************************

InputString:
		lda 	#0
		sta 	InputBuffer
_InputLoop:
		.device_syncbreak
		.device_inkey
		cmp 	#0
		beq 	_InputLoop
		cmp 	#8
		beq 	_InputBackspace
		cmp 	#13
		beq 	_InputExit
		ldx 	InputBuffer
		cpx 	#MaxInputSize 			; too many characters
		beq 	_InputLoop
		sta 	InputBuffer+1,x 		; write char
		inc 	InputBuffer 			; advance count.
_InputPrintLoop:						; echo A and loop back.
		.device_print
		jmp	 	_InputLoop

_InputBackspace:
		lda 	InputBuffer 			; at start
		beq 	_InputLoop
		dec 	InputBuffer
		lda 	#8
		bne 	_InputPrintLoop			

_InputExit:
		.device_crlf
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
;
; ************************************************************************************************
