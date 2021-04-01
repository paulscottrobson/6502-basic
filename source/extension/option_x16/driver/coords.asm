; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		coords.asm
;		Purpose:	Graphics Driver/Coordinate management
;		Created:	31st March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;										Move right
;
; ************************************************************************************************

gdMvRight:
		inc 	$9F20 						; bump $9F20
		bne 	_gdMR0
		inc 	$9F21
		bne 	_gdMR0
		inc 	$9F22
_gdMR0:										; bump position
		inc 	gdXPos
		bne 	_gdMR1
		inc 	gdXPos+1
_gdMR1:	
		lda 	gdXPos+1		 			; check MSB
		beq 	gdMOnScreen
		cmp 	#2
		bcs 	gdmOffScreen
		lda 	gdXPos 						; $01xx check < $140
		cmp 	#$40
		bcs 	gdmOffScreen
gdmOnScreen:
		clc
		rts
gdmOffScreen:
		sec
		rts

; ************************************************************************************************
;
;										Move up/down
;
; ************************************************************************************************

gdMvUp:	
		lda 	gdYPos 						; decrement Y Pos
		bne 	_gdMU1
		dec 	gdYPos+1
_gdMU1:	dec 	gdYPos
		sec 								; adjust position by -320
		lda 	$9F20
		sbc 	#64
		sta 	$9F20
		lda 	$9F21
		sbc 	#1
		sta 	$9F21
		lda 	$9F22
		sbc 	#0
		sta 	$9F22
		jmp 	gdCheckYRange

gdMvDown:	
		inc 	gdYPos 						; decrement Y Pos
		bne 	_gdMU1
		inc 	gdYPos+1
_gdMU1:	
		clc 								; adjust position by -320
		lda 	$9F20
		adc 	#64
		sta 	$9F20
		lda 	$9F21
		adc 	#1
		sta 	$9F21
		lda 	$9F22
		adc 	#0
		sta 	$9F22

gdCheckYRange: 								; check Y = 0...199
		lda 	gdYPos+1
		bne 	gdmOffScreen
		lda 	gdYPos
		cmp 	#200
		bcs 	gdmOffScreen
		bcc 	gdmOnScreen
; ************************************************************************************************
;
;						Update pixel offset/is okay from gdXPos,gdYPos
;
; ************************************************************************************************

gdUpdatePixelOffset:
		lda 	gdXPos+1 					; check X < 320 ($140)
		beq 	_gdUPOCheckY
		cmp 	#2
		bcs 	_gdUPOBad
		lda 	gdXPos
		cmp 	#$40
		bcs 	_gdUPOBad
_gdUPOCheckY:		
		lda 	gdYPos+1 					; check Y < 200 
		bne 	_gdUPOCalculate
		lda 	gdYPos
		cmp 	#200
		bcc 	_gdUPOCalculate
_gdUPOBad:
		lda 	#0
		sta 	gdIsPosOkay
		sec
		rts
;
_gdUPOCalculate:
		lda 	#0 							; temp0 is LSB of result start as 256 x Y
		sta 	temp0 
		lda 	gdYPos
		sta 	temp0+1
		lsr 	temp0+1 					; / 4 so temp0 is YC x 64
		ror 	temp0
		lsr 	temp0+1
		ror 	temp0
		;
		lda 	gdYPos 						; add 256 x Y => 320 * Y < 64k
		clc
		adc 	temp0+1
		sta 	temp0+1 					; temp0 = 320 x Y now add X => pixeloffset
		;
		clc
		lda 	temp0
		adc 	gdXPos
		sta 	gdPixelOffset
		lda 	temp0+1
		adc 	gdXPos+1
		sta 	gdPixelOffset+1
		;
		lda 	#1 							; it's legitimate.
		sta 	gdIsPosOkay 
		jsr 	gdCopyPosition 				; copy position over
		clc
		rts

; ************************************************************************************************
;
;					Copy Pixel offset + bitmapAddress => Address register
;
; ************************************************************************************************

gdCopyPosition:
		pha
		clc
		lda 	gdBitmapAddress
		adc 	gdPixelOffset
		sta 	$9F20		
		lda 	gdBitmapAddress+1
		adc 	gdPixelOffset+1
		sta 	$9F21
		lda 	gdBitmapAddress+2
		adc 	#0
		sta 	$9F22
		pla
		rts

; ************************************************************************************************
;
;										Plot Ink/Paper
;
; ************************************************************************************************

gdPlotInk:
		lda 	gdInk
		sta 	$9F23
		rts
gdPlotPaper:
		lda 	gdPaper
		cmp 	#$FF
		beq 	_gdPPSkip
		sta 	$9F23
_gdPPSkip:		
		rts

		.send 	code