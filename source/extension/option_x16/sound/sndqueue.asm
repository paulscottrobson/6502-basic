; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		sndqueue.asm
;		Purpose:	Sound queue handlers
;		Created:	9th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************


		.section code	

; ************************************************************************************************
;
;				Add data at address YX to queue (4 byte play info, channel, tiem)
;
; ************************************************************************************************

SoundAddQueue:
		stx 	temp0 						; save XY in temp0
		sty 	temp0+1
		;
		ldx 	#0 							; look for empty spot.
_SAQFind:
		lda 	sndQueue,x 					; check if first byte (time) zero means clear.
		beq 	_SAQFound
		txa 								; forward 6
		clc
		adc 	#6
		tax		
		cpx 	#sndQueueSize*6 			; queue is full ?
		bcc 	_SAQFind
		.throw 	Hardware 					; sound queue is full.
_SAQFound:
		ldy 	#5 							; get and save time
		lda 	(temp0),y
		sta 	sndQueue+0,x
		dey 								; get and save the channel.
		lda 	(temp0),y
		sta 	sndQueue+1,x
		ldy 	#0
_SAQCopy1:
		lda 	(temp0),y 					; copy 4 bytes of PSG data in.
		sta 	sndQueue+2,x
		iny
		inx
		cpy 	#4
		bne		 _SAQCopy1		
		rts

; ************************************************************************************************
;
;									Check queue for channel A
;
; ************************************************************************************************

SoundCheckQueue:
		sta 	temp0 						; save channel #
		.pshx
		.pshy
		ldx 	temp0 						; is the channel in use, if so we cannot play.
		lda 	channelTime,x
		bne 	_SCQExit
		;
		ldx 	#0 							; work through queue.
_SCQSearch:
		lda 	sndQueue,x 					; reached the end, e.g. time = 0
		beq 	_SCQExit
		lda 	sndQueue+1,x 				; compare channel #
		cmp 	temp0
		beq 	_SCQFound 					
		;
		txa
		clc
		adc 	#6
		txa
		jmp 	_SCQSearch
		;
_SCQFound: 									; found a note to play. channel temp0, time,ch,data.
		;
		ldy 	temp0 						; Y = channel #
		lda 	sndQueue,x 					; get time
		sta 	channelTime,y 				; write that in the time channel slot
		inc 	LiveChannels 				; one more playing.
		;
		.pshx 								; save X
		lda 	temp0 						; get channel #
		jsr 	CSPointChannel  			; point VRAM pointer to it.
		ldy 	#4 							; counter
_SCQCopy:
		lda 	sndQueue+2,x 				; copy the sound production data to the PSG
		sta 	$9F23
		inx
		dey
		bne 	_SCQCopy
		.pulx 								; restore X.
		;
_SCQDelete:
		lda 	sndQueue+6,x 				; delete the queue entry
		sta 	sndQueue,x
		inx
		cpx 	#sndQueueSize*6+1
		bne 	_SCQDelete
_SCQExit:				
		.puly
		.pulx
		rts		

		.send 	code	