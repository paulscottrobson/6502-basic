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
		
		.device_initialise
		set16 	basePage,testBaseAddress
		set16  	endMemory,$9800

		jmp 	Command_Run
	
		.send code

;
;		Hack to load code in.
;
ReturnPos:
		* = $5000
testBaseAddress:		
		.include "../../generated/testcode.inc"
		* = ReturnPos
