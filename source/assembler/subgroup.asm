; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		subgroup.asm
;		Purpose:	Handle the five sub-sections
;		Created:	15th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section 	code

; ************************************************************************************************
;
;											Group 1
;
;	Group 1 is the and,adc,sbc,lda,sta group and is perfectly orthogonal except for STA # which
;	does not make sense (and is BIT #)
;
; ************************************************************************************************

AssembleGroup1:
		lda 	asmToken 					; firstly, we throw out STA immediate
		cmp 	#TKW_STA
		bne 	_AG1NotStoreImm
		lda 	asmMode
		cmp 	#AMD_IMM 		
		beq 	AG1ModeError
		;
_AG1NotStoreImm:		
		ldx 	asmMode						; get mode into X.
		lda		AMDOperandSize,X 			; get the size of the operand and push on stack
		pha
		beq 	AG1ModeError 				; if the size is zero, the mode must be Accumulator
		;
		cpx 	#0 							; if the mode is zero, e.g. immediate
		bne 	_AG1NotImmediate
		ldx 	#2 							; then we use offset 2 here. This is how the 6502
_AG1NotImmediate:		 					; does it, rather illogically.
		cpx 	#AMD_ZEROINDX 				; (zero,x) uses slot 0.
		bne 	_AG1NotZX
		ldx 	#0
_AG1NotZX:		
		cpx 	#9 							; anything > 8 fails.
		bcs 	_AG1Fail
		;
		pla 								; restore length
		sta 	tempShort
		clc
		lda 	AMDOffsetFromBase,X 				; get the offset
		adc 	asmBaseOpcode 				; add the base opcode.
		ldx 	tempShort 					; length in X
		jsr 	AsmWriteInstruction 		; output instruction.
		sec
		rts

_AG1Fail:
		clc		
		rts

AG1ModeError:
		.throw 	Assembler

;
;		Operand size of each mode (unmodified)
;
AMDOperandSize:
		.byte 	1,1,0,2
		.byte 	1,1,2,2
		.byte 	1,1,2,2
		.byte 	1,1
;
;		Offset for each mode (unmodified) (after 8, which is (ZP,X) all are for specific cases)
;
AMDOffsetFromBase:
		.byte 	0,4,8,12
		.byte	16,20,24,28
		.byte 	17,0,0,0
		.byte 	0,0

; ************************************************************************************************
;
;											Group 2
;
;	Group 2 are most of the rest with an operand - LDX INC ROL and so on. They follow a standard
;	pattern closely but not all address mode variations are present for these instructions.
;	(the main variation is that LDX and STX indexing uses Y not X)
;
;	A table (Group2OpcodeAvailability) uses bits to indicate which mode is available for each
; 	token.
;
; ************************************************************************************************

AssembleGroup2:
		.debug
		clc
		rts

; ************************************************************************************************
;
;											Group 3
;
;		Group 3 are the branch operations, which are all identical (to the assembler !)
;
; ************************************************************************************************

AssembleGroup3:
		lda 	SingleLetterVar+("O"-"A")*4	; check bit 0 (pass) of O
		lsr 	a
		lda 	#0 							; if clear, e.g. pass 1, use default zero.
		bcc 	_AG3Default
		sec	 								; calculate branch offset
		lda		esInt0 			
		sbc 	SingleLetterVar+("P"-"A")*4
		tax
		lda		esInt1
		sbc 	SingleLetterVar+("P"-"A")*4+1
		sta 	esInt1					
		;
		txa 								; add 126, now 128 too many.
		clc 								; we can use this to check the range
		adc 	#126
		sta 	esInt0
		bcc 	_AG3NoCarry
		inc 	esInt1
_AG3NoCarry:
		lda 	esInt1 						; check in range.
		bne 	_AG3Range
		lda 	esInt0 						; fix up branch distance
		sec
		sbc 	#128
_AG3Default:
		sta 	esInt0		
_AG3ExitOk:		
		ldx 	#1 							; one opcode, use AG4 Code
		bne 	AG4Write
_AG3Range:
		.throw 	Branch

; ************************************************************************************************
;
;											Group 4
;
;		Group 4 are the stand alone opcodes.
;
; ************************************************************************************************

AssembleGroup4:
		ldx 	#0 							; no parameters in the opcode.
AG4Write:		
		lda 	asmBaseOpcode				; the opcode is the opcode base.
		jsr 	AsmWriteInstruction 		; output instruction.
		sec
		rts

; ************************************************************************************************
;
;										Group 5 / Specials
;
;		These are the special cases. It is a table (AssemblerSpecialCases) of token/mode/opcode
;		triplets, one for each case where the opcode does not fit the pattern. This either the
;		LDX/STX indices, oddities like jmp (aaaa,x) or opcodes like STZ which were added to the
;		65C02 and cannot use the standard pattern.
;
; ************************************************************************************************

AssembleSpecialCase:
		.debug
		clc
		rts

		.send 	code		


