; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		03data.inc
;		Purpose:	Common data handlers
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;												Zero page code
;
; ************************************************************************************************

		.section zeropage

codePtr:.fill 	2							; (codePtr),y points to code.

temp0: 	.fill 	2							; working variables.
temp1: 	.fill 	2
temp2: 	.fill 	2

tempShort:	
		.fill 	1

		.send zeropage

; ************************************************************************************************
;
;											Non-Zero page code
;
; ************************************************************************************************


; ************************************************************************************************
;
;		type bits
;		7 		1 indicates reference, 0 constant
;		6 		0 indicates number, 1 string
;		5 		1 indicates byte reference,0 indicates normal reference (int refs only)
;		1..4 	0
;		0 		0 indicates integer, 1 floating point
;
; ************************************************************************************************

		.section zeropage

		* = $40

esType:	.fill 	StackSize  					; type byte (see above)					

esInt0:	.fill 	StackSize 					; integer or mantissa
esInt1:	.fill 	StackSize 
esInt2:	.fill 	StackSize
esInt3:	.fill 	StackSize

esExp:	.fill 	StackSize 					; exponent
esSign: .fill 	StackSize 					; sign byte for floating point only

		.send zeropage

esMant0 = esInt0 							; synonyms.
esMant1 = esInt1
esMant2 = esInt2
esMant3 = esInt3

		.section storage

		.align	256

SingleLetterVar:
 		.fill 	26*4 						; storage for variable A-Z.

basePage: 									; start of program space.
		.fill 	2

endMemory: 									; end of memory.
		.fill 	2

highMemory: 								; top of program memory available.
		.fill 	2		

lowMemory:									; bottom of memory available.
		.fill 	2

		.send storage

		.include "../generated/tokenconst.inc"

TYPE_INT =		($3A) 						; type bytes that end identifier.
TYPE_INTARRAY =	($3B)
TYPE_STR =		($3C)
TYPE_STRARRAY =	($3D)
TYPE_FLOAT =	($3E)
TYPE_FLOATARRAY=($3F)