; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		evaluate.asm
;		Purpose:	Main evaluation code
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;					Evaluate at stack level 'X', from precedence level 'A'
;
; ************************************************************************************************

EvaluateLevel:
		pha 								; save precedence level.
		;
		lda 	#0 							; zero the current stack level.
		sta 	esInt0,x
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		sta 	esType,x 					; zero the type (integer value)
		;
		lda 	(codePtr),y	 				; look at first token/character
		bmi 	_ELIsToken 					; if -ve could be string, float, or unary function.
		asl 	a 							; if 00-3F then will now be PL and it's a variable.
		bmi 	_ELIsConstant 				; 40-7F will be -ve and that's an integer constant.
		;
		;		Found a variable.
		;
		txa 								; stack level in X
		variable_access  					; access the variable reference.
		tax
		jmp		_ELHasTerm 	
		;
		;		Found a constant.
		;
_ELIsConstant:
		lsr 	a 							; get the value back
		and 	#$3F 						; force into range 0-63
		sta 	esInt0,x 					; and put in LSB. 
_ELCheckNext:
		iny 								; look at next
		lda 	(codePtr),y
		eor 	#$40 						; shift around so 40-7F => 00-3F
		cmp 	#$40 						; out of range ?
		bcs 	_ELHasTerm 					; done getting the constant.
		jsr 	ELShiftByteIn 				; shift byte into position.
		jmp 	_ELCheckNext
		;
		;		Found a token.
		;
_ELIsToken:
		cmp 	#TOK_STR 					; handle strings.
		beq 	_ELIsString
		cmp 	#TOK_FPC 					; if no, then check unary.
		bne 	_ELCheckUnary
		txa 								; put X into A
		iny 								; skip over the float marker
		floatingpoint_importtoken 			; import tokenise floating point
		tax 								; restore X
		jmp 	_ELHasTerm
		;
		;		Found a string
		;
_ELIsString:
		tya 								; address of string is codePtr+y+1
		sec
		adc 	codePtr
		sta 	esInt0,x
		lda 	codePtr+1
		adc 	#0
		sta 	esInt1,x
		lda 	#$40 						; set type to string value
		sta 	esType,x
		;
		;
		iny 								; skip over string.
		tya
		sec									; +1 for the length itself.
		adc 	(codePtr),y
		tay 								; and fall through to term loop code.
		;
		;		Main loop, we now have a left hand term. Precedence level is still on the stack.
		;
_ELHasTerm:
		lda 	(codePtr),y
		cmp 	#TOK_BINARYST 				; check in the correct range for binary tokens.
		bcc 	_ELPopExit
		cmp 	#TOK_STRUCTST 	
		bcc 	_ELHasBinaryTerm 			
_ELPopExit: 								; throw the precedence level and exit
		pla
_ELExit: 									; exit having thrown precedence.
		rts				
		;
		;		Have a binary operator, now check the precedence.
		;
_ELHasBinaryTerm:
		sty 	tempShort 					; save position
		tay 								; use token as an index and get the precedence.
		lda 	ELBinaryOperatorInfo-TOK_BINARYST,y
		ldy 	tempShort 					; restore Y
		;
		sta 	tempShort 					; save precedence in memory.
		;
		pla 								; restore current level.
		cmp 	tempShort 					; if current >= operator then exit
		bcs 	_ELExit
		;
		pha 								; save current level back on the stack.
		lda 	(codePtr),y 				; save the binary operator on the stack and skip it.
		pha
		iny
		;
		inx 								; calculate the RHS at the operator precedence.
		lda 	tempShort 
		jsr 	EvaluateLevel 				
		dex
		;
		pla 								; get the operator back out.
		;
		;		Now execute the operation at A
		;
		stx 	tempShort 					; upload the vectors. Would be nice to use jmp (aaaa,x)
		asl 	a 							; but not practical. May use push/rts later.
		tax
		lda 	Group0Vectors,x
		sta 	temp0
		lda 	Group0Vectors+1,x
		sta 	temp0+1
		ldx 	tempShort
		;
		jsr 	_ELCallTemp0
		;
		jmp 	_ELHasTerm 					; and loop back round.
		;
		;		Could be a unary function, or ! ? - which are dual purpose.
		;
_ELCheckUnary:		



_ELCallTemp0:
		jmp 	(temp0)

; ************************************************************************************************
;
;					Shift a 6 bit value into the current stack level.
;
; ************************************************************************************************

ELShiftByteIn:
		pha 								; save bits to shift in.
		lda 	esInt3,x 					; save top most byte 
		pha
		;
		lda 	esInt2,x 					; shift everything left 8 bits
		sta 	esInt3,x
		lda 	esInt1,x
		sta 	esInt2,x
		lda 	esInt0,x
		sta 	esInt1,x
		lda 	#0
		sta 	esInt0,x
		;
		pla 								; now A:TOS is a 5 byte register, shift right twice.
		and 	#3 							; only want lower 2 bits
		ora 	#4  						; set bit 2 - when 1 we are done
		;
_ELShiftLoop:		
		lsr 	a
		ror 	esInt3,x
		ror 	esInt2,x
		ror 	esInt1,x
		ror 	esInt0,x
		cmp 	#1
		bne 	_ELShiftLoop
		;
		pla 								; get original 6 bit value and OR in.
		and 	#$3F
		ora 	esInt0,x
		sta 	esInt0,x
		rts


ELBinaryOperatorInfo:
		.include "../../generated/binarystructinfo.inc"
