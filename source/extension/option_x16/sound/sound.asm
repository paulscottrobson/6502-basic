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
;		These are the values used in the SOUND command.
;
sndPitch: 									; 16 bit pitch to play, as specified in Vera Documents.
		.fill 	2		
;
;		These are updated using the token table so the order matters.
;		
sndChannel: 								; channel to use ($FF find unused from top down)
		.fill 	1			
sndTime:									; time to play (in 1/10s)
		.fill 	1		
sndType: 									; output type waveform 0-3, as Vera documents.
		.fill 	1		
sndVolume: 									; volume 0-63.
		.fill 	1		

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
		.byte 	TKW_TO,TKW_FOR,TKW_TYPE,TKW_STEP
		;
		;		Make sound out of the data.
		;
_CSDoSound:
		ldx 	sndChannel 					; if channel >= 16 look for channel unused.
		cmp 	#16
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
		lda 	sndTime 					; get how long
		beq 	_CSExit 					; if zero then exit
		sta 	channelTime,x 				; set the channel time for this channel.
		inc 	liveChannels 				; one more channel playing
		;
		txa 								; point to Channel A
		jsr 	CSPointChannel 		
		lda 	sndPitch 					; write pitch out
		sta 	$9F23
		lda 	sndPitch+1
		sta 	$9F23
		lda 	sndVolume 					; get volume, max out at 63.
		cmp 	#64
		bcc 	_CSHaveVolume 			
		lda 	#63
_CSHaveVolume:		
		ora 	#$C0 						; both channels
		sta 	$9F23 						; write out.
		;
		lda 	sndType 					; get waveform (bits 0-1 Pulse, Sawtooth, Triangle Noise)
		ror 	a 							; rotate into position 7,6
		ror 	a
		ror 	a
		and 	#$C0 						; mask other bits
		ora 	#63 						; 50% duty cycle.
		sta 	$9F23
_CSExit:
		rts

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
		lda 	#$C0 						; point VRAM data pointer to $1F9C0 increment
		sta 	$9F20
		lda 	#$F9
		sta 	$9F21
		lda 	#$11
		sta 	$9F22
_SCClear2:									; clear all PSG registers
		lda 	#0
		sta 	$9F23		
		lda 	$9F20
		bne 	_SCClear2
		rts

; ************************************************************************************************
;
;									Playing(x) is sound playing ?
;
; ************************************************************************************************

Unary_Playing:		;; [playing(]
		pha 						; save stack position
		lda 	(codePtr),y 		; check for playing()
		cmp 	#TKW_RPAREN
		beq 	_UPCount
		pla 						; get SP back.
		pha
		.main_evaluatesmall 		; get address.
		.main_checkrightparen 		; check right bracket
		.pulx 						; get stack back in X.
		stx 	tempShort 			; save X
		lda 	esInt0,x 			; check level, must be < 16
		cmp 	#16
		bcs 	_UPValue
		tax 						; get the time
		lda 	ChannelTime,x 		; 0 if zero, 255 if non-zero.
		beq 	_UPZero
		lda 	#255
_UPZero:		
		ldx 	tempShort 			; stack pointer back
		sta 	esInt0,x 			; return value
_UPSet13:		
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		rts
_UPValue:
		.throw 	BadValue

_UPCount:
		iny 						; skip )
		.pulx 						; get stack back in X.
		lda 	LiveChannels
		sta 	esInt0,x
		lda 	#0
		beq 	_UPSet13

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
		sta 	$9F23
		sta 	$9F23
		sta 	$9F23
		sta 	$9F23
_SINext:dex
		bpl 	_SILoop		
_SIExit:		
		rts

		.send 	code