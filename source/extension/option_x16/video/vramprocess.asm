; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vramprocess.asm
;		Purpose:	Load VRAM format data
;		Created:	13th March 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
compressMode:
		.fill 	1

imageInfo:									; image info (the first byte) for sprites
		.fill 	X16MaxImages
imageAddr32Low: 							; image VRAM address divided by 32
		.fill  	X16MaxImages
imageAddr32High:		
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
		sta 	X16VeraAddLow 						; set write address with +1 increment
		lda 	temp1
		sta 	X16VeraAddMed
		lda 	temp1+1
		ora 	#$10 					
		sta 	X16VeraAddHigh
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
		sta 	X16VeraData0 				; and send to Vera
		jsr 	LVFGet
		and 	#$0F
		sta 	X16VeraData0
		jmp 	_LVRLoop
		;
		;		Load data in, which may or may not be compressed.
		;
_LVRLoad:	
		ldx 	compressMode
		bne 	_LVRNotMode0
		;
		;		Mode 0 :Load A & 7F bytes of data in , uncompressed
		;
		and 	#$7F 						; count in X (is > 0)
_LVRLCopyX:		
		tax
_LVRLCopy:
		jsr 	LVFGet 						; write to data.
		sta 	X16VeraData0		
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
		lda 	X16VeraAddLow 				; check VRAM on 32 byte boundary
		and 	#$1F 						; sprite image addresses are limited to this.
		beq 	_LVRAligned
		lda 	#$00
		sta 	X16VeraData0
		beq 	_LVRAlignVRAM
		;
		;		Now aligned correctly, copy the address in the table converting from 17 bits
		; 		to 12, which is the Vera internal format.
		;
_LVRAligned:
		lda 	X16VeraAddHigh 				; put address/32 in sprite image table
		lsr 	a 	 						; first halve into temp1						
		lda 	X16VeraAddMed
		ror 	a
		sta 	temp1+1
		lda 	X16VeraAddLow
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
		sta 	imageAddr32High,x		
		lda 	temp1
		sta 	imageAddr32Low,x		
		jmp 	_LVRLoop

_LVRSSValue:
		.throw 	BadValue
		;
		;		Mode 1 : Simple RLE compression.
		;
_LVRNotMode0:
		cpx 	#1
		bne 	_LVRNotMode1
		;
		;		Mode 1 : A & $3F elements of data, could be uncompressed (00-3F) or
		;		compressed (00-3F) see vram.txt
		;
		and 	#$7F 						; drop bit 7
		cmp 	#$40
		bcc 	_LVRLCopyX 					; 00-3F use mode 0's copying code.
_LVRRLEGroup:
		and 	#$3F 						; the number of copies of the following byte.
		tax
		jsr 	LVFGet 						; get the byte to copy
_LVRLEGroupLoop:
		sta 	X16VeraData0 				; write it out X times
		dex
		bne 	_LVRLEGroupLoop
		jmp 	_LVRLoop

_LVRNotMode1:
		.debug
		jmp 	_LVRNotMode1

; ************************************************************************************************
;
;			Read one byte from VRAM source. This MUST go through here, so we can use
;			Paged RAM if required. temp0 points to the VRAM.
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
