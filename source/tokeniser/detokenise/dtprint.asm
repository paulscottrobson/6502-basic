; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		dtprint.asm
;		Purpose:	Printing functions for detokenising.
;		Created:	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;								Print integer at TOS,X in base A
;
; ************************************************************************************************

DTPrintInteger:
		pha
		set16 	temp0,convertBuffer
		.puly
		txa
		.main_inttostr
		tax

; ************************************************************************************************
;
;					Print length prefix string at temp0, with bit 7 stripped
;		
; ************************************************************************************************

DTPrintLengthPrefix:
		.pshy
		ldy 	#0
		lda 	(temp0),y
		tax
		beq 	_DTPLPExit
_DTPLPLoop:		
		iny
		lda 	(temp0),y
		and 	#$7F	
		jsr 	ListOutputCharacter
		dex
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
		lda 	tempShort
		cmp 	#32
		bcs		_LOCHiBit
		ora 	#64
		cmp 	#64
		beq 	_LOCHiBit
		cmp 	#65+26
		bcs 	_LOCHiBit
		adc 	#32
_LOCHiBit:				
		jsr 	_LOCCallVector
		.puly
		.pulx
		pla
_LOCExit:		
		rts
_LOCCallVector:
		jmp 	(deTokeniseVector)

; ************************************************************************************************
;
;						Printer for list to output device
;
; ************************************************************************************************

deTokenPrint:
		cmp 	#0
		bmi 	_dtpInk
		.device_print
		rts
_dtpInk:cmp 	#255
		beq 	_dtpCR
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
		cmp 	LastCharacterClass
		beq 	_DTSMNoChange
		sta 	LastCharacterClass
_DTSMExit:		
		rts
_DTSMNoChange:
		cmp 	#1
		beq 	_DTSMExit
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
