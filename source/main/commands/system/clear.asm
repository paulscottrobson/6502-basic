; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		clear.asm
;		Purpose:	Clear everything, also called on RUN.
;		Created:	26th February 2021
;		Reviewed: 	7th March 2021
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
XCommandClear:	;; <clear>
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

		clc 								; put temp0+1 in endProgram
		lda 	temp0
		adc 	#1
		sta 	endProgram
		lda 	temp0+1
		adc 	#0
		sta 	endProgram+1

		clc 								; put a bit of space in.
		lda 	lowMemory
		adc 	#4
		sta 	lowMemory
		bcc 	_CCNoCarry
		inc 	lowMemory+1
_CCNoCarry:		

		jsr 	RSReset 					; reset the return stack.

		.variable_reset 					; reset the variable hash table pointers.
		
		jsr 	ScanProc 					; scan for procedures
		jsr 	CommandRestore 				; do a restore

		.puly
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
