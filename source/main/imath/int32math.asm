; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32math.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Simple 32 bit arithmetic.
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								Add TOS+1 to TOS
;
; *****************************************************************************

MInt32Add:
		clc
		lda 	esInt0,x
		adc 	esInt0+1,x
		sta 	esInt0,x

		lda 	esInt1,x
		adc 	esInt1+1,x
		sta 	esInt1,x

		lda 	esInt2,x
		adc 	esInt2+1,x
		sta 	esInt2,x

		lda 	esInt3,x
		adc 	esInt3+1,x
		sta 	esInt3,x
		rts

; *****************************************************************************
;
;								Sub TOS+1 from TOS
;
; *****************************************************************************

MInt32Sub:
		sec
		lda 	esInt0,x
		sbc 	esInt0+1,x
		sta 	esInt0,x

		lda 	esInt1,x
		sbc 	esInt1+1,x
		sta 	esInt1,x

		lda 	esInt2,x
		sbc 	esInt2+1,x
		sta 	esInt2,x

		lda 	esInt3,x
		sbc 	esInt3+1,x
		sta 	esInt3,x
		rts
