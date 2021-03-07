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
		ldx 	#0  				; get address and value into levels 0,1
		jsr 	XEvaluateInteger
		jsr 	CheckComma
		inx
		jsr 	XEvaluateInteger
		dex
		jsr 	SetUpTOSVRamAddress ; copy target address to VRAM address registers
		;
		lda 	esInt0+1 			; get MSB of write value
		sta 	$9F23
		;
		plp 						; if it was Poke then exit
		bcs 	_CVWExit
		lda 	esInt1+1 			; doke, write the MSB.
		sta 	$9F23
_CVWExit:
		rts

; ************************************************************************************************
;
;		Write the 17 bit address in TOS,X to the VRAM address registers in Vera
;
; ************************************************************************************************

SetUpTOSVRamAddress:
		lda 	esInt2,x 			; check range of address, data to $FFFF
		and 	#1
		ora 	esInt3,x
		bne 	CVWValue
		lda 	esInt0,x			; set address up
		sta 	$9F20
		lda 	esInt1,x
		sta	 	$9F21
		lda 	esInt2,x
		and 	#1
		ora 	#$10 				; step 1.
		sta 	$9F22
		rts		
CVWValue:
		error 	BadValue

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
		tax 						; save stack position
		jsr 	XEvaluateInteger 	; address
		jsr 	CheckRightParen 	; closing right bracket.
		;
		jsr 	SetUpTOSVRamAddress	; set up VRAM address.
		;
		jsr 	MInt32False 		; zero return.
		;
		lda 	$9F23				; copy 1st byte
		sta 	esInt0,x
		plp 						; check if DOKE (carry was clear)
		bcs 	_CVRExit
		lda 	$9F23 				; copy 2nd byte
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
