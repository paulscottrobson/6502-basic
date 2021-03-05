; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		vpeekpoke.asm
;		Purpose:	Peek/Poke Vera Memory
;		Created:	5th March 2021
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
		php
		ldx 	#0  				; get address into levels 0,1
		jsr 	EvaluateInteger
		jsr 	CheckComma
		inx
		jsr 	EvaluateInteger

		lda 	esInt2,x 			; check range of address, data to $FFFF
		and 	#1
		ora 	esInt3,x
		ora 	esInt2+1,x
		ora 	esInt3+1,x
		bne 	_CVWValue
		;
		lda 	esInt0				; set address up
		sta 	$9F20
		lda 	esInt1
		sta	 	$9F21
		lda 	esInt2
		and 	#1
		ora 	#$10 				; step 1.
		sta 	$9F22
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

_CVWValue:
		error 	BadValue
		.send code