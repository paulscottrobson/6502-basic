; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		x16file.asm
;		Purpose:	Save/Load x16 files
;		Created:	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;					Save file. Name at stack:0 from stack:1 to stack:2
;
; ************************************************************************************************

ExternSave: ;; <save>
		jsr 	ExternGetLength 			; get length of file into A
		jsr 	$FFBD 						; set name
		;
		lda 	#1
		ldx 	#8	 						; device #8
		ldy 	#0
		jsr 	$FFBA 						; set LFS
		;
		lda 	esInt0+1 					; copy start of save address to temp0
		sta 	temp0
		lda 	esInt1+1
		sta 	temp0+1
		;
		ldx 	esInt0+2 					; end address
		ldy 	esInt1+2
		lda 	#temp0 						; ref to start address
		jsr 	$FFD8 						; save
		bcs 	_ESSave

		rts

_ESSave:
		error 	Save

; ************************************************************************************************
;
;							Load file stack:0 to stack:1
;
; ************************************************************************************************

ExternLoad: ;; <load>
		jsr 	ExternGetLength 			; get length of file into A
		jsr 	$FFBD 						; set name
		;
		lda 	#1
		ldx 	#8	 						; device #8
		ldy 	#0
		jsr 	$FFBA 						; set LFS		

		ldx 	esInt0+1 					; load address
		ldy 	esInt1+1
		lda 	#0 							; load command
		jsr 	$FFD5
		bcs 	_ESLoad

		rts

_ESLoad:
		error 	Load

; ************************************************************************************************
;
;							Get length of filename into A, filename into YX
;
; ************************************************************************************************

ExternGetLength:
		lda 	esInt0 						; length into A.
		sta 	temp0
		lda 	esInt0+1
		sta 	temp0+1
		ldy 	#0
		lda 	(temp0),y
		
		ldx 	esInt0 						; name into YX
		ldy 	esInt0+1
		inx 								; advance over the length pointer.
		bne 	_ESNoCarry
		iny
_ESNoCarry:		
		rts
