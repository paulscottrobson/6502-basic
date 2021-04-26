; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		run.asm
;		Purpose:	Main Run Program
;		Created:	26th February 2021
;		Reviewed: 	8th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

breakCounter: 								; counter, carries whenever break is tested
			.fill 	1
breakIncrement: 							; increment for counter, zero to disable break.
			.fill 	1		

		.send storage

		.section code

; ************************************************************************************************
;
;											RUN command
;
; ************************************************************************************************

Command_Run: 	;; [run]
XCommand_Run:	;; <run>
		ldx 	#$FF 						; reset the stack.
		txs
		jsr 	BreakOn 					; turn break on
		jsr 	CommandClear 				; clear everything.
		jsr 	ResetCodeAddress 			; back to the start.
Command_RunFrom: ;; <runfrom>
		ldy 	#3 							; over offset/line #
		;
		;		Come here to do next instruction.
		;
CRNextInstruction:
		.StringSoftReset 					; reset the soft string pointer.

		lda 	breakCounter 				; check for break.
		adc 	breakIncrement
		sta 	breakCounter
		bcc 	_CRNoChecks
		.device_syncbreak
_CRNoChecks

		lda 	(codePtr),y 				; get next token.
		bpl 	_CRNotToken
		cmp 	#TOK_TOKENS 				; if in the tokens then do that token.
		bcs 	_CRExecute
		cmp 	#TOK_UNARYST 				; unary is ignored.
		bcs 	Unimplemented
		cmp 	#TOK_STRUCTST 				; execute structures.
		bcs 	_CRExecute
		cmp 	#TOK_BINARYST 				; if one of the system tokens $80-$85 do that
		bcs 	_CRCheckIndirect 			; if in that unused range check for ! or ? or AND
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
		dispatch Group0Vectors
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
		cmp 	#TKW_AND 					; AND (assembler)
		beq 	_CRAndCommand
		cmp 	#TKW_PLING 					; !<term> = 
		beq 	_CRDefaultLet
		cmp 	#TKW_QMARK 					; ?<term> =
		beq 	_CRDefaultLet
		bne 	Unimplemented
		
_CRAndCommand:
		iny 								; skip over the AND token
		lda 	#TKW_LPARENANDRPAREN 		; replace it with the pseudo-and
		jsr 	CommandAssembler 			; do the assembler command
		jmp 	CRNextInstruction 			; and loop round.

; ************************************************************************************************
;
;								   Handle $81 and $82 shifts
;
; ************************************************************************************************

CommandShift1:	;; [[[SH1]]]
		lda 	(codePtr),y 				; get shifted value		
		bpl 	Unimplemented 				; we have an error as this should not happen.
		iny 								; advance over it.
		cmp 	#TKA_GROUP1 				; is it an assembler constant ?
		bcs 	CommandAssembler
		asl 	a 							; double into X
		tax
		dispatch Group1Vectors-12 			; and do the code.	

CommandShift2:	;; [[[SH2]]]
		lda 	#$FF 						; $FF means command not unary function.
		.extension_execown
		rts

CommandAssembler:							; run the assembler, opcode code is in A.
		.assembler_assemble 				; assemble an instruction.
		rts
		
CommandAssemblerLabel: ;; [.]
		.assembler_label
		rts

; ************************************************************************************************
;
;					Code called when non-implemented token/keyword appears
;
; ************************************************************************************************

Unimplemented:
		.throw 	Missing

; ************************************************************************************************
;
;									: handler -it's ignored
;
; ************************************************************************************************

CommandColon:	;; [:]
		rts

; ************************************************************************************************
;
;								Break Command
;
; ************************************************************************************************

CommandBreak:	;; [break]
		jsr 	EvaluateRootInteger
		jsr 	MInt32Zero
		beq 	BreakOff
BreakOn:		
		ldx 	#4 							; checks 1 in 256/X instructions.
BreakOff:			
		stx 	breakIncrement
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
TKErr09:	;; [[[SH3]]]
TKErr10:	;; [[[FPC]]]
TKErr11:	;; [#]
TKErr12:	;; [at]
TKErr13:	;; [image]
TKErr14:	;; [flip]
TKErr15:	;; [from]
TKErr16:	;; [text]
TKErr17:	;; [type]

		.throw 	Syntax

		.include "../../../generated/tokenvectors0.inc"
		.include "../../../generated/tokenvectors1.inc"

		.send code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
