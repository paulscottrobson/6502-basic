; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		joystick.asm
;		Purpose:	Joystick code
;		Created:	30th March 2021
;		Reviewed: 	27th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						joy.x() and joy.y() seperated by carry flag
;
; ************************************************************************************************

Unary_JoyX:	;; [joy.x(]
		sec
		bcs 	JoystickRead
Unary_JoyY:	;; [joy.y(]
		clc
JoystickRead:
		pha 								; save stack position
		php 								; save test flag.
		.main_checkrightparen 				; check )
		jsr 	ReadJoystick 				; read it.
		plp 								; get back axis
		bcs 	_JRNoShift 					; if Y, shift right twice so accessing Y axis buttons
		lsr 	a
		lsr 	a
_JRNoShift:
		and 	#3 							; isolate the test bits.
		beq 	JoyReturnA 					; if nothing pressed, return A.
		cmp 	#3
		beq 	JoyReturnFalse 				; could be both on a keyboard.
		lsr 	a 							; bit 0 set, its +1
		bcs 	JoyReturn1

JoyReturnTrue:								; return -1.
		lda 	#$FF
		bne 	JoyReturnA
JoyReturnFalse:								; return 0
		lda 	#0
JoyReturnA:
		sta 	tempShort 					; return A
		.pulx
		lda 	tempShort
		sta 	esInt0,x
JoyReturn13:		
		sta 	esInt1,x
		sta 	esInt2,x
		sta 	esInt3,x
		txa 								; return NSP in A
		rts

JoyReturn1: 								; return +1
		.pulx
		lda 	#1
		sta 	esInt0,x
		lda 	#0
		beq 	JoyReturn13

; ************************************************************************************************
;
;									Read joystick button
;
; ************************************************************************************************

Unary_JButton: 	;; [joy.b(]
		pha 								; save X on stack, put in X
		.main_evaluatesmall 				; evaluate button #
		tax 								; get value to check, push on stack.
		lda 	esInt0,x
		cmp 	#4 							; check button # 0-3
		bcs 	_UJBadValue
		adc 	#5 							; four more shifts to get the bit into carry.
		pha 								; save that shift count on the stack.
		.main_checkRightparen 				; check for )
		;
		.pulx 								; get count into X
		jsr 	ReadJoystick 				; joystick read
_UJShift: 									; shift into carry button+5 times.
		lsr 	a
		dex
		bne 	_UJShift
		bcs 	JoyReturnTrue
		bcc 	JoyReturnFalse

_UJBadValue:
		.throw 	Hardware

; ************************************************************************************************
;
;		Read current joystick. Bodged to work as bug where initially returns $00
;		(e.g. all buttons pressed) which is assumed to be the bug !
;
; ************************************************************************************************

ReadJoystick:
		.pshx
		.pshy
		lda 	#0
		jsr 	X16KReadJoystick 						
		cpy 	#0
		bne 	_RJError
		cmp 	#0 							; bug, returns $00 initially, which means all the
		bne 	_RJNoBug 					; buttons are pressed, so we assume you haven't actually
		lda 	#$FF 						; done this !
_RJNoBug:		
		sta 	tempShort
		.puly
		.pulx
		lda 	tempShort
		eor 	#$FF 						; active 1 bit.
		rts
_RJError:
		.throw 	Hardware
		.send 	code	

		