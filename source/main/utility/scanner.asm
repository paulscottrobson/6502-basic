; *****************************************************************************
; *****************************************************************************
;
;		Name:		scanner.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		1st March 2021
;		Purpose:	Scan forward to branch over groups.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;					Scan forward looking for token A or X
;
; *****************************************************************************

ScanForward:
		sta 	temp1 						; save tokens to search in temp1/temp1+1
		stx 	temp1+1
		lda 	#0 							; temp2 counts structure levels.
		sta 	temp2 					
		;
		;		Main loop
		;
_SFLoop:lda 	(codePtr),y 				; look at the next token.
		iny 
		ldx 	temp2 						; check structure levels are zero.
		bne 	_SFNoCheck 					; if so, check token against entered values.
		cmp 	temp1
		beq 	_SFExit
		cmp 	temp1+1
		beq 	_SFExit
_SFNoCheck:
		cmp 	#$80 						; if it is 00-7F (variable/number) just skip it.
		bcc 	_SFLoop
		cmp 	#TOK_BINARYST 				; $80-$85 is various specials.
		bcc 	_SFSpecials
		cmp 	#TOK_STRUCTST 				; if < structure start then continue
		bcc 	_SFLoop
		cmp 	#TOK_UNARYST 				; if >= unary start (after structure) then continue.
		bcs 	_SFLoop
		;
		;		Found something in the structure part of the tokens.
		;
		tax  								; token in X, and look up the adjuster.								
		lda 	ELBinaryOperatorInfo-TOK_BINARYST,x
		;
		;		This table is in evaluate.asm as it contains binary operator precedence
		;		and structure data.
		;
		sec 								; convert to an offset
		sbc 	#$81
		clc 								; add to depth
		adc 	temp2
		sta 	temp2
		bpl 	_SFLoop 					; +ve okay to continue
		bmi 	_SFError 					; if gone -ve then we have a nesting error
		;
		;		Done it, so exit.
		;
_SFExit:rts
		;
		;		Skipping specials.
_SFSpecials:
		cmp 	#TOK_EOL 					; $80, advance to next line.
		beq 	_SFNextLine
		cmp 	#TOK_FPC					; $84, skip embedded float
		beq 	_SFFloatSkip
		cmp 	#TOK_STR 					; $85, skip string
		beq 	_SFSkipString
		iny									; $81,$82,$83 shift, so just advance over the shifted
		jmp 	_SFLoop 					; token.
		;
		;		Inline string - advance over it.
		;
_SFSkipString:
		tya
		sec
		adc 	(codePtr),y
		tay
		jmp 	_SFLoop		
		;
		;		End of line.
		;
_SFNextLine:		
		ldy 	#0 							; get offset
		lda 	(codePtr),y
		clc 								; add to code pointer.
		adc 	codePtr
		sta 	codePtr
		bcc		_SFNLNoCarry
		inc 	codePtr+1
_SFNLNoCarry:
		lda 	(codePtr),y 				; reached the end of the program.
		bne		_SFLoop 					; no go round again
		lda 	temp1
		cmp 	#TKW_DATA 					; if searching for Data different error.
		bne 	_SFError
		error 	DataError 				
		;
		;		Structure error
		;
_SFError:
		error 	Struct		
		;
		;		Skip embedded floating point (FP not done yet)
		;
_SFFloatSkip:
		jmp 	Unimplemented

