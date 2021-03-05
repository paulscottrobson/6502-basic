; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		extensionhandler.asm
;		Purpose:	Handles extension calls.
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

ExtensionHandler:
		lda 	(codePtr),y
		iny
		asl 	a
		tax
		jmp 	(Group2Vectors-12,X)
		.send code

		.include "../generated/tokenvectors2.inc"
