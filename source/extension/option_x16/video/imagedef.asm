; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		imagedef.asm
;		Purpose:	Redefine text character
;		Created:	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;									Redefine Image
;
; ************************************************************************************************

Command_Image: 	;; [image] 
		lda 	#0 							; get a small int
		.main_evaluatesmall
		.pshy 								; save Y
		lda 	esInt0 						; get character #
		ldy 	#0 							; offset 0
		jsr 	PointVeraCharacterA 		; routine in textdraw that points to character A
		.puly								; restore Y
_CILoop:
		lda 	(codePtr),Y 				; followed by ,
		cmp 	#TKW_COMMA
		bne 	_CIExit 					; no, then done.
		iny 								; skip comma
		lda 	#0 							; get a small int
		.main_evaluatesmall
		lda 	esInt0
		sta 	X16VeraData0 				; write to vera
		jmp 	_CILoop
_CIExit:				
		rts


		.send 	code