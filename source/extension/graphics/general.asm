; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		general.asm
;		Purpose:	Handle general types of drawing command
;		Created:	1st April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************
;
;		This handles a variety of options which modify drawing actions. These extensions are
;		available to all platforms provided the driver is implemented.
;
;		The generic handler examines the text after the drawing keyword and behaves as follows :
;
;		<coordinate pair>				makes current position, but does nothing else.
;		FROM <coordinate pair> 			same
;		AT/TO <coordinate pair> 		makes current position
;		INK/PAPER <colour> 				set ink/paper colour.
;		DIM <size> 						set dimensions
; 		IMAGE <sprite> 					select image to draw
; 		FLIP <flip> 					select flip value.
;		, 								ignored.
;
;		Not all options apply to all drawing commands.
;
; ************************************************************************************************

		.section storage 

gStartStorage:
;
;		The order of these matters. The coordinate update uses the order of the Positions
;		and the update uses the order of Ink .. Flip
;
gCurrentXPos: 								; last set coordinate pair. Making a pair current invovles
		.fill 	2 							; copying the coordinate here, and into x2, and the old
gCurrentYPos: 								; value here to y2.
		.fill 	2
;
gX1:		 								; at the start of any draw, contain the four coordinates
		.fill 	2		 					; most recently used. x2,y2 are the most recently used.
gY1:		 								; these can be swapped, adjusted, whatever.
		.fill 	2		
gX2:		
		.fill 	2		
gY2:		
		.fill 	2		
;
;		Bresenham values see bresenham.py in documentation directory.
;
gError:		 								; error value.
		.fill 	2
g2Error:		 							; 2 x error value.
		.fill 	2
gdx:			 							; delta x and y
		.fill 	2
gdy:		
		.fill 	2

;
;
;
gWordHandler: 								; the word handler which does the actual drawing.
		.fill 	2 	

gEndStorage:		
		.send storage

		.section code	

; ************************************************************************************************
;
;							Reset storage memory (done on mode change)
;
; ************************************************************************************************

GResetStorage:
		.pshx
		ldx 	#gEndStorage-gStartStorage-1 ; fill all storage for gfx with 0
		lda 	#0
_GRSLoop:		
		sta 	gStartStorage,x
		dex
		bpl 	_GRSLoop
		.pulx
		rts

; ************************************************************************************************
;
;										Graphic Handler, routine in XA
;
; ************************************************************************************************

GHandler:
		stx 	gWordHandler+1 				; save code that draws the actual line or whatever.
		sta 	gWordHandler
		dey 								; predecrement
		;
_GHLoopNext:
		iny									; advance one character
		;
		;		Main loop
		;
_GHLoop:
		lda 	(codePtr),y 				; look at character.
		cmp 	#TKW_COMMA 					; , go to next
		beq 	_GHLoopNext
		cmp 	#TOK_EOL 					; end of line or : , exit
		beq 	_GHExit
		cmp 	#TKW_COLON
		beq 	_GHExit
		cmp 	#TKW_AT 					; have we found AT or TO
		beq 	_GHCallHandler 				; update post & call the handler
		cmp 	#TKW_TO
		beq 	_GHCallHandler 
		cmp 	#TKW_FROM
		beq 	_GHCPairSkip
		ldx 	#0 							; now see if it matches a token modifier (INK,PAPER etc.)
_GHCheckTokens:
		lda 	(codePtr),y
		cmp 	_GHTokenTable,x		
		beq 	_GHFoundToken
		inx
		lda 	_GHTokenTable,x
		bne 	_GHCheckTokens
		dey
_GHCPairSkip:	
		iny		
		;
_GHCPair:		
		jsr 	GHMakeCurrent 				; should be a coordinate pair then.
		jmp 	_GHLoop
		;
		;		Found a modifier (INK/PAPER) so evaluate it and update the appropriate storage.
		;
_GHFoundToken:
		iny 								; skip token (INK/PAPER etc.)
		.pshx 								; save target
		lda 	#0 							; evaluate byte
		.main_evaluatesmall
		.pulx								; get target back
		lda 	esInt0 						; get evaluated value
		sta 	gModifiers,x 				; update the modifiers
		jmp 	_GHLoop 					; and loop back
		;				
		;		Found AT or TO. Get the following coordinate, and call the handler to do the actual work.
		;
_GHCallHandler:
		iny 								; consume AT or TO.
		jsr 	GHMakeCurrent 				; update the coordinates.
		.pshy
		jsr 	_GHCallHandlerCode 			; call the handler code
		.puly
		jmp 	_GHLoop 					; and loop round.
		;
_GHCallHandlerCode:
		jmp 	(gWordHandler)
		;
_GHExit:
		rts		
;
;		Token table used to identify element to update. 
;
_GHTokenTable:
		.byte 	TKW_INK,TKW_PAPER,TKW_DIM,TKW_IMAGE,TKW_FLIP
		.byte 	0

; ************************************************************************************************
;
;								Get coordinate pair, make current.
;
; ************************************************************************************************

GHMakeCurrent:
		.pshx 							
		ldx 	#0 							; do for 0 offset (X)
		jsr 	_GHMCDoIt
		.main_checkcomma 				
		ldx 	#2 							; do for 2 offset (Y)
		jsr 	_GHMCDoIt
		.pulx
		rts
;
;		Updates one coordinate of the pair, which data is updated is modified via X.
;
_GHMCDoIt:		
		lda 	gCurrentXPos,x 				; copy the current position to X,Y
		sta 	gX1,x
		lda 	gCurrentXPos+1,x
		sta 	gX1+1,x
		;
		;
		.pshx 								; save X
		lda 	#0 							; evaluate the parameter, now in esInt0,esInt1
		.main_evaluateint
		.pulx
		;
		lda 	esInt0 						; check coordinate range
		cmp 	gdXLimit,x
		lda 	esInt1
		sbc 	gdXLimit+1,x
		bcs 	_GMHCRange
		lda 	esInt2
		ora 	esInt3
		bne 	_GMHCRange

		lda 	esInt0 						; copy into current and X2,Y2
		sta 	gCurrentXPos,x
		sta 	gX2,x
		lda 	esInt1
		sta 	gCurrentXPos+1,x
		sta 	gX2+1,x
		;
		rts
_GMHCRange:
		.throw	BadValue

		.send 	code