; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		renderer.asm
;		Purpose:	Renderer for image/bitmap
;		Created:	3rd April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
RenderFunction:								; renderer function.
		.fill 	2
RenderWidth:								; image width in pixels
		.fill 	1
RenderHeight:								; image height in pixels
		.fill 	1
RenderType:									; render type (0 = bitmap,1 = colour image)
		.fill 	1		

		.send storage

		.section code	

; ************************************************************************************************
;
;							Image Renderer. Image function is in XA
;
; ************************************************************************************************

ImageRenderer:
		stx 	RenderFunction+1
		sta 	RenderFunction
		;
		;		Get the information about the thing we are rendering.
		;
		ldx 	#255 						; get information.
		jsr 	CallRenderFunction
		sta 	RenderType 					; and save it.
		stx 	RenderWidth
		sty 	RenderHeight
		;
		;		Check the range.
		;
		txa 								; check X coordinate
		ldx 	#0 							; offset to check position/limit.
		jsr 	RenderCheckRange 					
		lda 	RenderHeight 				; check Y coordinate
		ldx 	#2
		jsr 	RenderCheckRange
		;
		ldy 	#0 							; Y is the current line #
_IRLoop1:
		ldx 	gdSize 						; number of times to do the row.
_IRLoop2:
		jsr 	RenderDrawRow 				; draw one row.
		dex 								; scale # times.
		bne 	_IRLoop2
		iny 								; next vertical row
		cpy 	RenderHeight 				; done the lot ?
		bne 	_IRLoop1
		rts

; ************************************************************************************************
;
;										Render one row
;
; ************************************************************************************************

RenderDrawRow:
		.pshx 								; save X and Y
		.pshy
		ldy 	#gX2-gX1 					; set the position at (x,y)
		jsr 	SetupXY 
		.puly 
		ldx 	#0 							; X is the current pixel.
_RDRLoop1:
		jsr 	RenderDrawPixelSet 			; draw a block of pixels of the correct size.
		inx 	
		cpx 	RenderWidth 				; until done the whole lot.
		bne 	_RDRLoop1
		inc 	gY2 						; next line down
		bne 	_RDRNoCarry
		inc 	gY2+1
_RDRNoCarry:		
		.pulx
		rts

; ************************************************************************************************
;
;				Draw a horizontal block of gdSize pixels from (x,y) at current position
;
; ************************************************************************************************

RenderDrawPixelSet:
		.pshx  	 							; save XY
		.pshy 
		jsr 	RenderFlipXY 				; flip positions as required.
		jsr 	RenderGetInk				; get colour to draw with.
		ldx 	gdSize 						; X counts the size.
_RDPSLoop:
		cmp 	#255 						; don't draw if $FF
		beq 	_RDPSNoDraw		
		jsr 	gdPlotA 					; draw A otherwise
_RDPSNoDraw:
		pha 								; move right
		jsr 	gdMvRight		
		pla
		dex
		bne 	_RDPSLoop 					; do it size times.
		.puly
		.pulx
		rts

; ************************************************************************************************
;
;						Get ink for position X,Y , adjusting for bitmap.
;
; ************************************************************************************************

RenderGetInk:
		lda 	RenderType 					; type, if 0 it's a bitmap
		beq 	_RGIBitmap
		jsr 	CallRenderFunction 			; ask the rendering function.
		rts

_RGIBitmap:	
		jsr 	CallRenderFunction 			; ask the rendering function.
		cmp 	#0
		beq 	_RGIUsePaper
		lda 	gdInk
		rts
_RGIUsePaper:
		lda 	gdPaper
		rts		
		.debug		

; ************************************************************************************************
;
;							Flip X and Y according to the flip bits
;
; ************************************************************************************************

RenderFlipXY:
		lda 	gdFlip 						; check any flip at all
		and 	#3
		beq 	_RFExit
		;
		lsr 	a 							; bit 0 in carry flag
		bcc 	_RFNoHFlip
		lda 	RenderWidth 				; X Flip
		stx 	tempShort
		clc
		sbc 	tempShort
		tax
_RFNoHFlip:
		lda 	gdFlip
		and 	#2 							; bit 1 check
		beq 	_RFExit
		lda 	RenderHeight 				; Y Flip
		sty 	tempShort
		clc
		sbc 	tempShort
		tay
_RFExit:		
		rts

; ************************************************************************************************
;
;						Check A * Dimension + X2/Y2 < XLimit/YLimit
;
; ************************************************************************************************

RenderCheckRange:
		;
		;		Multiply A (width/height) by size, this is 8x8 bit so maximum size is 255 pixels
		;
		sta 	temp0+1 					; save multiplier => temp0+1
		ldy 	gdSize 						; multiplicand (size) => temp0, must be non zero
		sty 	temp0
		beq 	_RCRValue 
		lda 	#0 							; total
_RCRMultiply:
		lsr 	temp0 						; shift LSB size into carry
		bcc 	_RCRNoAdd 					; not adding this time.
		clc
		adc 	temp0+1 					; add the size.
		bcs 	_RCRValue 					; overflow
_RCRNoAdd:
		asl 	temp0+1 					; double multiplier
		ldy 	temp0 						; until adder is zero
		bne 	_RCRMultiply						
		;
		;		Add the coordinate
		;
		clc 								; add to x2 or y2, store in temp0
		adc 	gX2,x 						; this is the Right/Bottom coordinate of the image
		sta 	temp0 
		lda 	gX2+1,x
		adc 	#0
		sta 	temp0+1
		;
		;		Check against horizontal/vertical extent.
		;
		lda 	temp0 						; check right vs edge of screen.
		cmp 	gdXLimit,x
		lda 	temp0+1
		sbc 	gdXLimit+1,x
		bcs 	_RCRValue 					; does not fit, so don't draw.
		;
		rts

_RCRValue:		
		.throw 	BadValue
; ************************************************************************************************
;
;								Call the rendering function
;
; ************************************************************************************************

CallRenderFunction:
		jmp 	(RenderFunction)		
		.send 	code