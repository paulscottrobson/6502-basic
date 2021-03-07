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
		
LTYLineNumber = $84
LTYPunctuation = $82
LTYIdentifier = $87
LTYConstant = $86
LTYKeyword = $83
LTYString = $81

setType .macro
		lda 	#\1
		jsr 	ListOutputCharacter
		.endm

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

; ************************************************************************************************
;
;								Print integer at TOS,X in base A
;
; ************************************************************************************************

DTPrintInteger:
		pha
		set16 	temp0,convertBuffer
		.puly
		txa
		.main_inttostr
		tax

; ************************************************************************************************
;
;					Print length prefix string at temp0, with bit 7 stripped
;		
; ************************************************************************************************

DTPrintLengthPrefix:
		.pshy
		ldy 	#0
		lda 	(temp0),y
		tax
		beq 	_DTPLPExit
_DTPLPLoop:		
		iny
		lda 	(temp0),y
		and 	#$7F	
		jsr 	ListOutputCharacter
		dex
		bne 	_DTPLPLoop		
_DTPLPExit:	
		.puly			
		rts

; ************************************************************************************************
;
;			Print for listing. Expects CR, ASCII and 1..9 for colour elements
;
; ************************************************************************************************

ListOutputCharacter:
		sta 	tempShort
		pha
		.pshx
		.pshy
		lda 	tempShort
		cmp 	#32
		bcs		_LOCHiBit
		ora 	#64
		cmp 	#64
		beq 	_LOCHiBit
		cmp 	#65+26
		bcs 	_LOCHiBit
		adc 	#32
_LOCHiBit:				
		jsr 	_LOCCallVector
		.puly
		.pulx
		pla
_LOCExit:		
		rts
_LOCCallVector:
		jmp 	(deTokeniseVector)

; ************************************************************************************************
;
;						Printer for list to output device
;
; ************************************************************************************************

deTokenPrint:
		cmp 	#0
		bmi 	_dtpInk
		.device_print
		rts
_dtpInk:cmp 	#255
		beq 	_dtpCR
		and 	#7
		.device_ink
		rts
_dtpCR:	.device_crlf
		rts		

; ************************************************************************************************
;
;					Decode token at (codePtr),y, may be shifted.
;
; ************************************************************************************************

DTDecodeToken:
		;
		;		Identify if shift $81..83 and select correct table to use.
		;
		ldx 	#0 							; table number to use
		lda 	(codePtr),y
		cmp 	#$84 				
		bcs 	_DTNotShift
		and 	#3 							; get the shift 1..3
		asl 	a 							; put 2 x in X
		tax
		iny
_DTNotShift:
		lda 	TokenTableAddress,x 		; get the token table to use to decode it.
		sta 	temp0 						; point into temp0
		lda 	TokenTableAddress+1,x 
		sta 	temp0+1
		;
		;		Get the token into X
		;	
		lda 	(codePtr),y 				; get the token value.
		iny 								; consume it.
		tax
		;
		;		Find the text for this token by working through the table.
		;
		.pshy 								; save Y position.
_DTFindText:
		cpx 	#$86 						; finished ?
		beq 	_DTFoundText
		dex
		;
		ldy 	#0
		sec
		lda 	(temp0),y
		adc 	temp0
		sta 	temp0
		bcc 	_DTFindText
		inc 	temp0+1
		jmp 	_DTFindText
		;
		;		temp0 now points to the text
		;
_DTFoundText:
		ldy 	#1 							; get first character
		lda 	(temp0),y
		beq 	_DTIsPunctuation 
		cmp 	#27
		bcs 	_DTIsPunctuation

		lda 	#0 							; now text, may need spaces
		jsr 	DTSwitchMode
		settype LTYKeyword
		jmp 	_DTPrint
_DTIsPunctuation:		
		lda 	#1 							; now punctuation, may need spaces
		jsr 	DTSwitchMode
		setType LTYPunctuation
_DTPrint:		
		jsr 	DTPrintLengthPrefix 		; print it out.
		.puly
		rts

; ************************************************************************************************
;
;		Switch mode, punctuation or identifier constant, may need space
;
; ************************************************************************************************

DTSwitchMode:
		cmp 	LastCharacterClass
		beq 	_DTSMNoChange
		sta 	LastCharacterClass
_DTSMExit:		
		rts
_DTSMNoChange:
		cmp 	#1
		beq 	_DTSMExit
		lda 	#" "
		jmp 	ListOutputCharacter

; ************************************************************************************************
;
;							Show identifier at (codePtr),y
;
; ************************************************************************************************

DTIdentifier:
		lda 	#0 							; now text, may need spaces
		jsr 	DTSwitchMode
		settype LTYIdentifier
_DTILoop:
		lda 	(codePtr),y 				; output main bit of identifier.
		jsr 	ListOutputCharacter		
		iny
		lda 	(codePtr),y 				; until end identifier marker.
		cmp 	#$3A
		bcc 	_DTILoop
		iny

		cmp 	#$3A 						; is it integer non array
		beq 	_DTIExit 					; no postfix.
		pha
		lda  	#1 							; it ends in punctuation
		sta 	LastCharacterClass
		setType LTYPunctuation
		pla
		cmp 	#$3B
		beq 	_DTIArray

		lsr 	a 							; array flag in C
		php
		eor 	#$3C/2 						; check if $
		beq 	_DTIDollar
		lda 	#"$"^"#" 					; this if #, 0 if $
_DTIDollar:
		eor 	#"$"
		jsr 	ListOutputCharacter
		plp
		bcc 	_DTIExit
_DTIArray:		
		lda 	#"("
		jsr 	ListOutputCharacter
_DTIExit:
		rts

; ************************************************************************************************
;
;										Token text.
;
; ************************************************************************************************

TokenTableAddress:
		.word 	Group0Text
		.word 	Group1Text
		.word 	Group2Text
		.word 	Group3Text

		.include "../generated/tokentext0.inc"
		.include "../generated/tokentext1.inc"
		.include "../generated/tokentext2.inc"
		.include "../generated/tokentext3.inc"

		.send code