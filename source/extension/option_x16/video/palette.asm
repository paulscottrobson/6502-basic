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
		sta 	X16VeraData0
		lda 	esInt1+1
		and 	#$0F
		sta 	X16VeraData0
		rts

PointToPaletteA:
		asl 	a 							; x 2 -> LSB
		sta 	X16VeraAddLow
		lda 	#0 							; carry into A
		rol 	a
		ora 	#(X16VeraPalette >> 8)&$FF	; make correct address
		sta 	X16VeraAddMed
		lda 	#(X16VeraPalette >> 16)|$10	; $01 and single step => X16VeraAddHigh
		sta 	X16VeraAddHigh
		rts

		.send 	code
