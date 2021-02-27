; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		run.asm
;		Purpose:	Main Run Program
;		Created:	26th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;											RUN command
;
; ************************************************************************************************

Command_Run: 	;; [run]
		ldx 	#$FF
		txs
		jsr 	CommandClear 				; clear everything.
		jsr 	ResetCodeAddress
		ldy 	#3
		;
		;		Come here to do next instruction.
		;
CRNextInstruction:
		StringSoftReset 					; reset the soft string pointer.
		lda 	(codePtr),y 				; get next token.
		bpl 	_CRNotToken
		cmp 	#TOK_TOKENS 				; if in the tokens then do that token.
		bcs 	_CRExecute
		cmp 	#TOK_BINARYST 				; if one of the system tokens $80-$85 do that
		bcs 	Unimplemented 				; else not implemented.
		;
		;		Execute token A
		;
_CRExecute:
		iny 								; consume it.
		asl 	a 							; double it, losing most significant bit.
		tax
		jsr 	_CRRunRoutine 				; we want to do jsr (group0vectors,x)
		jmp 	CRNextInstruction
_CRRunRoutine:		
		jmp 	(Group0Vectors,x) 		
		;
		;		First element is an integer or an identifier.
		;
_CRNotToken:
		debug		

; ************************************************************************************************
;
;								   Handle $81 and $82 shifts
;
; ************************************************************************************************

shifter .macro
		lda 	(codePtr),y 				; get shifted value		
		bpl 	Unimplemented 				; we have an error as this should not happen.
		asl 	a 							; double into X
		tax
		iny 								; advance over it.
		jsr 	_RunIt 						; we have no jsr (aaaa,X)
		jmp 	CRNextInstruction
_RunIt:		
		jmp 	(\1-6*2,x) 					; and do the code.	
		.endm

CommandShift1:	;; [[[SH1]]]
		shifter Group1Vectors			

CommandShift2:	;; [[[SH2]]]
		shifter Group2Vectors	

; ************************************************************************************************
;
;									: handler -it's ignored
;
; ************************************************************************************************

CommandColon:	;; [:]
		rts

; ************************************************************************************************
;
;								Reset (codePtr),y to first line
;
; ************************************************************************************************

ResetCodeAddress:
		lda 	basePage 					; copy basePage to code Pointer
		sta 	codePtr
		lda 	basePage+1
		sta 	codePtr+1
		ldy 	#3 							; offset after offset link and line#
		rts

; ************************************************************************************************
;
;					Code called when non-implemented token/keyword appears
;
; ************************************************************************************************

Unimplemented:
		debug
		jmp 	Unimplemented

		.include "../../generated/tokenvectors0.inc"
		.include "../../generated/tokenvectors1.inc"
		.include "../../generated/tokenvectors2.inc"

		.send code
