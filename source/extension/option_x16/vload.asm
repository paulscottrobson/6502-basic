; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vload.asm
;		Purpose:	Load VRAM format data file.
;		Created:	13th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;										VLoad "FileName"
;
; ************************************************************************************************

Command_VLoad:		;; [vload]
		ldx 	#0 								; string which is the file name
		jsr 	EvaluateString
		inx
		jsr 	MInt32False 							
		lda 	lowMemory 						; load it into lowMemory (for now ?)
		sta 	esInt0,x
		lda 	lowMemory+1
		sta 	esInt1,x
		dex
		.device_load 							; load filein to lowMemory.
		lda 	esInt0+1 						; (temp0) is where we are decoding from.
		sta 	temp0
		lda 	esInt1+1
		sta 	temp0+1
		jsr 	LoadVRAMFile 					; load the VRAM file in.
		rts

		.send code