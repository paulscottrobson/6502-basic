; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		memory.asm
;		Purpose:	String memory handler
;		Created:	27th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section zeroPage

softMemAlloc: 								; memory allocated for temporary strings
		.fill 	2  							; if MSB is zero needs resetting on allocation.

		.send 	zeroPage

		.section code		
		
		.send code		
		
