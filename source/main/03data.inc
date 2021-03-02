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

esExp:	.fill 	StackSize 					; exponent ($80 = 0)
esZSign:.fill 	StackSize 					; for floating point - sign (bit 7) isZero (bit 6)

		.send zeropage

esMant0 = esInt0 							; synonyms.
esMant1 = esInt1
esMant2 = esInt2
esMant3 = esInt3

		.section storage

		.align	256

returnStack: 								; return stack, starts on a page boundary 
		.fill 	retStackSize

		.align	256 					

SingleLetterVar:							; storage for variable A-Z. starts on page boundary.
 		.fill 	26*4 	

hashTables:									; hash tables 6 x hashTableSize words.
		.fill 	6*2*hashTableSize 		

basePage: 									; start of program space.
		.fill 	2

endMemory: 									; end of memory.
		.fill 	2

highMemory: 								; top of program memory available.
		.fill 	2		

lowMemory:									; bottom of memory available.
		.fill 	2

NullString:									; used for null string.
		.fill 	1							; don't waste memory concreting null strings.

convertBuffer:								; buffer for numeric conversions
		.fill 	35

		.send storage

		.include "../generated/tokenconst.inc"

TYPE_INT =		($3A) 						; type bytes that end identifier.
TYPE_INTARRAY =	($3B)
TYPE_STR =		($3C)
TYPE_STRARRAY =	($3D)
TYPE_FLOAT =	($3E)
TYPE_FLOATARRAY=($3F)