; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		assemblecmd.asm
;		Purpose:	Assembler instruction handler
;		Created:	14th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

asmToken:									; token of current instruction (not OPCODE)
		.fill 	1
asmMode: 									; current assembler mode. The operand is held in
		.fill 	1 							; esInt0/1

		.send 	storage

		.section code	

; ************************************************************************************************
;
;						Assemble instruction in A, rest is (codePtr),y
;
; ************************************************************************************************

AssembleOneInstruction:	;; <assemble>
		sta 	asmToken
		jsr 	AsmGetOperand 				; identify the address mode and operand where applicable.
		sta 	asmMode
		.debug
		rts

; ************************************************************************************************
;
;							Generated tables used by assembler
;
; ************************************************************************************************

		.include "../generated/asmtables.inc"
		.send 	code		


