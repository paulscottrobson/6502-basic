; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		x16break.asm
;		Purpose:	Break check X16
;		Created:	12th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;								Synchronisation and Break Check (must preserve Y)
;
; ************************************************************************************************

X16SyncBreak: ;; <syncbreak>
		.pshy
		jsr 	$FFDE
		ldy 	nextSyncTick 				; if NST = 0 then always sync
		tay 								; save tick in Y
		sec
		sbc 	nextSyncTick 				; calculate timer - next tick
		bmi 	_X16NoSync 					; if -ve then no sync.
_X16Sync:
		tya 								; get current time back
		clc 								; work out time of next tick.
		adc 	#6 							; at 60Hz that is six ticks.		
		sta 	nextSyncTick
		lda 	#$FD 						; call the extension update code.
		.extension_execown
_X16NoSync:
		.puly
		jsr 	$FFE1
		beq 	_IsBreak
		rts
_IsBreak:
		.throw 	Break

		.send 	code		
