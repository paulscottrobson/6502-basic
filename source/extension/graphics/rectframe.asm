; ************************************************************************************************
;
;		Name:		rectframe.asm
;		Purpose:	Rectangle and frame code
;		Created:	1st April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************

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
		.debug
		rts

; ************************************************************************************************
;
;								Draw Frame (outline box in Ink)
;
; ************************************************************************************************

Command_Frame: 	;; [fra,e]
		lda 	#FrameHandler & $FF
		ldx 	#FrameHandler >> 8
		jsr 	GHandler
		.debug
		rts

; ************************************************************************************************
;
;				Handlers to draw frame/box, difference is the driver address :)
;
; ************************************************************************************************

FrameHandler:
		nop
RectHandler:		
		jsr 	BoxSort
		.debug
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