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

		.section storage
structIndent:
		.fill 	1
		.send storage

		.section 	code

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
		stx 	structIndent
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
		.device_break 						; break out of this.
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
		lda 	#$80 						; undo any down indents this line.
		jsr 	CLStructureCheck
		lda 	structIndent 				; indent level.
		.tokeniser_list 					; detokenise and list code at line (codePtr)
		lda 	#$82 						; up indents from this point on.
		jsr 	CLStructureCheck
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
;		Scan through line at (codePtr) looking for structure adjuster A, and adjust 
;		structIndent accordingly, setting to zero when it goes -ve
;
; ************************************************************************************************

CLStructureCheck:
		sta 	temp0
		ldy 	#3
_CLSCLoop:
		lda 	(codePtr),y 				; get and consume token.
		iny
		cmp 	#$80 						
		bcc 	_CLSCLoop 					; $00-$7F just step over.
		beq		_CLSCExit					; EOL return
		cmp 	#$86 						; special handler
		bcc 	_CLSCSpecial
		cmp 	#TOK_STRUCTST 				; check if structure changer.
		bcc 	_CLSCLoop
		cmp 	#TOK_UNARYST
		bcs 	_CLSCLoop
		;
		tax 								; get adjustment
		lda 	ELBinaryOperatorInfo-TOK_BINARYST,x
		cmp 	temp0	 					; if what we're searching for
		bne 	_CLSCLoop 
		sec
		sbc 	#$81 						; convert to offset
		asl 	a 							; double indent step
		clc 	
		adc 	structIndent 				; add to structure indent
		bpl 	_CLSCNoUnder 				; no underflow
		lda 	#0
_CLSCNoUnder:
		sta 	structIndent
		jmp 	_CLSCLoop		

_CLSCSpecial:								; handle specials (not $80)
		jsr 	ScannerSkipSpecial
		jmp 	_CLSCLoop
_CLSCExit:
		rts

		.send 	code

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
