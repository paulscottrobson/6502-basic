; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		palette.asm
;		Purpose:	Set Palette Mode.
;		Created:	19th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;									Palette <colour>,<RGB>
;
; ************************************************************************************************

CommandPalette: ;; [palette]
		lda 	#0
		.main_EvaluateSmall
		.main_checkcomma
		lda 	#1
		.main_evaluate
		;
		lda 	esInt0 					; get palette #
		;
		jsr 	PointToPaletteA			; point to palette register
		lda 	esInt0+1
		sta 	$9F23
		lda 	esInt1+1
		and 	#$0F
		sta 	$9F23
		rts

PointToPaletteA:
		asl 	a 							; x 2 -> LSB
		sta 	$9F20
		lda 	#0 							; carry into A
		rol 	a
		ora 	#$FA 						; make correct address
		sta 	$9F21
		lda 	#$11 						; $01 and single step => $9F22
		sta 	$9F22
		rts

		.send 	code
