; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		driver.asm
;		Purpose:	Graphics Driver.
;		Created:	31st March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
;
;	External calls:
;
;			gdModeChanged 				Screen mode changed/initialised, set up
;			gdClearGraphics 			Clear Graphics screen
;			gdSetInk/gdSetPaper 		Set Ink/Paper
;			gdSetX/gdSetY 				Set X/Y position to XA
;			gdUpdatePixelOffset 		Update pixel offset okay from xPos/yPos (CS on offscreen)
;			gdMvRight/gdMvDown/gdMvUp 	Move, synchronise X,Y with pixelOffset (CS on offscreen_)
;			gdPlotInk/gdPlotPaper 		Plot ink/paper (if #255) at current position
;
; ************************************************************************************************

		.section storage 

gdEnabled:									; non zero if graphics work.
		.fill 	1		
gdBitmapAddress: 							; bitmap address (base)
		.fill 	3		

gdPixelOffset: 								; pixel offset from bitmap address, current.
		.fill 	2
gdXPos: 									; horizontal position.
		.fill 	2		
gdYPos: 									; vertical position.
		.fill 	2		
gdIsPosOkay: 								; position is on screen if non-zero.
		.fill 	1
gdInk: 										; foreground colour
		.fill 	1
gdPaper:									; background colour (255 = transparent)
		.fill 	1		

		.send 	storage

		.section code	

; ************************************************************************************************
;
;		Called when mode changed, gets bitmap status from the VERA registers and clears
;		screen if relevant.
;
; ************************************************************************************************

gdModeChanged:
		.pshx 								; save XY
		.pshy
		lda 	#0 							; zero the enabled flag.
		sta 	gdEnabled

		lda 	$9F2A 						; requires $40 for H/V Scale
		cmp 	#$40
		bne 	_gdExit
		lda 	$9F2B
		cmp 	#$40
		bne 	_gdExit
		;
		lda 	$9F29 						; read DC_Video, see which layers are enabled.		
		asl 	a 							; 
		asl 	a 							; bit 7 now set if layer 1 enabled.
		bpl 	_gdNotLayer1
		;
		pha 								; save A
		ldx 	#7 							; check offset 7 (e.g. start at $9F34)
		jsr 	gdCheckBitmap 				; go see if this is a bitmap
		pla 								; restore A
		bcs 	_gdExit 					; if successful then exit
_gdNotLayer1:		
		asl 	a 							; bit 7 now set if layer 0 enabled.
		bpl 	_gdExit 					; if not enabled, exit
		ldx 	#0 							; check offset 0 (e.g. start at $9F2D)
		jsr 	gdCheckBitmap 				; go see if this is a bitmap
_gdExit:
		jsr 	gdClearGraphics 			; clear graphics display.
		.puly 								; restore YX
		.pulx
		rts

; ************************************************************************************************
;
;		Check if layer at $9F2D+X is a bitmap, if so return CS and set gdEnabled Flag.
;
; ************************************************************************************************

gdCheckBitmap:
		lda 	$9F2D,x 					; look at bitmap bit.
		cmp 	#7 							; must be zero map size, bitmap and 8bpp
		bne 	_gdCBFail
		;
		inc 	gdEnabled 					; set the enabled flag to non zero.
		lda 	$9F2F,x 					; this is the bitmap address / 2
		asl 	a
		sta 	gdBitmapAddress+1
		adc 	#$00 						; set to no move, updated manually.
		sta 	gdBitmapAddress+2
		lda 	#$00
		sta 	gdBitmapAddress 			; this is a 17 bit address.
_gdCBFail:
		clc
		rts		

; ************************************************************************************************
;
;								Clear the graphics display
;
; ************************************************************************************************

gdClearGraphics:
		.pshx
		.pshy
		lda 	gdEnabled 					; screen enabled
		beq 	_gdCGExit
		lda 	#0 							; reset position
		sta 	gdIsPosOkay 				; not legal position
		sta 	gdPixelOffset 				; zero pixel offset.
		sta 	gdPixelOffset+1
		sta 	gdPaper 					; paper black
		jsr 	gdCopyPosition
		lda 	$9F22 						; make it autoincrement.
		ora 	#$10
		sta 	$9F22
		lda 	#1 							; ink white
		sta 	gdInk
		;
		ldy 	#$FA						; 320 x 200 pixels = $FA00
		ldx 	#0
		lda 	gdPaper
_gdCGLoop1:
		sta 	$9F23				
		dex
		bne 	_gdCGLoop1
		dey
		bne 	_gdCGLoop1
_gdCGExit:
		.puly
		.pulx
		rts

; ************************************************************************************************
;
;										Set Ink/Paper
;
; ************************************************************************************************

gdSetInk:
		sta 	gdInk
		rts
gdSetPaper:
		sta 	gdPaper
		rts

; ************************************************************************************************
;
;										Set X/Y position
;	
; ************************************************************************************************

gdSetX:
		sta 	gdXPos
		stx 	gdXPos+1
		rts

gdSetY:
		sta 	gdYPos
		stx 	gdYPos+1
		rts

		.send 	code	