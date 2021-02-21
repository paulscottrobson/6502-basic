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

; *****************************************************************************
;
;					Test top stack values are equals, CS = Yes
;
; *****************************************************************************

Int32Equal:
		lda 	esInt0,x
		cmp 	esInt0+1,x
		bne 	Int32CFail
		lda 	esInt1,x
		cmp 	esInt1+1,x
		bne 	Int32CFail
		lda 	esInt2,x
		cmp 	esInt2+1,x
		bne 	Int32CFail
		lda 	esInt3,x
		cmp 	esInt3+1,x
		bne 	Int32CFail
Int32CSucceed:
		sec
		rts

; *****************************************************************************
;
;						Test 1st < 2nd (signed), CS = Yes
;
; *****************************************************************************

Int32Less:
		sec
		lda		esInt0,x
		sbc 	esInt0+1,x		
		lda		esInt1,x
		sbc 	esInt1+1,x		
		lda		esInt2,x
		sbc 	esInt2+1,x		
		lda		esInt3,x
		sbc 	esInt3+1,x		
		bvc 	_I32LNoOverflow
		eor 	#$80
_I32LNoOverflow		
		bmi 	Int32CSucceed
Int32CFail:
		clc
		rts