; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		binary.asm
;		Purpose:	Binary Routines
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;								Dereference top two / top stack values
;
; ************************************************************************************************

DereferenceTwo:
		inx
		jsr 	DereferenceOne
		dex
DereferenceOne:		
		lda 	esType,x
		bpl 	_DRNotReference 			; is it a reference ?

		lsr 	a 							; do float dereference if bit 0 set.
		bcs 	_DRFloatDeReference
		;
		pshy 								; save Y
		;
		lda 	esInt0,x 					; copy address to temp0
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		;
		lda 	#0 							; clear esInt1..3
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		;
		lda 	esType,x 					; get the type byte.
		and 	#$60 						; get string flag ($40) and byte flag ($20)
		asl 	a 							; now string ($80) byte ($40)
		bmi 	_DeRefString 				; string, 2 bytes only
		bne 	_DeRefByte 					; byte 1 byte only
		;
_DeRefLong: 								; all four
		ldy 	#3 
		lda 	(temp0),y
		sta 	esInt3,x
		dey
		lda 	(temp0),y
		sta 	esInt2,x
_DeRefString:								; only two
		ldy 	#1 
		lda 	(temp0),y
		sta 	esInt1,x
_DeRefByte:									; only one.
		ldy 	#0
		lda 	(temp0),y
		sta 	esInt0,x

		lda 	esType,x 					; clear byte and deref bits.
		and 	#$40
		sta 	esType,x

		puly 								; restore Y.
_DRNotReference		
		rts
		;
		;		Float dereferncing is done by the floating point library
		;
_DRFloatDereference:
		txa
		floatingpoint_deref
		tax
		lda 	#$01 						; type to FP (float)
		sta 	esType,x
		rts