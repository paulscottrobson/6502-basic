; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		list.asm
;		Purpose:	LIST command
;		Created:	7th March 2021
;		Reviewed: 	11th March 2021
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
		;
		;		Get start and end range.
		;
		ldx		#0 							; set start/end lines in stack 0/1 to 0 and $FFFF
		jsr 	MInt32False
		inx
		jsr 	MInt32True
		;
		lda 	(codePtr),y 				; look at first token
		cmp 	#TKW_COMMA 					; list ,xxxx
		beq 	_CLEndLine
		cmp 	#0 							; list ... on its own.
		bmi 	_CLDoListing 				; do the whole lot.
		;
		ldx 	#0 							; get start line at stack:0
		jsr 	EvaluateInteger
		lda 	(codePtr),y 				; , follows ?
		cmp 	#TKW_COMMA
		beq 	_CLEndLine   				
		jsr 	MInt32CopyUp 				; copy first to second if just a line number on its
		jmp 	_CLDoListing 				; own e.g. list 1100
		;
_CLEndLine:	
		iny 								; skip comma		
		lda 	(codePtr),y  				; no number follows, then its list 1000,	
		bmi 	_CLDoListing
		ldx 	#1 							; get the last line to list
		jsr 	EvaluateInteger				; get end
		;
		;		This does the actual listing, though most of the work is done by
		;		the tokenise module.
		;
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
		ldy 	#0 							; go to next line.
		lda 	(codePtr),y
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_CLCheckLoop
		inc 	codePtr+1
		jmp 	_CLCheckLoop

_CLEnd:		
		jmp 	WarmStart 					; warm start after list.
; ************************************************************************************************
;
;						Compare current line against low word of stack,x
;
; ************************************************************************************************

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
