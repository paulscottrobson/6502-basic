; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		99end.asm
;		Purpose:	Start up code.
;		Created:	11th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

;
;		These are so we can see how much storage and zero page memory are used.
;
		.section zeropage
endZeroPage:
		.send zeropage
		
		.section storage
endStorage:
		.send storage

;
;		Force to 1/4 boundary.
;
		.section code
		.align 	256
programMemory:		
		* = programMemory-1
		.byte 	$FF

		.send code

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
