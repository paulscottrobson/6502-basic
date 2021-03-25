; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		mode.asm
;		Purpose:	Screen Mode command.
;		Created:	18th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage 
currentMode:
		.fill 	4		
		.send storage

		.section code	

; ************************************************************************************************
;
;				Force Mode 0 if some weird mode you've set up yourself.
;
; ************************************************************************************************

ForceMode0:	
		ldx 	#0
		stx 	esInt0 						; in case we do it.
_FMCheck:
		lda 	CMModeList,x 				; do we need to switch ?
		cmp 	currentMode,x
		bne 	CMSetMode 					; different so switch.
		inx
		cpx 	#4
		bne 	_FMCheck
		rts

; ************************************************************************************************
;
;								Mode <32 bit descriptor>
;
; ************************************************************************************************

CommandMode:	;; [mode]
		lda 	#0
		.main_evaluateint
		;
		lda 	esInt3
		and 	#$70
		bne 	CMNoExpand
CMSetMode:		
		jsr 	CMExpandMode
		jmp 	CMUpdateMode
CMNoExpand:		
		lda 	esInt0
		sta 	currentMode
		lda 	esInt1
		sta 	currentMode+1
		lda 	esInt2
		sta 	currentMode+2
		lda 	esInt3
		sta 	currentMode+3
		;
		;		Update the mode with the current mode.
		;
CMUpdateMode:		
		;
		;		Clear $9F29 to $9F3A
		;
		ldx 	#$11
_CMClear:
		lda 	#0
		sta 	$9F29,X
		dex
		bpl 	_CMClear		
		;	
		;		Expand byte 3 which is the general setup.
		;	
		lda 	currentMode+3 				; get current mode
		pha 								; stack twice.
		pha
		and 	#$70 						; isolates bits 6,5,4 (sprites,L1 enable,L0 enable)
		ora 	#$01 						; turn the output on.
		sta 	$9F29 						; write to DC_VIDEO
		;
		pla 								; get back
		jsr 	CMToScale 					; convert lower 2 bits to a scale.
		sta 	$9F2A 						; write to H-Scale
		;
		pla 								; get back, convert bits 2,3 to a scale.
		lsr 	a
		lsr 	a
		jsr 	CMToScale 					; convert lower 2 bits to a scale.
		sta 	$9F2B
		; 
		ldx 	#0 							; this is offset from $9F2D to do L0
		lda 	currentMode					; get L0 config byte
		jsr 	CMDecodeLayer 				; and decode layer 0
		;
		ldx 	#7 							; when we do layer 1, offset by 7 hence starts at $9F34
		lda 	currentMode+1
		jsr 	CMDecodeLayer
		rts


; ************************************************************************************************
;
;			Expand mode when esInt3 is x000xxxx, allows a library of sensible modes
;
; ************************************************************************************************

CMExpandMode:
		lda 	esInt0 						; get mode number
		cmp 	#(CMEndModeList-CMModeList) >> 2
		bcs 	_CMModeError
		asl 	a 							; x 4 into X
		asl 	a
		tax
		.pshy 								; save Y.
		ldy 	#0
_CMEMCopy:
		lda 	CMModeList,x
		sta 	currentMode,y
		inx
		iny
		cpy 	#4
		bne 	_CMEMCopy
		.puly
		rts

_CMModeError:
		.throw	BadValue

CMModeList:
		.dword	$20006000 					; Mode 0 which is the standard 80x60 mode, no sprites
CMEndModeList:

; ************************************************************************************************
;
;						Convert the lower 2 bits to a scalar 80 40 20 10
;
; ************************************************************************************************

CMToScale:
		and 	#3 							; lower 2 bits only
		tax 								; put in X for counting
		lda 	#0 							; zero result
		sec 								; first time rotate CS in
_CMTSLoop:
		ror 	a
		dex
		bpl 	_CMTSLoop
		rts

; ************************************************************************************************
;
;					Decode layer byte A to offseet X $9F2D onwards
;
; ************************************************************************************************

CMDecodeLayer:
		pha 								; save it.
		and 	#$F7 						; all the bits except T256C which you can't set using this
		sta 	$9F2D,X
		;
		pla 								; get it back
		and 	#$08 						; the missing bit sets the tile size.
		beq 	_CMDLNotSet
		lda 	#$03 						; which sets both lower bits, they're square.
_CMDLNotSet:
		cpx 	#0 
		beq 	_CMDLayer0 					; layer 1 has standard defaults for tile table, e.g. $7C
		;
		ora 	#$7C 						; so set those bits and write it out.
		sta 	$9F2F,X
		rts	

_CMDLayer0: 								; layer 0 
		ora 	#$80 						; tile base is $80
		sta 	$9F2F,X
		rts

		.send code