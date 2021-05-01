; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		driver.asm
;		Purpose:	Graphics Driver.
;		Created:	31st March 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
;
;	External calls: 
;
;	These must exist, but can all throw Unimplemented (for no graphics) except gdModeChanged
;	which should just return.
;
;			gdModeChanged 				Screen mode changed/initialised, set up
;			gdClearGraphics 			Clear Graphics screen
;			gdSetX/gdSetY 				Set X/Y position to XA
;			gdSetDrawPosition 			Update pixel offset okay from xPos/yPos 
;			gdMvRight/gdMvDown/gdMvUp 	Move, synchronise X,Y with pixelOffset 
;			gdPlotInk/gdPlotPaper 		Plot ink/paper at current position
;			gdPlotA 					Plot A at current position.
;			gdOptHorizontalWriter 		Draw YX length horizontal line from current, position unchanged.
;										(can be )
;
; ************************************************************************************************

		.section storage 

gdEnabled:									; non zero if graphics work.
		.fill 	1		
gdBitmapAddress: 							; bitmap address (base)
		.fill 	3		
gdXPos: 									; horizontal position, calculation only.
		.fill 	2		
gdYPos: 									; vertical position.
		.fill 	2	

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
		lda 	X16VeraHScale 				; requires $40 for H/V Scale
		cmp 	#$40
		bne 	_gdExit
		lda 	X16VeraVScale
		cmp 	#$40
		bne 	_gdExit
		;
		lda 	X16VeraDCVideo 				; read DC_Video, see which layers are enabled.		
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
		ldx 	#0 							; check offset 0 (e.g. start at X16VeraLayerConfig)
		jsr 	gdCheckBitmap 				; go see if this is a bitmap
_gdExit:
		jsr 	gdClearGraphics 			; clear graphics display.
		.puly 								; restore YX
		.pulx
		rts

; ************************************************************************************************
;
;		Check if layer at X16VeraLayerConfig+X is a bitmap, if so return CS and set gdEnabled Flag.
;
; ************************************************************************************************

gdCheckBitmap:
		lda 	X16VeraLayerConfig,x 		; look at bitmap bit.
		cmp 	#7 							; must be zero map size, bitmap and 8bpp
		bne 	_gdCBFail
		;
		inc 	gdEnabled 					; set the enabled flag to non zero.
		lda 	X16VeraLayerTileBase,x 		; this is the bitmap address / 2
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
;								Clear Graphics
;
; ************************************************************************************************

CommandClg:	;; [clg]
		lda 	(codePtr),y 				; CLG PAPER x
		cmp 	#TKW_PAPER
		bne 	_CCLClear
		iny 								; skip paper
		lda 	#0 							; get paper and update
		.main_evaluatesmall
		lda 	esInt0
		sta 	gdPaper
_CCLClear:		
		jsr 	gdClearGraphics 			; call graphics clear code.
		rts

; ************************************************************************************************
;
;								Clear the graphics display
;
; ************************************************************************************************

gdClearGraphics:
		.pshx
		.pshy
		lda 	gdEnabled 					; bitmap screen enabled ?
		beq 	_gdCGExit 					; no, then can't clear 
		;
		set16 	gdXLimit,GrWidth 			; set the size of the bitmap.
		set16 	gdYLimit,GrHeight
		;
		lda 	#0 							; home cursor
		tax
		jsr 	gdSetX
		jsr 	gdSetY	
		jsr 	gdSetDrawPosition 			; set the draw position.
		;
		ldy 	#$FA						; 320 x 200 pixels = $FA00
		ldx 	#0 						
		lda 	gdPaper
		jsr 	gdOptHorizontalWriter		; call the optimised horizontal writer to do $FA00 of A	
_gdCGExit:		
		.puly
		.pulx
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

; ************************************************************************************************
;
;									Write YX elements of colour A
;
; ************************************************************************************************

gdOptHorizontalWriter:
		pha
		lda 	X16VeraAddHigh 						; make it autoincrement.
		ora 	#$10
		sta 	X16VeraAddHigh
		pla
_gdOLoop:
		sta 	X16VeraData0						; write colour out.
		cpx 	#0 									; exit if X = Y = 0
		bne 	_gdNoBorrow 						; decrement YX in here.
		cpy 	#0
		beq 	_gdExit		
		dey 			 							; X 0 so borrow from Y							
_gdNoBorrow:
		dex
		jmp 	_gdOLoop
_gdExit:				
		rts
		.send 	code	
		