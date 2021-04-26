; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		soundsync.asm
;		Purpose:	Sound sync/update code
;		Created:	9th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;							Sound 'interrupt', called every 1/10 second
;
; ************************************************************************************************

SoundInterrupt:
		lda 	LiveChannels 		; anything playing ?
		beq 	_SIExit
		ldx 	#15 				; check each channel ?
_SILoop:lda 	channelTime,x 		; time left ?
		beq 	_SINext 	 		; if zero not playing
		sec 						; subtract one from time
		sbc 	#1
		sta 	channelTime,x
		bne 	_SINext 			; if non zero, time for sound off.
		dec 	LiveChannels 		; one fewer channels.
		txa 						; point to sound PSG
		jsr 	CSPointChannel 		
		lda 	#0 					; zero it all out
		sta 	X16VeraData0
		sta 	X16VeraData0
		sta 	X16VeraData0
		sta 	X16VeraData0
		txa 						; check the queue for this for more notes.
		jsr 	SoundCheckQueue
_SINext:dex
		bpl 	_SILoop		
_SIExit:		
		rts

		.send 	code
		