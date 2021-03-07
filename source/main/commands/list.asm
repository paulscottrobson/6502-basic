; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		list.asm
;		Purpose:	LIST command
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;									List command
;
; ************************************************************************************************

CommandList:		;; [list]
		ldx		#0 							; set start/end lines in stack 0/1
		jsr 	MInt32False
		inx
		jsr 	MInt32True
		;
		lda 	(codePtr),y
		cmp 	#TKW_COMMA 					; list ,xxxx
		beq 	_CLEnd
		cmp 	#0 							; list ... on its own.
		bmi 	_CLDoListing
		;
		ldx 	#0 							; get start
		jsr 	EvaluateInteger
		lda 	(codePtr),y 				; , follows
		cmp 	#TKW_COMMA
		beq 	_CLEndLine
		jsr 	MInt32CopyUp 				; copy first to second
		jmp 	_CLDoListing
		;
_CLEndLine:	
		iny 								; skip comma		
		lda 	(codePtr),y  				; no number follows.	
		bmi 	_CLDoListing
		ldx 	#1
		jsr 	EvaluateInteger				; get end
_CLDoListing:
		jsr 	ResetCodeAddress 			; back to the start.
_CLCheckLoop:
		ldy 	#0							; check end.
		lda 	(codePtr),y
		beq 	_CLEnd
		;
		ldx 	#0 							; compare vs lower.
		jsr 	CLCompareLineTOS
		cmp 	#255 						; if < skip
		beq 	_CLNext
		inx
		jsr 	CLCompareLineTOS 			; compare vs higher
		cmp 	#1
		beq 	_CLNext
		.tokeniser_list 					; detokenise and list code at line (codePtr)
_CLNext:	
		ldy 	#0
		lda 	(codePtr),y
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_CLCheckLoop
		inc 	codePtr+1
		jmp 	_CLCheckLoop

_CLEnd:		
		jmp 	_CLEnd
;
;		Compare current line against low word of stack,x
;
CLCompareLineTOS:
		ldy 	#1
		lda 	(codePtr),y
		eor 	esInt0,x
		sta 	temp0
		iny
		lda 	(codePtr),y
		eor 	esInt1,x
		ora 	temp0
		beq 	_CLCLTExit
		;
		dey
		lda 	(codePtr),y
		cmp 	esInt0,x
		iny
		lda 	(codePtr),y
		sbc 	esInt1,x
		lda 	#255
		bcc 	_CLCLTExit
		lda 	#1
_CLCLTExit:
		rts

