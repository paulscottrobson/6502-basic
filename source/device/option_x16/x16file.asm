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
;
;		Note:
;
;			At present it seems impossible to stop the X16 outputting the two byte header
;			and simply writing the bloody contents of the file out. 
;			Thus for compatibility reasons, all files must have a two byte header, which
;	 		should be ignored.
;
		.section 	code

; ************************************************************************************************
;
;					Save file. Name at stack:0 from stack:1 to stack:2
;
; ************************************************************************************************

ExternSave: ;; <save>
		.pshy
		jsr 	ExternGetLength 			; get length of file into A name YX
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
		.puly
		rts

_ESSave:
		.throw 	Save

; ************************************************************************************************
;
;							Load file stack:0 to stack:1
;
; ************************************************************************************************

ExternLoad: ;; <load>
		.pshy
		jsr 	ExternGetLength 			; get length of file into A name YX
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
		.puly
		rts

_ESLoad:
		.throw 	Load

; ************************************************************************************************
;
;							Get length of filename into A, filename into YX
;
; ************************************************************************************************

ExternGetLength:
		lda 	esInt0 						; length into A.
		sta 	temp0
		lda 	esInt1
		sta 	temp0+1
		ldy 	#0
		lda 	(temp0),y
		
		ldx 	esInt0 						; name into YX
		ldy 	esInt1
		inx 								; advance over the length pointer.
		bne 	_ESNoCarry
		iny
_ESNoCarry:		
		rts

		.send 	code
