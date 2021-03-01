; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		print.asm
;		Purpose:	Print command
;		Created:	1st March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

lastPrintToken: 							; last token before : or EOL
		.fill 	1	

		.send storage

		.section code

; ************************************************************************************************
;
;										Print Command
;
; ************************************************************************************************

Command_Print: ;; [print]
		lda 	#0 							; clear LPT flag
		sta 	lastPrintToken
		dey
_PrintLoopSkip:
		iny		
_PrintLoop:		
		lda 	(codePtr),y 				; what follows
		cmp 	#TOK_EOL  					; done if end of line or colon	
		beq 	_PrintExit
		cmp 	#TKW_COLON
		beq 	_PrintExit
		sta 	lastPrintToken 				; update LPT
		;
		cmp 	#TKW_SEMICOLON 				; ignore semicolon
		beq 	_PrintLoopSkip
		cmp 	#TKW_QUOTE 					; ' is new line
		beq	 	_PrintNewLine
		cmp 	#TKW_COMMA 					; , is print tab
		beq 	_PrintTab
		;
		;		Expression of some sort.
		;
		jsr 	EvaluateRoot 				; evaluate something at the root
		set16 	temp0,convertBuffer 		; where the conversion goes (not strings)
		;
		lda 	esType 						; get type
		beq		_PrintInteger
		lsr 	a 							; check for floating point
		bcs 	_PrintFloat
		;
		;		Print String
		;
_PrintString:
		ldx 	#0 							; bottom string to temp0
		jsr 	WVSetTemp0 					
		jmp 	_PrintTemp0 				; print no leading space.
		;
		;		Print Float
		;
_PrintFloat:
		lda 	#0 							; stack level.
		floatingpoint_floattostring 		; convert to string at (temp0)
		jmp 	_PrintSpaceTemp0		
		;
		;		Print integer
		;
_PrintInteger:
		lda 	#10+$80 					; base 10 signed
		ldx 	#0 							; bottom stack element
		jsr 	MInt32ToString				; convert to text
		;
		;		Print space then (temp0)
		;
_PrintSpaceTemp0:
		lda 	#32
		device_print		
		;
		;		Print (temp0) as leading count string
		;
_PrintTemp0:
		jsr 	PrintString
		jmp 	_PrintLoop
		;		Print new line (')
		;		
_PrintNewLine:
		device_crlf
		jmp 	_PrintLoopSkip
		;
		;		Print tab (,)
		;		
_PrintTab:
		device_tab
		jmp 	_PrintLoopSkip
		;
		;		Exit print		
		;
_PrintExit:
		lda		lastPrintToken 				; check last token
		cmp 	#TKW_SEMICOLON 				; if , or ; do not print NL
		beq 	_PrintExit2
		cmp 	#TKW_COMMA
		beq 	_PrintExit2
		device_crlf
_PrintExit2:
		rts

; ************************************************************************************************
;
;									Print String at temp0
;
; ************************************************************************************************

PrintString:
		pshx
		pshy
		ldy 	#0							; get length
		lda 	(temp0),y
		tax 								; into X
_PSLoop:cpx 	#0 							; finished ?
		beq 	_PSExit
		dex
		pshx
		iny		
		lda 	(temp0),y
		device_print
		pulx
		jmp 	_PSLoop
_PSExit:puly
		pulx
		rts

		.send code
