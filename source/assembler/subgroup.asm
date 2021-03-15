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
		.debug
		clc
		rts

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
		.debug
		clc
		rts

; ************************************************************************************************
;
;											Group 4
;
;		Group 4 are the stand alone opcodes.
;
; ************************************************************************************************

AssembleGroup4:
		lda 	asmBaseOpcode				; the opcode is the opcode base.
		ldx 	#0 							; no parameters in the opcode.
		jsr 	AsmWriteInstruction 		; output instruction.
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


