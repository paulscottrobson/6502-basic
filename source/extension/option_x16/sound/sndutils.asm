; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		sndutils.asm
;		Purpose:	Sound utility functions
;		Created:	9th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						Point VRAM pointer to sound channel A
;
; ************************************************************************************************

CSPointChannel:
		asl 	a 							; 4 bytes / channel
		asl 	a
		ora 	#X16VeraSound & $FF			; at $1F9C0
		sta 	X16VeraAddLow
		lda 	#(X16VeraSound >> 8) & $FF
		sta 	X16VeraAddMed
		lda 	#(X16VeraSound >> 16) | $10
		sta 	X16VeraAddHigh
		rts

; ************************************************************************************************
;
;									Sound channels Reset
;
; ************************************************************************************************

SoundReset:
		lda 	#0							; no channels playing
		sta 	LiveChannels 		
		ldx 	#Channels-1
_SCClear:									; zero all the tick counts.
		sta 	ChannelTime,x
		dex
		bpl 	_SCClear
		;
		ldx 	#sndQueueSize*6+1 			; zero the sound queue.
_SCClear2:
		sta 	sndQueue-1,x
		dex
		bne 	_SCClear2
		;
		lda 	#X16VeraSound & $FF			; point VRAM data pointer to $1F9C0 increment
		sta 	X16VeraAddLow
		lda 	#(X16VeraSound >> 8) & $FF
		sta 	X16VeraAddMed
		lda 	#(X16VeraSound >> 16) | $10
		sta 	X16VeraAddHigh
_SCClear3:									; clear all PSG registers
		lda 	#0
		sta 	X16VeraData0		
		lda 	X16VeraAddLow
		bne 	_SCClear3		
		rts

		.send 	code

