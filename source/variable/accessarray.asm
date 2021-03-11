; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		accessarray.asm
;		Purpose:	Access an array
;		Created:	6th March 2021
;		Reviewed: 	11th March 2021
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
		jsr 	MultiplyTOSByA 				; specialist multiplier.
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
		error 	ArrayIndex		

; ************************************************************************************************
;
;							Specialist 2,4 and 6 multipliers
;
; ************************************************************************************************

		.if VarISize * VarFSize * VarSSize != 48
		Fix Me ! You have changed the variable sizes so this function now won't work properly.
		.endif

MultiplyTOSByA:
		pha
		lda 	esInt0,x 					; copy index to temp1
		sta 	temp1
		lda 	esInt1,x
		sta 	temp1+1
		pla
		;
		asl 	esInt0,x 					; double it.
		rol 	esInt1,x
		cmp 	#2 							; if x 2 then exit.
		beq 	_MTBAExit
		cmp 	#6 							; if x 6 then add temp1 to index
		bne 	_MTBANotFloat
		pha
		clc 								; so this will make it x 3
		lda 	esInt0,x
		adc 	temp1
		sta 	esInt0,x
		lda 	esInt1,x
		adc 	temp1+1
		sta 	esInt1,x
		pla
_MTBANotFloat:		
		asl 	esInt0,x					; now it is x 4 or x 6
		rol 	esInt1,x 
_MTBAExit:		
		rts

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
