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

;
;		Hack to load code in.
;
ReturnPos:
		* = $5000
testBaseAddress:		
		.include "../generated/testcode.inc"
		* = ReturnPos
