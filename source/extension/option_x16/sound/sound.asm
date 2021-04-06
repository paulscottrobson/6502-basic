; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		sound.asm
;		Purpose:	Sound storage
;		Created:	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

Channels = 16 								; # of sound channels.

		.section storage 
LiveChannels:								; # of channels currently playing
		.fill 	1		
ChannelTime:
		.fill 	Channels 					; # of ticks until channels goes silent if non-zero			
		.send storage

		.section code	

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
		lda 	#$C0 						; point VRAM data pointer to $1F9C0 increment
		sta 	$9F20
		lda 	#$F9
		sta 	$9F21
		lda 	#$11
		sta 	$9F22
_SCClear2:									; clear all PSG registers
		lda 	#0
		sta 	$9F23		
		lda 	$9F22
		bne 	_SCClear2
		rts

		.send 	code