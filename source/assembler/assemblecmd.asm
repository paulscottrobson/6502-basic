; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		assemblecmd.asm
;		Purpose:	Assembler instruction handler
;		Created:	14th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

asmToken:									; token of current instruction (not OPCODE)
		.fill 	1
asmMode: 									; current assembler mode. The operand is held in
		.fill 	1 							; esInt0/1

asmBaseOpcode:								; base opcode.
		.fill 	1

		.send 	storage

		.section code	

; ************************************************************************************************
;
;						Assemble instruction in A, rest is (codePtr),y
;
; ************************************************************************************************

AssembleOneInstruction:	;; <assemble>
		sta 	asmToken 					; save the token
		;
		tax
		lda 	OpcodeTable-TKA_GROUP1,x 	; get the base opcode.
		sta 	asmBaseOpcode
		;
		jsr 	AsmGetOperand 				; identify the address mode and operand where applicable.
		sta 	asmMode
		;
		lda 	esInt1 						; check if this is a three byte operand.
		bne 	_AOIThreeBytes 				; if so, we have to use three byte, can't try zp before abs
		;
		jsr 	AssembleAttempt 			; try to assemble token/mode/operand (2 bytes)
		bcs 	_AOISuccess 				; worked ok.
		;
_AOIThreeBytes:		
		ldx 	asmMode 					; convert mode to 3 byte version, where possible.
		lda 	AbsoluteVersionTable,x
		bmi 	_AOIError					; not possible, no equivalent.
		sta 	asmMode
		;
		jsr 	AssembleAttempt 			; try to assemble token/mode/operand (3 bytes)
		bcc 	_AOIError 					; didn't work.
_AOISuccess:		
		rts

_AOIError:
		.throw 	Assembler		

; ************************************************************************************************
;
;				Try to assemble token/mode as is with value (already checked)
;					 If successful return CS, if can't be done return CC
;
; ************************************************************************************************

AssembleAttempt:
		jsr 	_AADispatch 				; go to the code which dispatches to the appropriate
											; handler.
		bcs 	_AAExit 					; exit if carry set, e.g. was successful
		jsr 	AssembleSpecialCase
_AAExit:
		rts													

_AADispatch:		
		lda 	asmToken
		cmp 	#TKA_GROUP4
		bcs 	_AAGroup4
		cmp 	#TKA_GROUP3
		bcs 	_AAGroup3
		cmp 	#TKA_GROUP2
		bcs 	_AAGroup2
		jmp 	AssembleGroup1
_AAGroup2:
		jmp 	AssembleGroup2
_AAGroup3:
		jmp 	AssembleGroup3
_AAGroup4:
		jmp 	AssembleGroup4

; ************************************************************************************************
;
;		The assembler initally tries to do a zero page version of the instruction. If it 
;		cannot, it uses this table to try the absolute equivalent
;
; ************************************************************************************************

AbsoluteVersionTable:
		.byte	$FF 			; fail AMD_IMM	
		.byte	AMD_ABS 		; absolute AMD_ZERO 
		.byte	$FF 			; fail AMD_ACCIMP
		.byte	$FF 			; fail AMD_ABS 
		.byte 	$FF 			; fail AMD_ZEROINDY
		.byte	AMD_ABSX 		; absolute AMD_ZEROX 
		.byte	$FF 			; fail AMD_ABSY 
		.byte	$FF 			; fail AMD_ABSX 
		.byte	AMD_ABSIND 		; absolute AMD_ZEROIND
		.byte	AMD_ABSY 		; absolute AMD_ZEROY 
		.byte	$FF 			; fail AMD_ABSIND 
		.byte	$FF 			; fail AMD_ABSINDX
		.byte	$FF 			; fail AMD_REL	
		.byte 	AMD_ABSINDX 	; absolute AMD_ZEROINDX

; ************************************************************************************************
;
;							Generated tables used by assembler
;
; ************************************************************************************************

		.include "../generated/asmtables.inc"
		.send 	code		
