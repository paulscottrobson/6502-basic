; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		loadstore.asm
;		Purpose:	Save/Load FP.
;		Created:	23rd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

;
; 		Load TOS to temp0
;
FPLoad:	;; <loadfp>
		debug
		jmp 	FPLoad

;
;		Write TOS to temp0		
;
FPStore: ;; <storefp>		
		debug
		jmp 	FPStore

;
;	Set (temp0),y variable to zero.
;

FPSetZero: ;; <setzero>
		debug
		jmp 	FPSetZero

		.send code		
