; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		00start.asm
;		Purpose:	Start up code.
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code
Start:		
		debug
		Error 	42
		jmp 	Start

		.send code

test0:	;; <test0>
test1:	;; <test1>
