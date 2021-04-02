; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		rectframe.asm
;		Purpose:	Rectangle and frame code
;		Created:	1st April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
frameFlag:									; 0 rect #0 frame.
		.fill 	1
		.send storage
		.section code	

; ************************************************************************************************
;
;								Draw Rectangle (solid box in Ink)
;
; ************************************************************************************************

Command_Rect: 	;; [rect]
		lda 	#RectHandler & $FF
		ldx 	#RectHandler >> 8
		jsr 	GHandler
		rts

; ************************************************************************************************
;
;								Draw Frame (outline box in Ink)
;
; ************************************************************************************************

Command_Frame: 	;; [frame]
		lda 	#FrameHandler & $FF
		ldx 	#FrameHandler >> 8
		jsr 	GHandler
		rts

; ************************************************************************************************
;
;				Handlers to draw frame/box, difference is the driver address :)
;
; ************************************************************************************************

FrameHandler:
		lda 	#1
		bne 	RectHandler+2
RectHandler:		
		lda 	#0
		sta 	frameFlag
		jsr 	BoxSort 					; sort so topleft/bottom right
		jsr 	DrawBoxPart 				; solid first line
_FHLoop:
		ldx 	#gY1-gX1 					; check Y1 = Y2
		ldy 	#gY2-gX1		
		jsr 	CompareCoords 
		bcs 	_FHLastLine 				; Y1 >= Y2 then end.
		lda 	frameFlag 					; identify solid or frame ?
		beq 	_FHIsSolidRect
		jsr 	DrawBoxEnds
		jmp 	_FHNext
_FHIsSolidRect:
		jsr 	DrawBoxPart
_FHNext:		
		inc 	gY1 						; bump Y1 and loop back.
		bne 	_FHLoop
		inc 	gY1+1
		jmp 	_FHLoop

_FHLastLine:
		jsr 	DrawBoxPart 				; solid last line whatever		
_FHExit:		
		rts

; ************************************************************************************************
;
;									Draw solid line from X1/Y1
;
; ************************************************************************************************

DrawBoxPart:
		ldy 	#gX1-gX1
		jsr 	SetupXY 					; set up X1,Y1 to draw.
		sec 								; calculate line length => temp0
		lda 	gX2
		sbc 	gX1
		pha
		lda 	gX2+1
		sbc 	gx1+1
		tax
		pla 								; line length in XA.
		jsr 	DrawHorizontalLine
		rts

; ************************************************************************************************
;
;								Draw either end of line from X1/Y1
;
; ************************************************************************************************

DrawBoxEnds:
		ldy 	#gX1-gX1
		jsr 	SetupXY 					; set up X1,Y1 to draw.
		jsr 	gdPlotInk 					; LH end.
		lda 	gX2 						; set position to X2,Y1
		ldx 	gX2+1
		jsr 	gdSetX
		jsr		gdSetDrawPosition 			; update position.
		jsr 	gdPlotInk 					; RH end.
		rts

; ************************************************************************************************
;
;								Draw Horizontal line length XA
;
; ************************************************************************************************

DrawHorizontalLine:
		stx 	temp1+1
		sta 	temp1
_DVLLoop:
		jsr 	gdPlotInk
		jsr		gdMvRight		
		lda 	temp1
		bne 	_DVLNoBorrow
		dec 	temp1+1
_DVLNoBorrow:
		dec 	temp1
		lda 	temp1+1
		bpl 	_DVLLoop		
_DVLExit:		
		rts

		.send code
		