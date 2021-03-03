; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		convert.asm
;		Purpose:	Convert to/from float and int
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section  code		
		
FPItoF:	;; <intToFloat>
		debug
		jmp 	FPItoF

FPFtoI:	;; <floatToInt>
		debug
		jmp 	FPFtoI

FPFToS: ;; <floatToString>
		debug
		jmp 	FPFtoS
		
FPSToF: ;; <stringToFloat>
		clc
		rts
		
		.send code		