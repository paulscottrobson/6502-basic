; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vpeekpoke.asm
;		Purpose:	Peek/Poke Vera Memory
;		Created:	5th March 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;										VPoke/VDoke
;
; ************************************************************************************************

Command_VPoke:		;; [vpoke]
		sec 						; one byte , CS
		bcs 	CmdVideoWrite		
Command_VDoke:		;; [vdoke]
		clc 						; two bytes, CC
CmdVideoWrite:		
		php 						; save one or two btes
		lda 	#0  				; get address and value into levels 0,1
		.main_evaluateint
		.main_checkcomma
		lda 	#1
		.main_evaluateint
		ldx 	#0
		jsr 	SetUpTOSVRamAddress ; copy target address to VRAM address registers
		;
		lda 	esInt0+1 			; get MSB of write value
		sta 	X16VeraData0
		;
		plp 						; if it was Poke then exit
		bcs 	_CVWExit
		lda 	esInt1+1 			; doke, write the MSB.
		sta 	X16VeraData0
_CVWExit:
		rts

; ************************************************************************************************
;
;		Write the 17 bit address in TOS,X to the VRAM address registers in Vera
;
; ************************************************************************************************

SetUpTOSVRamAddress:
		lda 	esInt2,x 			; check range of address, data to $FFFF
		and 	#$FE
		ora 	esInt3,x
		bne 	CVWValue
		lda 	esInt0,x			; set address up
		sta 	X16VeraAddLow
		lda 	esInt1,x
		sta	 	X16VeraAddMed
		lda 	esInt2,x
		and 	#1
		ora 	#$10 				; step 1.
		sta 	X16VeraAddHigh
		rts		
CVWValue:
		.throw 	BadValue

; ************************************************************************************************
;
;										VPeek/VDeek
;
; ************************************************************************************************

Command_VPeek:		;; [vpeek(]
		sec 						; one byte , CS
		bcs 	CmdVideoRead
Command_VDeek:		;; [vdeek(]
		clc 						; two bytes, CC
CmdVideoRead:		
		php 						; save action on stack.
		pha 						; save stack position
		.main_evaluateint 			; get address.
		.main_checkrightparen 		; check right bracket
		.pulx 						; get stack back in X.
		;
		jsr 	SetUpTOSVRamAddress	; set up VRAM address.
		;
		lda 	#0 					; zero upper 3 bytes
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		;
		lda 	X16VeraData0				; copy 1st byte
		sta 	esInt0,x
		plp 						; check if DOKE (carry was clear)
		bcs 	_CVRExit
		lda 	X16VeraData0 				; copy 2nd byte
		sta 	esInt1,x
_CVRExit:
		txa 						; return X position.
		rts
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
