; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		detokenise.asm
;		Purpose:	Detokenise/List a line.
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

deTokeniseVector:
		.fill 	2

lastCharacterClass:			; 0 identifier or constant 1 punctuation or string.
		.fill 	1

		.send storage

		.section code		
		
; ************************************************************************************************
;
;									List Line at (codePtr),y
;
; ************************************************************************************************

ListLine: ;; <list>
		set16 	deTokeniseVector,deTokenPrint
Detokenise: ;; <detokenise>	
		lda 	#$FF 					; last thing printed is a dummy value.
		sta 	lastCharacterClass
		;
		;		Print the line number.
		;
		ldx 	#2 						
		jsr 	MInt32False
		ldy 	#1 						; copy line number to stack,2 (as using stack 0,1)
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
		lda 	#" "
		jsr 	ListOutputCharacter
		inx
		cpx 	#6
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

_DTNotEnd:
		cmp 	#0
		bmi 	_DTIsToken
		cmp 	#$40
		bcc 	_DTIsIdentifier
		lda 	#10 					; this is the base
		bne 	_DTConstant
		;
		;		Hex constant
		;	
_DTHexConstant:
		lda 	#"&"
		jsr 	ListOutputCharacter
		iny
		lda 	#16		
		;
		;		Handle constant base X.
		;		
_DTConstant:
		pha
		lda 	#0 							; now constant, may need spaces
		jsr 	DTSwitchMode
		settype LTYConstant
		ldx 	#2
		txa
		.main_evaluateterm
		tax
		jsr 	TOSToTemp0
		pla
		sta 	tempShort
		.pshy
		lda 	tempShort
		jsr 	DTPrintInteger
		.puly
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
		jsr 	TOSToTemp0
		jsr 	DTPrintLengthPrefix
		lda 	#'"'
		jsr 	ListOutputCharacter
		jmp 	_DTListLoop		
		;
		;		Inline float (TODO)
		;
_DTIsFloat:
		.debug
		jmp 	_DTIsFloat
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

