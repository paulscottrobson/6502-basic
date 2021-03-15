; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vramprocess.asm
;		Purpose:	Load VRAM format data
;		Created:	13th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
compressMode:
		.fill 	1
		.send storage

		.section code	

; ************************************************************************************************
;
;								Load VRAM Data from temp0
;
; ************************************************************************************************

LoadVRAMFile:
		;
		;		VRAM Load loop. Defaults removed so VRAM files can be split up arbitrarily.
		;
_LVRLoop:
		jsr 	LVFGet 						; get the next (never access direct)
		cmp 	#$80 						; exit ?
		beq 	_LVRExit
		bcs 	_LVRLoad 					; load data in ?
		cmp 	#$08 						; is it set address ?
		bcc 	_LVRSetAddress
		cmp 	#$10 						; is it set compression type ?
		bcc 	_LVRSetCompress
		.throw 	missing
		;
		;		Set address
		;
_LVRSetAddress:		
		sta 	temp1+1 					; 24 bit in temp1+1/temp1/A
		jsr 	LVFGet
		sta 	temp1
		lda 	#0
		;
		lsr 	temp1+1 					; / 2 twice.
		ror 	temp1
		ror		a
		lsr 	temp1+1
		ror 	temp1
		ror		a
		;
		sta 	$9F20 						; set write address with +1 increment
		lda 	temp1
		sta 	$9F21
		lda 	temp1+1
		ora 	#$10 					
		sta 	$9F22
		bne 	_LVRLoop
		;
		;		Set compression to low 3 bits of A
		;
_LVRSetCompress:
		and 	#7
		sta 	compressMode
		bpl 	_LVRLoop		
		;
		;		End decoding
		;
_LVRExit:
		rts
		;
		;		Load A & 7F bytes of data in (no decompression yet)
		;
_LVRLoad:		
		and 	#$7F 						; count in X (is > 0)
		tax
_LVRLCopy:
		jsr 	LVFGet 						; write to data.
		sta 	$9F23		
		dex
		bne 	_LVRLCopy
		beq 	_LVRLoop

; ************************************************************************************************
;
;			Read one byte from VRAM source. This MUST go through here, so we can use
;			Paged RAM if required.
;
; ************************************************************************************************

LVFGet:	sty 	tempShort
		ldy 	#0
		lda 	(temp0),y
		ldy	 	tempShort
		inc 	temp0
		bne 	_LVFGExit
		inc 	temp0+1
_LVFGExit:
		rts

		.send code
