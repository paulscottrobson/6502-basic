; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		macros.inc
;		Purpose:	Macros
;		Created:	21st February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;							Insert an X16 Emulator Breakpoint
;
; ************************************************************************************************

debug 		.macro
		.byte 	$DB
		.endm

; ************************************************************************************************
;
;			This macro replaces jmp(nnnn,x) which needs doing differently for the 6502
;
; ************************************************************************************************

dispatch 	.macro
		.if  	cputype==0
		pha
		lda 	\1,x
		sta 	jumpVector
		lda 	1+(\1),x
		sta 	jumpVector+1
		pla
		jmp 	(jumpVector)
		.else
		jmp 	(\1,x)
		.endif
		.endm

; ************************************************************************************************
;
;					Push and pull X and Y. Can be simplified for 65C02
;
; ************************************************************************************************

		.if cputype == 0

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

		.else

pshy 	.macro
		phy
		.endm

puly 	.macro
		ply
		.endm

pshx 	.macro
		phx
		.endm

pulx 	.macro
		plx
		.endm

		.endif

; ************************************************************************************************
;
;							Set a 16 bit variable to a constant
;
; ************************************************************************************************

set16 	.macro
		lda 	#(\2) & $FF
		sta 	\1
		lda 	#(\2) >> 8
		sta 	1+(\1)
		.endm

; ************************************************************************************************
;
;			Check top of return stack and throw error if the wrong marker is there
;
; ************************************************************************************************

rsCheck .macro 
		ldx 	#0 							; get TOS return stack
		lda 	(rsPointer,x) 		
		cmp 	#\1 						; does it match
		beq 	_isok
		.throw 	\2 							; no report error.
_isok:		
		.endm
