; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		utils.asm
;		Purpose:	Drawing Utilities
;		Created:	1st April 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						Setup XY for gX1,gY1 or gX2,gy2 Y is offset
;
; ************************************************************************************************

SetupXY:
		lda 	gX1,y 						; set the X position
		ldx 	gX1+1,y
		jsr 	gdSetX
		lda 	gY1,y 						; set the Y position
		ldx 	gY1+1,y
		jsr 	gdSetY
		jsr 	gdSetDrawPosition 			; recalculate and set up Vera.
		rts		

; ************************************************************************************************
;
;					>= Compare any 2 coords X or Y offsets from X1/X2 in XY
;								  (Signed and unsigned versions)
;
; ************************************************************************************************

CompareCoords:
		lda 	gX1,x
		cmp 	gX1,y
		lda 	gX1+1,x
		sbc 	gX1+1,y
		rts

CompareCoordsSigned:
		jsr 	CompareCoords
		bvc 	_CCSExit
		eor 	#$80	
_CCSExit:		
		rts
		
; ************************************************************************************************
;
;					= Compare any 2 coords X or Y offsets from X1/X2 in XY
;
; ************************************************************************************************

CompareCoordsEq:
		lda 	gX1,x
		cmp 	gX1,y
		bne 	_CCEExit
		lda 	gX1+1,x
		cmp 	gX1+1,y
_CCEExit:		
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

; ************************************************************************************************
;
;					Compare coordinate at X with coordinate at Y (unsigned)
;
; ************************************************************************************************

GCompareCoords:
		lda 	gx1,x
		cmp 	gx1,y
		lda 	gx1+1,x
		sbc 	gx1+1,y
		rts

; ************************************************************************************************
;
;				 Swap coordinates at X & Y if CS e.g. X >= Y so smallest first.
;
; ************************************************************************************************

GSortMinMaxCoords:
		bcc 	GSMMCExit
GSwapCoords:		
		lda 	gx1,x
		pha
		lda 	gx1,y
		sta 	gx1,x
		pla
		sta 	gx1,y

		lda 	gx1+1,x
		pha
		lda 	gx1+1,y
		sta 	gx1+1,x
		pla
		sta 	gx1+1,y
GSMMCExit:
		rts

		.send code