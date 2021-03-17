; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		access.asm
;		Purpose:	Access an array (multidimensional version)
;		Created:	17th March 2021 (version 2)
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;									Access Array element
;
; ************************************************************************************************

AccessArray:
		;
		;		Get index and do simple check
		;
		inx
		txa
		.main_evaluateint 					; get array index in next slot up.
		pha
		.main_checkrightparen				; check )
		pla
		tax
		dex		
		;
		lda 	esInt3+1,x 					; check index value at least < 64k
		ora 	esInt2+1,x
		bne 	_AABadIndex
		;
		;		Check index in range.
		;
		.pshy
		;
		lda 	esInt0,x 					; put array info ptr in temp0 - this points to the
		sta 	temp0 						; address (+0) max (+2) and size (+4)
		lda 	esInt1,x
		sta 	temp0+1
		;
		ldy 	#2 							; check out of range, compare against max index.
		lda 	esInt0+1,x
		cmp 	(temp0),y
		iny
		lda 	esInt1+1,x
		sbc 	(temp0),y
		bcs 	_AABadIndex 				; if >= then fail.
		;
		;		Work out the offset by data size x index
		;
		inx 								; point to index
		ldy 	#4 							; get the size byte.
		lda 	(temp0),y
;		jsr 	MultiplyTOSByA 				; specialist multiplier.
		dex
		;
		;		Add start of the array space.
		;
		ldy 	#0 							; add this to the array base as the new address
		clc
		lda 	esInt0+1,x
		adc 	(temp0),y
		sta 	esInt0,x
		lda 	esInt1+1,x
		iny
		adc 	(temp0),y
		sta 	esInt1,x
		;
		.puly 
		rts

_AABadIndex:
		.throw 	ArrayIndex		

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
