; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32unary.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	Simple 32 bit unary operations
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;							Absolute value of TOS
;
; *****************************************************************************

Int32Absolute:
		lda 	esInt3,x 					; use negate code if -ve.
		bmi 	Int32Negate
		rts
		
; *****************************************************************************
;
;								Negate TOS
;
; *****************************************************************************

Int32Negate:
		sec
		lda 	#0
		sbc 	esInt0,x
		sta 	esInt0,x
		lda 	#0
		sbc 	esInt1,x
		sta 	esInt1,x
		lda 	#0
		sbc 	esInt2,x
		sta 	esInt2,x
		lda 	#0
		sbc 	esInt3,x
		sta 	esInt3,x
		rts		

; *****************************************************************************
;
;							  Not TOS (1's complement)
;
; *****************************************************************************

Int32Not:
		lda 	esInt0,x
		eor 	#$FF
		sta 	esInt0,x
		lda 	esInt1,x
		eor 	#$FF
		sta 	esInt1,x
		lda 	esInt2,x
		eor 	#$FF
		sta 	esInt2,x
		lda 	esInt3,x
		eor 	#$FF
		sta 	esInt3,x
		rts				

; *****************************************************************************
;
;									Int32 Sign.
;
; *****************************************************************************

Int32Sign:
		lda 	esInt3,x					; look at MSB
		bmi 	Int32True 					; if set return -1 (true)
		jsr 	Int32Zero 					; is it zero ?
		beq 	Int32False 					; if zero return 0 (false)
		jsr 	Int32False 					; > 0 return 1
		inc 	esInt0,x 
		rts

; *****************************************************************************
;
;							Int32 True/False values
;
; *****************************************************************************

Int32True:
		lda 	#$FF 						; set to $FFFFFFFF
		bne 	Int32WriteAll
Int32False:									; set to 0
		lda 	#0
Int32WriteAll:								; fill all integer fields with A
		sta 	esInt0,x
Int32Write123:		
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		lda 	#$00						; and make it an integer
		sta 	esType,x
		rts

; *****************************************************************************
;
;							Set 8 bit value
;
; *****************************************************************************
		
Int32Set8Bit:
		sta 	esInt0,x
		lda 	#0
		beq		Int32Write123

; *****************************************************************************
;
;							Int32 Shift Left
;
; *****************************************************************************

Int32ShiftLeft:
		asl 	esInt0,x
		rol	 	esInt1,x
		rol	 	esInt2,x
		rol	 	esInt3,x
		rts

; *****************************************************************************
;
;						Int32 Shift Right (Logical)
;
; *****************************************************************************

Int32ShiftRight:
		lsr 	esInt3,x
		ror 	esInt2,x
		ror 	esInt1,x
		ror 	esInt0,x
		rts		

; *****************************************************************************
;
;							Set Z flag if zero
;
; *****************************************************************************
		
Int32Zero:
		lda 	esInt0,x
		ora 	esInt1,x
		ora 	esInt2,x
		ora 	esInt3,x
		rts

; *****************************************************************************
;
;						Generate 32 bit random number.
;
; *****************************************************************************

Int32Random:
		pshy
		ldy 	#7
		lda 	Seed32+0
		bne 	_Random1
		tay
		lda		#$AA
_Random1:
		asl 	a
		rol 	Seed32+1
		rol 	Seed32+2
		rol 	Seed32+3
		bcc 	_Random2
		eor 	#$C5
_Random2:		
		dey
		bne 	_Random1
		sta 	Seed32+0
		sta 	esInt0,x
		lda 	Seed32+1
		sta 	esInt1,x
		lda 	Seed32+2
		sta 	esInt2,x
		lda 	Seed32+3
		sta 	esInt3,x
		puly
		rts
