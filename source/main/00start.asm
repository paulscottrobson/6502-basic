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
Start:	ldx 	#$FF
		txs
		set16 	basePage,testBaseAddress
		jmp 	Command_Run
	
		.send code

ReturnPos:
		* = $9000
testBaseAddress:		
		.byte 0
		.word 100
		.include "../generated/testcode.inc"
		* = ReturnPos
