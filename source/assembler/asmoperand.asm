; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		asmoperand.asm
;		Purpose:	Decode operand
;		Created:	15th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						Get operand from instruction stream, if any => A
;
;		 The mode will be the zero page version where any exists, so no ABS instructions
;		 The assembler tries the 2 byte version if it can, then the 3 byte version of 
;		 instructions if it cannot.
;		
;		Returns:
;			Acc/Implied for no operand or A
;			Immediate for #
;			Zero Zero,X Zero,Y for where just an expression with optional indexing.
;			Zero Ind, Zero IndX or ZeroIndY for indirect operations.
;
; ************************************************************************************************

AsmGetOperand:
		ldx 	#0 							; clear the operand.
		txa
		sta 	esInt0,x
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		
		lda 	(codePtr),y 				; first character into X
		tax
		;
		lda 	#AMD_ACCIMP				
		cpx 	#TOK_EOL 					; if end of line or colon, return implied mode.
		beq 	_AGOExit 					; e.g. "INX"
		cpx 	#TKW_COLON
		beq 	_AGOExit
		;
		iny 								; consume the token
		lda 	#AMD_IMM
		cpx 	#TKW_HASH 					; if a hash present, then immediate mode.
		beq		_AGOEvalExit 				; with an operand.
		;
		cpx 	#TKW_LPAREN 				; left bracket ? so it is lda (something
		beq 	_AGOIndirect
		;
		cpx 	#$01 						; is it "A" e.g. the variable A on its own. This is for ASL A
		bne 	_AGOZeroPage1 				; if not it is zero zero,x zero,y, unpick 1 iny
		;
		lda 	(codePtr),y 				; get the second character & consume it - this should be $3A
		iny
		tax
		lda 	#AMD_ACCIMP 				; and return Acc/Implied if it is just A
		cpx 	#$3A
		beq 	_AGOExit
		dey 								; unpick 2 iny
_AGOZeroPage1:						
		dey
		;
		;		Zero Page, possibly with indexing.
		;
		lda 	#0 							; get the address into esInt0/1 (it may of course be absolute)
		.main_evaluateint		
		jsr 	AsmGetIndexing 				; get ,X or ,Y if present
		lda 	#AMD_ZERO 					
		bcc 	_AGOExit 					; neither present
		lda 	#AMD_ZEROX 					; decide if ,X or ,Y
		cpx 	#0
		beq 	_AGOExit
		lda 	#AMD_ZEROY
		jmp 	_AGOExit
		;
		;		Evaluate and return.
		;
_AGOEvalExit:
		pha
		lda 	#0 							; evaluate operand in root.
		.main_evaluateint		
		pla
		;
		;		Return just the mode.
		;
_AGOExit:
		pha 								; save the mode
		lda 	esInt2 						; check the operand is zero.
		ora 	esInt3
		bne 	_AGOValue
		pla
		rts
_AGOValue:
		.throw 	BadValue		
		;
		;		Indirect found. (nnn) (nnn,X) or (nnn),Y
		;
_AGOIndirect:
		lda 	#0 							; evaluate operand in root.
		.main_evaluateint		
		lda 	(codePtr),y 				; does ) follow ? if so might be ) or ),Y
		cmp 	#TKW_RPAREN
		beq 	_AGOIndIndY
		;
		jsr 	ASMGetIndexing 				; must be ,X) so get the ending and error on anything else.
		bcc 	AGISyntax
		cpx 	#0
		bne 	AGISyntax	
		.main_checkrightparen 				
		lda 	#AMD_ZEROINDX 
		rts
		;
_AGOIndIndY:								; either (xxx) or (xxx),Y
		iny		
		jsr 	ASMGetIndexing 				; get indexing if any
		lda 	#AMD_ZEROIND 				
		bcc 	_AGOExit 					; none then exit
		cpx 	#0 							; must be ,Y
		beq 	AGISyntax
		lda 	#AMD_ZEROINDY
		jmp 	_AGOExit

; ************************************************************************************************
;
;		Get and consume any indexing. Returns CC if no indexing. X=0 for X indexing 
;		and X=1 for Y indexing
;
; ************************************************************************************************

AsmGetIndexing:
		lda 	(codePtr),y 				; check for comma (e.g. ,X ,Y)
		cmp 	#TKW_COMMA
		clc
		bne 	_AGIExit 					; no comma, return with CC
		;
		iny 								; get what SHOULD be X or Y
		lda 	(codePtr),y  				; read it
		sec 								; subtract 6 bit ASCII of X
		sbc 	#"X" & $3F
		cmp 	#2 							; if unsigned >= 2 then error
		bcs 	AGISyntax
		tax 								; put in index
		iny 								; get what follows that, should be the $3A marker
		lda 	(codePtr),y
		iny
		cmp 	#$3A
		bne 	AGISyntax
		sec 								; return CS and index mode in X
_AGIExit:	
		rts

AGISyntax:
		.throw	 syntax

		.send 	code		
