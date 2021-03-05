; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		macros.inc
;		Purpose:	Macros
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

debug 		.macro
		.byte 	$DB
		.endm

dispatch 	.macro
		jmp 	(\1,x)
		.endm

pshy 	.macro
		tya
		pha
		.endm

puly 	.macro
		pla
		tay
		.endm

pshx 	.macro
		txa
		pha
		.endm

pulx 	.macro
		pla
		tax
		.endm

set16 	.macro
		lda 	#(\2) & $FF
		sta 	\1
		lda 	#(\2) >> 8
		sta 	1+(\1)
		.endm

rsCheck .macro 
		ldx 	#0 							; get TOS return stack
		lda 	(rsPointer,x) 		
		cmp 	#\1 						; does it match
		beq 	_isok
		error 	\2 							; no report error.
_isok:		
		.endm
