; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		dtprint.asm
;		Purpose:	Printing functions for detokenising.
;		Created:	7th March 2021
;		Reviewed: 	16th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
tPrintCount:
		.fill 	1
		.send storage

		.section code

; ************************************************************************************************
;
;								Print integer at TOS,X in base A
;
; ************************************************************************************************

DTPrintInteger:
		pha									; save base
		set16 	temp0,convertBuffer 		; set convert buffer addr
		.puly 								; base in Y and convert stack level in A.
		txa
		.main_inttostr
		tax 								; then drop through here.

; ************************************************************************************************
;
;					Print length prefix string at temp0, with bit 7 stripped
;		
; ************************************************************************************************

DTPrintLengthPrefix:
		tax 								; A = 0 = don't case convert.
		.pshy 								; save Y
		ldy 	#0 							; get string length = chars to print.
		lda 	(temp0),y
		sta 	tPrintCount
		beq 	_DTPLPExit 					; empty string
_DTPLPLoop:		
		iny 								; get next.
		lda 	(temp0),y
		and 	#$7F	
		cpx 	#0 							; skip if not case converting
		beq 	_DTPLPNoCase
		cmp 	#"A" 						; if converting UC -> LC
		bcc 	_DTPLPNoCase
		cmp 	#"Z"+1
		bcs 	_DTPLPNoCase
		eor 	#"A"^"a"
_DTPLPNoCase		
		jsr 	ListOutputCharacter 		; call handler
		dec 	tPrintCount 				; do all the characters
		bne 	_DTPLPLoop		
_DTPLPExit:	
		.puly			
		rts

; ************************************************************************************************
;
;			Print for listing. Expects CR, ASCII and 1..9 for colour elements
;
; ************************************************************************************************

ListOutputCharacter:
		sta 	tempShort
		pha
		.pshx
		.pshy
		lda 	tempShort 					; convert ASCII 6 bit (0-31) to 7 bit.
		cmp 	#32
		bcs		_LOCHiBit
		ora 	#64 						; conversion
		cmp 	#64							; make l/c
		beq 	_LOCHiBit
		cmp 	#65+26
		bcs 	_LOCHiBit
		adc 	#32
_LOCHiBit:				
		jsr 	_LOCCallVector				; call o/p handler routine
		.puly
		.pulx
		pla
_LOCExit:		
		rts
_LOCCallVector: 							; allow detokenising to other places.
		jmp 	(deTokeniseVector)

; ************************************************************************************************
;
;						Printer for list to output device
;
; ************************************************************************************************

deTokenPrint:
		cmp 	#0 							; if bit 7 sets ink colour
		bmi 	_dtpInk
		.device_printascii
		rts
_dtpInk:cmp 	#255 						; e.g. herhe, get ink and set it
		beq 	_dtpCR						; except $FF => CRLF
		and 	#7
		.device_ink
		rts
_dtpCR:	.device_crlf
		rts		

; ************************************************************************************************
;
;		Switch mode, punctuation or identifier constant, may need space
;
; ************************************************************************************************

DTSwitchMode:
		cmp 	LastCharacterClass 			; if changed, update character class
		beq 	_DTSMNoChange
		sta 	LastCharacterClass
_DTSMExit:		
		rts
_DTSMNoChange:
		cmp 	#1 							; if didn't change to punctuation, two identifiers so we
		beq 	_DTSMExit 					; need a space.
		lda 	#" "
		jmp 	ListOutputCharacter

		.send code

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
