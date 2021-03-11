; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		readdata.asm
;		Purpose:	Read/Data/Restore
;		Created:	6th March 2021
;		Reviewed: 	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
;
;		Current position. Should rest on seperating , if not search forward for data.
;		(this is swapped with (codePtr),y )
;
dataPtr:									; codePointer and index for Data.
		.fill 	2
dataIndex:									; current position.
		.fill 	1

		.send storage

		.section code

; ************************************************************************************************
;
;										Command READ
;
; ************************************************************************************************

CommandRead:	;; [read]
		ldx 	#0 							; get a reference to a variable in stack:0		
		jsr 	EvaluateReference
		jsr 	SwapDPCP 					; use the data pointer.
		lda 	(codePtr),y 				; see where it is.
		iny
		cmp 	#TKW_COMMA 					; if it is on a comma, it is in data.
		beq 	_CRInData
		;
		dey
		lda 	#TKW_DATA 					; scan forward to a DATA statement.
		tax
		jsr 	ScanForward
_CRInData:
		ldx 	#1 							; evaluate a value at Stack,1
		jsr 	Evaluate 		
		dex 								; and write the value.
		jsr 	WriteValue
		jsr 	SwapDPCP 					; get the code pointer back.
		lda 	(codePtr),y 				; what follows ?
		iny
		cmp 	#TKW_COMMA 					; if comma, another variable
		beq 	CommandRead
		dey
		rts

; ************************************************************************************************
;
;										Command Data
;
; ************************************************************************************************

CommandData: ;; [data]
		lda 	#TOK_EOL 					; go forward to end of line or colon.
		ldx 	#TKW_COLON
		jsr 	ScanForward
		dey 								; ending on EOL is a scan issue, as it increments
		rts

; ************************************************************************************************
;
;										Restore Command
;
; ************************************************************************************************

CommandRestore: ;; [restore]
		lda 	basePage
		sta 	dataPtr
		lda 	basePage+1
		sta 	dataPtr+1
		lda 	#3
		sta 	dataIndex
		rts

; ************************************************************************************************
;
;						Swap DataPointer/DataIndex and CodePtr/Y
;
; ************************************************************************************************

SwapDPCP:
		.pshx
		tya 								; swap Y, DataIndex
		ldy 	DataIndex
		sta 	DataIndex
		;
		lda 	codePtr 					; swap code/dataptr low
		ldx 	dataptr
		sta 	dataPtr
		stx 	codePtr

		lda 	codePtr+1 					; swap code/dataptr high.
		ldx 	dataptr+1
		sta 	dataPtr+1
		stx 	codePtr+1
		.pulx
		rts
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
		