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

imageInfo:									; image info (the first byte) for sprites
		.fill 	X16MaxImages
imageAddr2Low: 								; image VRAM address divided by 2 to fit in 16 bits.
		.fill  	X16MaxImages
imageAddr2High:		
		.fill  	X16MaxImages

		.send storage

		.section code	

; ************************************************************************************************
;
;								Load VRAM Data from temp0
;
; ************************************************************************************************

LoadVRAMFile:
		.pshx
		.pshy
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
		cmp 	#$0F 						; is it define palette
		beq 	_LVRSetPalette
		cmp 	#$10 						; is it set compression type ?
		bcc 	_LVRSetCompress
		cmp 	#$64 						; is it set sprite type.
		bcc 	_LVRSetSprite
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
		.puly
		.pulx
		rts
		;
		;		Set palette
		;
_LVRSetPalette:
		jsr 	LVFGet 						; get palette id.
		jsr 	PointToPaletteA 			; in palette.asm
		;
		jsr 	LVFGet 						; copy 12 bit palette data in.
		sta 	$9F23
		jsr 	LVFGet
		and 	#$0F
		sta 	$9F23
		jmp 	_LVRLoop
_LVRLoad:	
		ldx 	compressMode
		bne 	_LVRNotMode0
		;
		;		Mode 0 :Load A & 7F bytes of data in (no decompression yet)
		;
		and 	#$7F 						; count in X (is > 0)
		tax
_LVRLCopy:
		jsr 	LVFGet 						; write to data.
		sta 	$9F23		
		dex
		bne 	_LVRLCopy
		jmp 	_LVRLoop
		;
		;		Set sprite to current address
		;
_LVRSetSprite:
		pha 								; save on stack
		jsr 	LVFGet 						; get the sprite number into X
		tax
		cmp 	#X16MaxImages				; too high ?
		bcs 	_LVRSSValue
		pla 								; restore the data held in the first byte
		sta 	imageInfo,x 				; and write into the sprite image table.
_LVRAlignVRAM:
		lda 	$9F20 						; check VRAM on 32 byte boundary
		and 	#$1F
		beq 	_LVRAligned
		lda 	#$00
		sta 	$9F23
		beq 	_LVRAlignVRAM
_LVRAligned:
		lda 	$9F22 						; put address/32 in sprite image table
		lsr 	a 	 						; first halve into temp1						
		lda 	$9F21
		ror 	a
		sta 	temp1+1
		lda 	$9F20
		ror 	a
		sta 	temp1
		;
		ldy 	#4 							; divide it by 16 in temp1
_LVRShift:
		lsr 	temp1+1
		ror 	temp1
		dey
		bne 	_LVRShift
		;
		lda 	temp1+1 					; copy result.
		sta 	imageAddr2High,x		
		lda 	temp1
		sta 	imageAddr2Low,x		
		jmp 	_LVRLoop

_LVRSSValue:
		.throw 	BadValue

_LVRNotMode0:
		.debug
		jmp 	_LVRNotMode0
		
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
