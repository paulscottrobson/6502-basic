; *****************************************************************************
; *****************************************************************************
;
;		Name:		int32multiply.asm
;		Author:		Paul Robson (paul@robsons.org.uk)
;		Date:		21st February 2021
;		Reviewed: 	7th March 2021
;		Purpose:	32 bit unsigned multiply
;
; *****************************************************************************
; *****************************************************************************

		.section code		
		
; *****************************************************************************
;
;								32 bit multiply
;
; *****************************************************************************

MInt32Multiply:
		inx 								; copy 2nd -> 3rd
		jsr 	MInt32CopyUp
		dex 	
		jsr 	MInt32CopyUp 				; copy 1st -> 2nd
		jsr 	MInt32False 				; zero 1st.
_I32Loop:
		lda 	esInt0+2,x 					; get low bit of 3rd
		and 	#1
		beq 	_I32NoAdd 					; if set
		jsr 	MInt32Add 					; add 2nd to 1st.
_I32NoAdd:
		inx 								; shift 2nd left
		jsr 	MInt32ShiftLeft		
		inx  								; shift 3rd right
		jsr 	MInt32ShiftRight
		;
		jsr 	MInt32Zero 					; check if zero.
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

MInt32CopyUp:
		lda 	esInt0,x
		sta 	esInt0+1,x
		lda 	esInt1,x
		sta 	esInt1+1,x
		lda 	esInt2,x
		sta 	esInt2+1,x
		lda 	esInt3,x
		sta 	esInt3+1,x
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
		
		