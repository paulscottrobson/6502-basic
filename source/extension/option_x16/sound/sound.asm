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
;
;		These are the values used in the SOUND command, and the 4 byte buffer that is queued.
;		+ 2 bytes of additional data.
;
sndPitch: 									; 16 bit pitch to play, as specified in Vera Documents.
		.fill 	2		
sndExtra:
		.fill 	2		
;
;		These are updated using the token table so the order matters.
;		
sndChannel: 								; channel to use ($FF find unused from top down)
		.fill 	1			
sndTime:									; time to play (in 1/10s)
		.fill 	1		
;
;
;
sndType: 									; output type waveform 0-3, as Vera documents.
		.fill 	1		
sndVolume: 									; volume 0-63.
		.fill 	1		
;
;		Sound queue. 6 bytes per entry. Time (00 = Not used), Channel, 4 Byte Data.
;		Fits into one page so 42 or fewer entries here
;
sndQueueSize = 16

sndQueue:
		.fill	6*sndQueueSize+1 			; extra byte is so copy zero when deleting last element.

		.send storage

		.section code	

; ************************************************************************************************
;
;										Sound command
;
; ************************************************************************************************

CommandSound:	;; [sound]
		lda 	#0 							; clear the default sound options
		sta 	sndPitch
		sta 	sndPitch+1
		sta 	sndType
		lda 	#$FF 						; values are 255,63 are masked.
		sta 	sndChannel
		sta 	sndVolume
		lda 	#5 							; default time is 0.5s
		sta 	sndTime
_ComSoundLoop:
		lda 	(codePtr),y 				; next token
		cmp 	#TOK_EOL 					; end of line/colon do the sound
		beq 	_CSDoSound
		cmp 	#TKW_COLON
		beq 	_CSDoSound
		cmp 	#TKW_AT 					; is it AT pitch ?	
		beq 	_CSSetPitch
		;
		ldx 	#3 							; look up in the tokens table
_CSCheck:
		cmp 	_ComSoundTokens,x 			; if found token update value.
		beq 	_CSFoundToken
		dex
		bpl 	_CSCheck
		iny
		cmp 	#TKW_CLEAR 					; was it sound CLEAR
		bne 	_CSSyntax
		jmp 	SoundReset 	
_CSSyntax:		
		.throw 	Syntax
		;
		;		Found token
		;		
_CSFoundToken:
		.pshx 								; save token ID 0-3
		iny 								; skip it
		lda 	#0 							; get a small int
		.main_evaluatesmall
		.pulx 								; restore token ID
		lda 	esInt0 						; copy value to setup memory
		sta 	sndChannel,x 
		jmp 	_ComSoundLoop
		;
		;		Found AT <pitch>
		;
_CSSetPitch:	
		iny 								; skip AT
		lda 	#0 							; get an integer.
		.main_evaluateint
		lda 	esInt2 						; check range
		ora 	esInt3
		bne 	_CSBadValue
		lda 	esInt0	 					; copy into pitch and loop back
		sta 	sndPitch
		lda 	esInt1
		sta 	sndPitch+1
		jmp 	_ComSoundLoop
_CSBadValue:
		.throw 	BadValue		
		;
		;		Token table, order same as data above.
		;
_ComSoundTokens:
		.byte 	TKW_TO,TKW_TIME,TKW_TYPE,TKW_STEP
		;
		;		Make sound out of the data.
		;
_CSDoSound:
		ldx 	sndChannel 					; if channel >= 16 look for channel unused.
		cpx 	#16
		bcc 	_CSHaveChannel
		ldx 	#15
_CSFindChannel:
		lda 	channelTime,x 				; time is zero e.g. sound off.
		beq 	_CSHaveChannel 
		dex
		bpl 	_CSFindChannel 				; try all of them
		.throw 	Hardware 					; all channels in use.
		;
_CSHaveChannel:
		stx 	sndChannel 					; update channel.
		lda 	sndTime 					; get how long
		beq 	_CSExit 					; if zero then exit

		lda 	sndVolume 					; get volume, max out at 63.
		cmp 	#64
		bcc 	_CSHaveVolume 			
		lda 	#63
_CSHaveVolume:		
		ora 	#$C0 						; both channels
		sta 	sndExtra 					; write out.
		;
		lda 	sndType 					; get waveform (bits 0-1 Pulse, Sawtooth, Triangle Noise)
		ror 	a 							; rotate into position 7,6
		ror 	a
		ror 	a
		and 	#$C0 						; mask other bits
		ora 	#63 						; 50% duty cycle.
		sta 	sndExtra+1
		.pshy
		.pshx 								; save channel #
		ldx 	#sndPitch & 255 			; XY = sound data
		ldy 	#sndPitch >> 8
		jsr 	SoundAddQueue 				; add it to the queue.
		;
		pla 								; get channel #
		jsr 	SoundCheckQueue 			; check if we can play this one now, e.g. the queue was empty.
		.puly
_CSExit:
		rts

		.send 	code