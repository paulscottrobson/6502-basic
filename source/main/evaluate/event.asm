; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		event.asm
;		Purpose:	Event() function
;		Created:	3rd March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;								EVENT(<lexpr>,<time>) handler
;
; ************************************************************************************************

EventFunction:	;; [event(]
		jsr 	EvaluateReference			; get the variable reference.
		lda 	esType,x  			
		cmp 	#$80 						; must be int ref
		bne 	_EFType
		jsr 	CheckComma
		inx
		jsr 	EvaluateInteger		 		; get the elapsed time between firing.
		jsr 	CheckRightParen 			; finish off with the
		dex
		;

		lda 	esInt1,x 					; check max of 32767
		and 	#$80
		ora 	esInt2,x
		ora 	esInt3,x
		bne 	_EFValue
		;
		.pshy 								; get time -> temp1
		.pshx
		.device_timer
		sty 	temp1+1
		sta 	temp1
		.pulx 								; restore X.
		;
		jsr 	TOSToTemp0 					; point temp0 to the variable.
		ldy 	#3							; if -ve
		lda 	(temp0),y
		bmi 	_EFFail 	 				; straight out with fail, means on pause.
		;
		ldy 	#0 							; is the fire time zero ?
		lda 	(temp0),y
		iny
		ora 	(temp0),y
		beq 	_EFInitialise 				; if so, initialise the value but return false.
		;
		ldy 	#0 							; calculate trigger - timer
		sec
		lda 	(temp0),y
		sbc 	temp1
		iny
		lda 	(temp0),y
		sbc 	temp1+1
		bpl 	_EFFail 					; if trigger >= timer then return False
		;
		jsr 	SetEventTimer 				; reset the timer for next time.
		jsr	 	MInt32True 					; and treutn true as fired.
		.puly
		rts
		;
_EFInitialise:
		jsr		SetEventTimer 				; set trigger time to time + elapsed
_EFFail:											
		.puly
		jsr 	MInt32False
		rts

_EFValue:
		error 	BadValue
_EFType:
		error 	BadType		


SetEventTimer:
		ldy 	#0 							; add elapsed to current time, store in variable
		clc
		lda 	temp1
		adc 	esInt0+1,x
		sta		(temp0),y
		iny
		lda 	temp1+1
		adc 	esInt1+1,x
		sta		(temp0),y
		;
		dey
		ora 	(temp0),y 					; if the result is non zero, exit
		bne 	_SETExit

		lda 	#1 							; timer zero won't work, so make it 1, which is 
		sta 	(temp0),y 					; near enough.
_SETExit:
		rts

		.send 	code

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
		