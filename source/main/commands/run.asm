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
		jsr 	ResetCodeAddress 			; back to the start.
		ldy 	#3
		;
		;		Come here to do next instruction.
		;
CRNextInstruction:
		.StringSoftReset 					; reset the soft string pointer.
		lda 	(codePtr),y 				; get next token.
		bpl 	_CRNotToken
		cmp 	#TOK_TOKENS 				; if in the tokens then do that token.
		bcs 	_CRExecute
		cmp 	#TOK_UNARYST 				; unary is ignored.
		bcs 	Unimplemented
		cmp 	#TOK_STRUCTST 				; execute structures.
		bcs 	_CRExecute
		cmp 	#TOK_BINARYST 				; if one of the system tokens $80-$85 do that
		bcs 	_CRCheckIndirect 			; if in that unused range check for ! or ?
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
		cmp 	#$40 						; if 0-3F then it is a letter
		bcs 	Unimplemented
_CRDefaultLet:
		jsr 	CommandLet 					; do the default, LET
		jmp 	CRNextInstruction
		;
		;		Bad but there are two extra defaults ! and ?
		;				
_CRCheckIndirect:
		cmp 	#TKW_PLING 					; !<term> = 
		beq 	_CRDefaultLet
		cmp 	#TKW_QMARK 					; ?<term> =
		beq 	_CRDefaultLet
		bne 	Unimplemented
		
; ************************************************************************************************
;
;								   Handle $81 and $82 shifts
;
; ************************************************************************************************

CommandShift1:	;; [[[SH1]]]
		lda 	(codePtr),y 				; get shifted value		
		bpl 	Unimplemented 				; we have an error as this should not happen.
		asl 	a 							; double into X
		tax
		iny 								; advance over it.
		jsr 	_RunIt 						; we have no jsr (aaaa,X)
		jmp 	CRNextInstruction
_RunIt:		
		jmp 	(Group1Vectors-12,x) 		; and do the code.	

CommandShift2:	;; [[[SH2]]]
		lda 	#$FF 						; $FF means command not unary function.
		.extension_execown
		jmp 	CRNextInstruction

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
		error 	Missing

; ************************************************************************************************
;
;							Syntax error tokens for non commands
;
; ************************************************************************************************

TKErr01:	;; [)]
TKErr02:	;; [,]
TKErr03:	;; [;]
TKErr04:	;; [DEFPROC]
TKErr05:	;; [STEP]
TKErr06:	;; [THEN]
TKErr07:	;; [TO]
TKErr08:	;; [[[STR]]]
		error 	Syntax

		.include "../../generated/tokenvectors0.inc"
		.include "../../generated/tokenvectors1.inc"

		.send code
