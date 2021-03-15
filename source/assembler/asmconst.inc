; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		asmconst.inc
;		Purpose:	Assembler constants/includes.
;		Created:	15th March 2021
;		Author:		Paul Robson = paul@robsons.org.uk
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;										Address Mode
;
;		 Constants 0-7 are determined by the structure of the 65C02 instruction set
;		
; ************************************************************************************************

AMD_IMM		= 0					; Immediate mode.
AMD_ZERO 	= 1					; Zero Page
AMD_ACCIMP	= 2					; Accumulator/Implied
AMD_ABS 	= 3					; Absolute 
AMD_ZEROINDY= 4					; Zero Indirect,Y
AMD_ZEROX 	= 5					; Zero Page,X
AMD_ABSY 	= 6					; Absolute,Y
AMD_ABSX 	= 7					; Absolute,X
AMD_ZEROIND = 8					; Zero Indirect
AMD_ZEROY 	= 9					; Zero Page,Y
AMD_ABSIND 	= 10				; Absolute Indirect
AMD_ABSINDX	= 11				; Absolute Indirect Indexed
AMD_REL		= 12				; Relative
AMD_ZEROINDX= 13 				; Zero Indirect,X
