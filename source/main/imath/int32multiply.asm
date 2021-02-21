; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32multiply.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Purpose:	32 bit unsigned multiply
;
; *****************************************************************************
; *****************************************************************************

; *****************************************************************************
;
;								32 bit multiply
;
; *****************************************************************************

Int32Multiply:
		inx 								; copy 2nd -> 3rd
		jsr 	Int32CopyUp
		dex 	
		jsr 	Int32CopyUp 				; copy 1st -> 2nd
		jsr 	Int32False 					; zero 1st.
_I32Loop:
		lda 	esInt0+2,x 					; get low bit of 3rd
		and 	#1
		beq 	_I32NoAdd 					; if set
		jsr 	Int32Add 					; add 2nd to 1st.
_I32NoAdd:
		inx 								; shift 2nd left
		jsr 	Int32ShiftLeft		
		inx  								; shift 3rd right
		jsr 	Int32ShiftRight
		;
		jsr 	Int32Zero 					; check if zero.
		php 								; save status bits
		dex 	 							; point back to 1st
		dex 		
		plp 								; get status bits
		bne 	_I32Loop 					; if non-zero keep going.
		rts

; *****************************************************************************
;
;								Copy tos to 2nd
;
; *****************************************************************************

Int32CopyUp:
		lda 	esInt0,x
		sta 	esInt0+1,x
		lda 	esInt1,x
		sta 	esInt1+1,x
		lda 	esInt2,x
		sta 	esInt2+1,x
		lda 	esInt3,x
		sta 	esInt3+1,x
		rts

