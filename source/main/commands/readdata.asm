; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		readdata.asm
;		Purpose:	Read/Data/Restore
;		Created:	6th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

dataPtr:									; codePointer and index for Data.
		.fill 	2
dataIndex:
		.fill 	1

		.send storage

		.section code

; ************************************************************************************************
;
;										Command Data
;
; ************************************************************************************************

CommandData: ;; [data]
		lda 	#TOK_EOL 					; go forward to end of line or colon.
		ldx 	#TKW_COLON
		jsr 	ScanForward
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

		.send code