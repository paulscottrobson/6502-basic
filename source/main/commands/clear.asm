; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		clear.asm
;		Purpose:	Clear everything, also called on RUN.
;		Created:	26th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Clear Command
;
; ************************************************************************************************

CommandClear: 	;; [clear]
		.pshy

		lda 	endMemory					; set high memory = end of memory
		sta 	highMemory
		lda 	endMemory+1
		sta 	highMemory+1
		;
		lda 	basePage 					; work out where the program ends.
		sta 	temp0
		lda 	basePage+1
		sta 	temp0+1
		;
_CCFindEnd:
		ldy 	#0
		lda 	(temp0),y			
		beq 	_CCFoundEnd 				; offset zero is end.
		clc
		adc 	temp0 						; move to next line
		sta 	temp0
		bcc 	_CCFindEnd
		inc 	temp0+1
		jmp 	_CCFindEnd
		;
_CCFoundEnd:
		lda 	temp0 						; put temp0 in lowMemory
		sta 	lowMemory
		lda 	temp0+1
		sta 	lowMemory+1

		lda 	#4 							; skip low free memory clear, leave a gap.
		jsr 	AdvanceLowMemoryByte		; need at least one here, to skip the end of program zero offset.

		jsr 	RSReset 					; reset the return stack.

		.variable_reset 					; reset the variable hash table pointers.
		
		jsr 	ScanProc 					; scan for procedures
		jsr 	CommandRestore 				; do a restore

		.puly
		rts

; ************************************************************************************************
;
;								Advance low memory pointer by A
;
; ************************************************************************************************

AdvanceLowMemoryByte:		
		clc
		adc 	lowMemory
		sta 	lowMemory
		bcc 	_ALMBExit
		inc 	lowMemory+1
_ALMBExit:		
		rts

		.send 	code
