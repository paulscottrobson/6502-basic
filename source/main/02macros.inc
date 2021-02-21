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
