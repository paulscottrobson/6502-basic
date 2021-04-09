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
		ora 	#$C0 						; at $1F9C0
		sta 	$9F20
		lda 	#$F9		
		sta 	$9F21
		lda 	#$11
		sta 	$9F22
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
		lda 	#$C0 						; point VRAM data pointer to $1F9C0 increment
		sta 	$9F20
		lda 	#$F9
		sta 	$9F21
		lda 	#$11
		sta 	$9F22
_SCClear3:									; clear all PSG registers
		lda 	#0
		sta 	$9F23		
		lda 	$9F20
		bne 	_SCClear3		
		rts

		.send 	code

