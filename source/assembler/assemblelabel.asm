; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		assemblelabel.asm
;		Purpose:	Assembler label handler
;		Created:	14th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						Assemble instruction in A, rest is (codePtr),y
;
; ************************************************************************************************

AssembleLabel:	;; <label>		
		.debug
		nop
		rts

		.send 	code		
