; ************************************************************************************************
;
;		Name:		utils.asm
;		Purpose:	Drawing Utilities
;		Created:	1st April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;								Draw vertical line length XA
;
; ************************************************************************************************

DrawVerticalLine:
		stx 	temp1+1
		sta 	temp1
_DVLLoop:
		jsr 	gdPlotInk
		jsr		gdMvRight		
		bcs 	_DVLExit					
		lda 	temp1
		bne 	_DVLNoBorrow
		dec 	temp1+1
_DVLNoBorrow:
		dec 	temp1
		lda 	temp1+1
		bpl 	_DVLLoop		
_DVLExit:		
		rts

; ************************************************************************************************
;
;						Setup XY for gX1,gY1 or gX2,gy2 Y is offset
;
; ************************************************************************************************

SetupXY:
		lda 	gX1,y
		ldx 	gX1+1,y
		jsr 	gdSetX
		lda 	gY1,y
		ldx 	gY1+1,y
		jsr 	gdSetY
		jsr 	gdUpdatePixelOffset
		rts		

; ************************************************************************************************
;
;					>= Compare any 2 coords X or Y offsets from X1/X2 in XY
;
; ************************************************************************************************

CompareCoords:
		lda 	gX1,x
		cmp 	gX1,y
		lda 	gX1+1,x
		sbc 	gX1+1,y
		rts

; ************************************************************************************************
;
;				   frame sort, so x1,y1 is top left and x2,y2 is bottom right.
;
; ************************************************************************************************

BoxSort:
		ldx 	#gx1-gx1 
		ldy 	#gx2-gx1
		jsr 	GCompareCoords
		jsr 	GSortMinMaxCoords
		ldx 	#gy1-gx1
		ldy 	#gy2-gx1
		jsr 	GCompareCoords
		jsr 	GSortMinMaxCoords
		rts

		.send code