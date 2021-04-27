; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		x16io.asm
;		Purpose:	Input/Output x16
;		Created:	28th February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

MaxLineInputSize = 240

		.section storage

bufferCount:	 							; chars in buffer
		.fill 	0
bufferStorage: 								; input buffer.
		.fill 	MaxLineInputSize
nextSyncTick: 								; time of next sync tick, if zero not initialised.
		.fill 	0 

		.send storage

		.section code	

; ************************************************************************************************
;
;										Control Handler
;
; ************************************************************************************************

IOControlHandler: ;; <controlhandler>
		cmp 	#0
		bne		_CHExit
		lda 	#15 						; switch to upper/lower case mode
		jsr 	IOPrintChar
		lda 	#2 							; green on black and clear screen
		jsr 	IOInk
		lda 	#0
		sta 	nextSyncTick
		jsr 	IOPaper
		jsr 	IOClearScreen
_CHExit:		
		rts
		
; ************************************************************************************************
;
;									Clear Screen/Home Cursor
;
; ************************************************************************************************

IOClearScreen: ;; <clear>
		pha
		lda	 	#147 						; char code $93 clears screen
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
;								Print A (ASCII for listing, errors)
;
; ************************************************************************************************

IOPrintAscii: ;; <printascii>

; ************************************************************************************************
;
;											Print A
;
; ************************************************************************************************

IOPrintChar: ;; <print>
		tax 								; save in X so we can save Y
		.pshy
		txa
		cmp 	#8 							; make BS (8) onto CHR$(14) which is the
		bne 	_IOPCNotBS 					; Commodore/X16 backspace code.
		lda 	#$14
_IOPCNotBS:
		jsr 	KNLPrintChar 				; CBM OS Call.
		.puly
		rts

; ************************************************************************************************
;
;				Check key is pressed/in kbd buffer, returns key if so 0 otherwise
;				Only keys outside 32..127 are 0 (no key) 8 (backspace) 13 (return)
;											(INKEY)
;
; ************************************************************************************************

IOInkey: ;; <inkey>
		.pshy 								; read key with XY protected
		jsr 	KNLCheckKeyboarBuffer
		sta 	tempShort
		.puly
		lda 	tempShort					; no key pressed.
		beq 	_IOIExit
		cmp 	#13 						; allow CR (13)
		beq 	_IOIExit
		cmp 	#$14 						; backspace code ($14) returns 8.
		beq 	_IOIBackspace
		cmp 	#32 						; no other control allowed.
		bcc 	IOInkey
		bcs 	_IOIExit

_IOIBackspace:
		lda 	#8 							; return chr(8)		
_IOIExit:		
		rts

; ************************************************************************************************
;
;							Set Ink Colour (BBC Micro colour scheme)
;
; ************************************************************************************************

IOInk:	 ;; <ink>
		pha
		and 	#7 							; 8 primaries
		tax
		lda 	_IOColourTable,x 			; look up CBM code and print it.
		jsr 	IOPrintChar
		pla
		rts

_IOColourTable:
		.byte 	$90 					; 0 Black
		.byte 	$96 					; 1 Red
		.byte 	$1E 					; 2 Green
		.byte 	$9E 					; 3 Yellow
		.byte 	$9A 					; 4 Blue
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
		lda 	#1 						; 1 swaps fgr/bgr, so we swap them, set fgr
		jsr 	IOPrintChar 			; and then swap them again.
		pla
		jsr 	IOInk
		lda 	#1
		jsr 	IOPrintChar
		pla
		rts

; *************************************************************************************************
;
;									Set Cursor to (A,Y)
;
; ************************************************************************************************

IOLocate: ;; <locate>
		pha
		lda 	#$13 					; home cursor code
		jsr 	IOPrintChar
		lda 	#$11 	 				; print Y x $11 (down)		
		jsr 	_IOLoc2 
		.puly 							; horizontal pos in A now
		lda 	#$1D 					; print Y x $1D (right)
_IOLoc2:		
		cpy 	#0
		beq 	_IOLocExit
		jsr 	IOPrintChar
		dey
		bne 	_IOLoc2
_IOLocExit:
		rts				

; *************************************************************************************************
;
;						Input Line, return buffer pointer in temp0
;
; *************************************************************************************************

IOInput:	;; <inputline>
		lda 	#0
		sta 	bufferCount
_IOILoop:
		jsr 	KNLInputLine
		cmp 	#13
		beq 	_IOIExit
		ldx 	bufferCount
		cpx 	#MaxLineInputSize
		beq 	_IOILoop
		inc 	bufferCount
		sta 	bufferStorage+1,x
		jmp 	_IOILoop
_IOIExit:		
		set16 	temp0,bufferCount 
		rts

		.send 	code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
