; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		x16io.asm
;		Purpose:	Input/Output x16
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;											Initialise
;
; ************************************************************************************************

IOInitialise: ;; <initialise>
		lda 	#15
		jsr 	IOPrintChar
		lda 	#2
		jsr 	IOInk
		lda 	#0
		jsr 	IOPaper
		jsr 	IOClearScreen
		rts
		
; ************************************************************************************************
;
;									Clear Screen/Home Cursor
;
; ************************************************************************************************

IOClearScreen: ;; <clear>
		pha
		lda	 	#147
		jsr 	IOPrintChar
		pla
		rts

; ************************************************************************************************
;
;											Print CR/LF
;
; ************************************************************************************************

IONewLine: ;; <crlf>
		pha
		lda 	#13
		jsr 	IOPrintChar
		pla
		rts

; ************************************************************************************************
;
;											Print Tab
;
; ************************************************************************************************

IOTab: ;; <tab>
		pha
		lda 	#32
		jsr 	IOPrintChar
		pla
		rts

; ************************************************************************************************
;
;											Print A
;
; ************************************************************************************************

IOPrintChar: ;; <print>
		tax
		phy
		txa
		cmp 	#8 							; make BS (8) onto CHR$(14)
		bne 	_IOPCNotBS
		lda 	#$14
_IOPCNotBS:
		jsr 	$FFD2
		ply
		rts

; ************************************************************************************************
;
;				Check key is pressed/in kbd buffer, returns key if so 0 otherwise
;				Only keys outside 32..127 are 0 (no key) 8 (backspace) 13 (return)
;											(INKEY)
;
; ************************************************************************************************

IOInkey: ;; <inkey>
		.pshy
		jsr 	$FFE4
		sta 	tempShort
		.puly
		lda 	tempShort				; no key pressed.
		beq 	_IOIExit
		cmp 	#13 					; allow CR
		beq 	_IOIExit
		cmp 	#$14 					; backspace code
		beq 	_IOIBackspace
		cmp 	#32
		bcc 	IOInkey
		bcs 	_IOIExit
_IOIBackspace:
		lda 	#8 						; return chr(8)		
_IOIExit:		
		rts

; ************************************************************************************************
;
;							Set Ink Colour (BBC Micro colour scheme)
;
; ************************************************************************************************

IOInk:	 ;; <ink>
		pha
		and 	#7
		tax
		lda 	_IOColourTable,x
		jsr 	IOPrintChar
		pla
		rts

_IOColourTable:
		.byte 	$90 					; 0 Black
		.byte 	$1C 					; 1 Red
		.byte 	$1E 					; 2 Green
		.byte 	$9E 					; 3 Yellow
		.byte 	$1F 					; 4 Blue
		.byte 	$9C 					; 5 Magenta
		.byte 	$9F 					; 6 Cyan
		.byte 	$05 					; 7 White

; ************************************************************************************************
;
;							Set Paper Colour (BBC Micro colour scheme)
;
; ************************************************************************************************

IOPaper: ;; <paper>
		pha
		pha
		lda 	#1 						; 1 swaps fgr/bgr
		jsr 	IOPrintChar
		pla
		jsr 	IOInk
		lda 	#1
		jsr 	IOPrintChar
		pla
		rts

; ************************************************************************************************
;
;									Set Cursor to (A,Y)
;
; ************************************************************************************************

IOLocate: ;; <locate>
		pha
		lda 	#$13 					; home
		jsr 	IOPrintChar
		lda 	#$11 	 				; print Y x $11 (down)		
		jsr 	_IOLoc2 
		.puly 							; horizontal pos in A
		lda 	#$1D 					
_IOLoc2:		
		cpy 	#0
		beq 	_IOLocExit
		jsr 	IOPrintChar
		dey
		bne 	_IOLoc2
_IOLocExit:
		rts				

		.send 	code
