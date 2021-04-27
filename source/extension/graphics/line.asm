; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		line.asm
;		Purpose:	Line code
;		Created:	2nd April 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
gdySign:									; original gdy sign.
		.fill 	1
		.send storage

		.section code	

; ************************************************************************************************
;
;										Line Drawer
;
; ************************************************************************************************

Command_Line: 	;; [line]
		lda 	#LineHandler & $FF
		ldx 	#LineHandler >> 8
		jsr 	GHandler
		rts

; ************************************************************************************************
;
;									Handler to Line
;
; ************************************************************************************************

LineHandler:		
		ldx 	#gX1-gX1 					; check if horizontal, vertical line
		ldy 	#gX2-gX1
		jsr 	CompareCoordsEq
		beq 	_LHRectCode
		ldx 	#gY1-gX1 			
		ldy 	#gY2-gX1
		jsr 	CompareCoordsEq
		bne 	_LHLineDrawer
_LHRectCode: 								; if x1=x2 or y1 = y2 (or both) use rect drawer
		jmp 	RectHandler
		;
_LHLineDrawer:
		;
		;		Make the line slope left to right. We know it's not vertical or horizontal now.
		;
		ldx 	#gX1-gX1 					; check if X1 < X2 e.g. it is sloped to the right.
		ldy 	#gX2-gX1
		jsr 	CompareCoords
		bcc 	_LHNoSwap
		jsr 	GSwapCoords					; if so swap coords so X2 > X1, may be going up or down.
		ldx 	#gY1-gX1
		ldy 	#gY2-gX1
		jsr 	GSwapCoords
_LHNoSwap:
		;
		jsr 	BresenhamInitialise 		; initialise Bresenham constants
		ldy 	#gX1-gX1
		jsr 	SetupXY 					; set up X1,Y1 to draw.
		bcs 	_LHExit 					; line off screen.
		;
_LHDrawLoop:
		ldx 	#gX1-gX1 					; check if X1=X2 and Y1 = Y2
		ldy 	#gX2-gX1
		jsr 	CompareCoordsEq
		bne 	_LHNextPixel
		ldx 	#gY2-gX1
		ldy 	#gY2-gX1
		jsr 	CompareCoordsEq
		bne 	_LHNextPixel
		jsr 	gdPlotInk 					; plot the last pixel.
_LHExit:
		rts
_LHNextPixel:
		jsr 	gdPlotInk 					; plot the pixel.
		jsr 	BresenhamIteration 			; do one bresenham iteration calculation
		jmp  	_LHDrawLoop 				; and loop back if okay

; ************************************************************************************************
;
;										Set up Bresenham code
;
; ************************************************************************************************

BresenhamInitialise:		
		;
		;		dx = x2 - x1
		;
		sec
		lda 	gX2
		sbc 	gX1
		sta 	gdX
		lda 	gX2+1
		sbc 	gX1+1
		sta 	gdX+1
		;
		;		dy = y1 - y2
		;
		sec
		lda 	gY1
		sbc 	gY2
		sta 	gdy
		lda 	gY1+1
		sbc 	gY2+1
		sta 	gdy+1
		;
		;		Check if dy +ve in which case we are moving the wrong way
		;
		lda 	gdy+1 						; save sign of dy
		sta 	gdysign
		bmi 	_BINormal
		sec
		lda 	#0
		sbc 	gdy
		sta 	gdy
		lda 	#0
		sbc 	gdy+1
		sta 	gdy+1
		rts

_BINormal:		
		;
		;		error = dx + dy
		;
		clc
		lda 	gdx
		adc 	gdy
		sta 	gError
		lda 	gdx+1
		adc 	gdy+1
		sta 	gError+1
		rts

; ************************************************************************************************
;
;									Do one Bresenham iteration
;							 (code in while loop, excluding the plot)
;
; ************************************************************************************************

BresenhamIteration:
		;
		;		error2 = 2 * error
		;
		lda 	gError 			
		asl 	a
		sta 	g2Error
		lda 	gError+1
		rol 	a
		sta 	g2Error+1
		;
		;		check e2 >= dy, and if so execute the body.
		;
		ldx 	#g2Error-gX1
		ldy 	#gdy-gX1
		jsr 	CompareCoordsSigned
		bmi 	_BINoE2DY
		jsr 	BresenhamE2GEDY
_BINoE2DY:				
		;
		;		check dx >= e2, and if so execute the body.
		;
		ldx 	#gdx-gX1
		ldy 	#g2Error-gX1
		jsr 	CompareCoordsSigned
		bmi 	_BINoDXE2
		jsr 	BresenhamDXGEE2
_BINoDXE2:				
		rts
;
;		Code to execute if e2 >= dy
;
BresenhamE2GEDY:
		;
		;		error += dy
		;
		clc
		lda 	gError
		adc 	gdy
		sta 	gError
		lda 	gError+1
		adc 	gdy+1
		sta 	gError+1
		;
		;		inc x1
		;
		inc 	gX1
		bne 	_BE2Skip
		inc 	gX1+1
_BE2Skip:
		jsr 	gdMvRight
		rts
;
;		Code to execute if dx >= e2
;
BresenhamDXGEE2:
		;
		;		error += dx
		;
		clc
		lda 	gError
		adc 	gdx
		sta 	gError
		lda 	gError+1
		adc 	gdx+1
		sta 	gError+1
		lda 	gdySign
		bpl 	_BEDXInvertY
		;
		;		inc y1
		;
		inc 	gY1
		bne 	_BEDXSkip
		inc 	gY1+1
_BEDXSkip:
		jsr 	gdMvDown
		rts		
		;
		;		code we do if flipped Y e.g. decrement y1 and move up
		;
_BEDXInvertY:
		lda 	gY1
		bne 	_BEDXSkip2
		dec 	gY1+1
_BEDXSkip2:
		dec 	gY1		
		jsr 	gdMvUp
		rts
		
		.send 	code