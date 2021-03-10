; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokenise.asm
;		Purpose:	Tokenise a string
;		Created:	8th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
tokenHeader: 								; bytes (all zero) to create a fake 'program line'
		.fill 	3
tokenBuffer:								; token buffer.
		.fill 	256
tokenBufferIndex:							; count of characters in buffer.
		.fill 	1

		.send 	storage
			
		.section code

; ************************************************************************************************
;
;					Tokenise string at (codePtr) into tokenising buffer
;								CS if tokenising successful.
;
; ************************************************************************************************

Tokenise: ;; <tokenise>
		jsr 	TokeniseMakeASCIIZ 			; convert to ASCIIZ string.
TokeniseASCIIZ: ;; <tokenisez>
		jsr 	TokeniseFixCase 			; remove controls and lower case outside quotes.
		lda 	#0 							; reset the token buffer index
		sta 	tokenBufferIndex
		tay 								; start pointer
		lda 	#$80 						; empty token buffer ($80 ends it)
		sta 	tokenBuffer
		;
		;		Main tokenisation loop
		;
_TokLoop:
		lda 	(codePtr),y 				; get next character
		beq 	_TokExit 					; if zero, then exit.	
		iny 								; skip over spaces.
		cmp 	#" "
		beq 	_TokLoop
		dey 								; point back to character.
		cmp 	#"&"						; Hexadecimal constant.
		beq 	_TokHexConst
		cmp 	#'"'						; Quoted String
		beq 	_TokQString
		cmp 	#"Z"+1 						; > 'Z' is punctuation
		bcs 	_TokPunctuation
		cmp 	#"A" 						; A..Z identifier
		bcs 	_TokIdentifier
		cmp 	#"9"+1
		bcs 	_TokPunctuation 			; between 9 and A exclusive, punctuation
		cmp 	#"0"
		bcc 	_TokPunctuation 			; < 0, punctuation.
		lda 	#10  						; 0..9 constant in base 10.
		bne 	_TokConst
		;
		;		Handle hexadecimal constant.
		;
_TokHexConst:		
		iny									; consume token.
		lda 	#TKW_AMP 					; Write ampersand token out
		jsr 	TokenWrite
		lda 	#16 
		;
		;		Handle constant in base A
		;
_TokConst:
		jsr 	TokeniseInteger
		bcs 	_TokLoop
		bcc 	_TokFail
		;
		;		Quoted string
		;
_TokQString:
		jsr 	TokeniseString				
		bcs 	_TokLoop
		bcc 	_TokFail
		;
		;		Punctuation token.
		;
_TokPunctuation:
		jsr 	TokenisePunctuation
		bcs 	_TokLoop
		bcc 	_TokFail
		;
		;		Identifier or text token
		;
_TokIdentifier:
		jsr 	TokeniseIdentifier
		bcs 	_TokLoop
		bcc 	_TokFail

_TokExit:		
		sec
		rts

_TokFail:
		clc
		rts

; ************************************************************************************************
;
;								Write A to tokenise buffer
;
; ************************************************************************************************

TokenWrite:
		sta 	tempShort 					; save XA
		pha
		.pshx
		lda 	tempShort
		ldx 	tokenBufferIndex 			; geet index
		sta 	tokenBuffer,x 				; write byte to buffer
		lda 	#TOK_EOL 					; pre-emptively write EOL marker after
		sta 	tokenBuffer+1,x
		inc 	tokenBufferIndex 			; bump index
		.pulx
		pla
		rts

; ************************************************************************************************
;
;							Make string at (codePtr) ASCIIZ
;
; ************************************************************************************************

TokeniseMakeASCIIZ:
		ldy 	#0							; get length of string.
		lda 	(codePtr),y
		tay
		iny 								; +1, the NULL goes here.
		lda 	#0							
		sta 	(codePtr),y 				; write the trailing NULL.
		inc 	codePtr 					; bump the pointer.
		bne 	_TMKAExit
		inc 	codePtr+1
_TMKAExit:		
		rts

; ************************************************************************************************
;
;				Make upper case and remove controls for everything outside quotes.
;
; ************************************************************************************************

TokeniseFixCase:
		ldy 	#0 							; position in buffer.
		ldx 	#1 							; bit 0 of this is 'in quotes'
_TFCFlipQ:		
		txa
		eor 	#1
		tax
_TFCLoop:
		lda 	(codePtr),y 				; get character
		beq 	_TFCExit 					; if zero exit.
		cmp 	#32 						; if control
		bcc 	_TFCControl		
		iny 								; preconsume
		cmp 	#'"'
		beq 	_TFCFlipQ
		cmp 	#"a"						; check if L/C
		bcc 	_TFCLoop
		cmp 	#"z"+1
		bcs 	_TFCLoop
		;
		cpx 	#0 							; in quotes, if so, leave alone.
		bne 	_TFCLoop
		dey
		eor 	#"A"^"a"					; make U/C
_TFCWrite:		
		sta 	(codePtr),y
		iny
		jmp 	_TFCLoop
		;
_TFCControl:
		lda 	#" "
		bne 	_TFCWrite
_TFCExit:
		rts

		.send code
