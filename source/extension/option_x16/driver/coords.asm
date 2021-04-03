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
		rts

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
		rts

; ************************************************************************************************
;
;						Calculate pixel offset from gdXPos,gdYPos => temp0
;							 Copy that to the screen display position.
;
; ************************************************************************************************

gdSetDrawPosition:
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
		sta 	temp0
		lda 	temp0+1
		adc 	gdXPos+1
		sta 	temp0+1

		clc
		lda 	gdBitmapAddress
		adc 	temp0
		sta 	$9F20		
		lda 	gdBitmapAddress+1
		adc 	temp0+1
		sta 	$9F21
		lda 	gdBitmapAddress+2
		adc 	#0
		sta 	$9F22
		rts

; ************************************************************************************************
;
;										Plot Ink/Paper/A
;
; ************************************************************************************************

gdPlotInk:
		lda 	gdInk
gdPlotA:		
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