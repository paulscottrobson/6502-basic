; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32compare.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Simple 32 bit compare routines
;
; *****************************************************************************
; *****************************************************************************

		.section code		
		
; *****************************************************************************
;
;					Compare two ints TOS, return $FF,$00,$01
;							(non destructive of values)
;
; *****************************************************************************

MInt32Compare:
		lda 	esInt0,x 					; equality check.
		cmp 	esInt0+1,x
		bne 	MInt32Compare2
		lda 	esInt1,x
		cmp 	esInt1+1,x
		bne 	MInt32Compare2
		lda 	esInt2,x
		cmp 	esInt2+1,x
		bne 	MInt32Compare2
		lda 	esInt3,x
		eor 	esInt3+1,x 					; will return 0 if the same.
		bne 	MInt32Compare2
		rts

MInt32Compare2:
		lda		esInt0,x 					; unsigned 32 bit comparison.
		cmp 	esInt0+1,x		
		lda		esInt1,x
		sbc 	esInt1+1,x		
		lda		esInt2,x
		sbc 	esInt2+1,x		
		lda		esInt3,x
		sbc 	esInt3+1,x		
		bvc 	_I32LNoOverflow 			; make it signed 32 bi comparison
		eor 	#$80
_I32LNoOverflow		
		bmi 	MInt32CLess					; if -ve then return $FF
		lda 	#$01						; else return $01
		rts
;
MInt32CLess:
		lda 	#$FF
		rts

		.send code		
