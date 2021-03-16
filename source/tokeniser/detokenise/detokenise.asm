; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		detokenise.asm
;		Purpose:	Detokenise/List a line.
;		Created:	7th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

deTokeniseVector:
		.fill 	2

lastCharacterClass:			; 0 identifier or constant 1 punctuation or string.
		.fill 	1

indent: 					; current indent total including line #
		.fill 	1
		.send storage

		.section code		
		
; ************************************************************************************************
;
;							List Line at (codePtr),y indent A
;
; ************************************************************************************************

ListLine: ;; <list>
		pha								; enter here to list to console. sets the output vector
		set16 	deTokeniseVector,deTokenPrint
		pla
Detokenise: ;; <detokenise>	
		clc 							; space required for line number.
		adc 	#6
		sta 	indent
		lda 	#$FF 					; last thing printed is a dummy value.
		sta 	lastCharacterClass
		;
		;		Print the line number.
		;
		ldx 	#2 						
		jsr 	MInt32False
		ldy 	#1 						; copy line number to stack,2 (as using stack 0,1 for list range)
		lda 	(codePtr),y
		sta 	esInt0,x
		iny
		lda 	(codePtr),y
		sta 	esInt1,x
		setType LTYLineNumber		
		lda 	#10 					; base 10
		jsr 	DTPrintInteger 			; print as integer.
		ldy 	#0 						; get length
		lda 	(temp0),y 				; into X
		tax
_DTPadOut:
		lda 	#" " 					; pad out to indent.
		jsr 	ListOutputCharacter
		inx
		cpx 	indent
		bne 	_DTPadOut		
		ldy 	#3 						; start position.
		;
		;		Main listing loop
		;
_DTListLoop		
		lda 	(codePtr),y
		cmp 	#TOK_STR 				; Inline string.
		beq 	_DTIsString
		cmp 	#TOK_FPC 				; Floating point
		beq 	_DTIsFloat
		cmp 	#TKW_AMP 				; & hex marker
		beq 	_DTHexConstant 			
		cmp 	#TOK_EOL 				; End of Line
		bne 	_DTNotEnd
		lda 	#255 					; print CR
		jsr 	ListOutputCharacter
		rts
		;
		;		Dispatch token (-ve) identifier (0-3F) number (40-7F)
		;
_DTNotEnd:
		cmp 	#0
		bmi 	_DTIsToken
		cmp 	#$40
		bcc 	_DTIsIdentifier
		lda 	#10 					; this is the base, unsigned decimal
		bne 	_DTConstant
		;
		;		Hex constant
		;	
_DTHexConstant:
		lda 	#"&"
		jsr 	ListOutputCharacter
		iny
		lda 	#1 						; switch to spaces so &xxxx is treated like a number.
		jsr 	DTSwitchMode
		lda 	#16						; print line unsigned hex
		;
		;		Handle constant base A.
		;		
_DTConstant:
		pha
		lda 	#0 						; now constant, may need spaces
		jsr 	DTSwitchMode
		settype LTYConstant 			; set display type
		ldx 	#2 						; get its value
		txa
		.main_evaluateterm
		tax
		pla 							; get base back
		sta 	tempShort 				
		.pshy 							; save Y
		lda 	tempShort 				; print in base A stck level X
		jsr 	DTPrintInteger
		.puly 							; restore Y and go round.
		jmp 	_DTListLoop
		;
		;		Handle token, could be punctuation or text.
		;
_DTIsToken:		
		jsr 	DTDecodeToken
		jmp 	_DTListLoop
		;
		;		Display identifier.
		;
_DTIsIdentifier:
		jsr 	DTIdentifier
		jmp 	_DTListLoop
		;
		;		Inline float (TODO)
		;
_DTIsFloat:
		.debug
		jmp 	_DTIsFloat
		;
		;		Inline string.
		;
_DTIsString:
		lda 	#1 							; now punctuation, may need spaces
		jsr 	DTSwitchMode
		settype LTYString
		lda 	#'"'						; open quote
		jsr 	ListOutputCharacter
		ldx 	#2 							; evaluate string to TOS2.
		txa
		.main_evaluateterm
		tax

		lda 	esInt0,x 					; copy string address to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1

		lda 	#0 							; don't capitalise.
		jsr 	DTPrintLengthPrefix
		lda 	#'"'
		jsr 	ListOutputCharacter
		jmp 	_DTListLoop		
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

