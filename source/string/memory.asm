; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		memory.asm
;		Purpose:	String memory handler
;		Created:	27th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section zeroPage

softMemAlloc: 								; memory allocated for temporary strings
		.fill 	2  							; if MSB is zero needs resetting on allocation.

		.send 	zeroPage

		.section code		

; ************************************************************************************************
;
;		Allocate A bytes of soft string memory, and set the current pointer (softMemAlloc)
;		to it with an empty string. 
;
;		Soft string is for intermediate calculations, and is allocate 256 bytes below the 
;		current end of memory. To store a string, it has to be 'concreted'
;
; ************************************************************************************************


AllocateSoftString: 						; allocae soft string memory
		sta 	tempShort 					; save count
		pshy 								; save Y

		lda 	softMemAlloc+1 				; if the high byte is zero, it needs allocating.
		bne 	_ASSDone

		lda 	highMemory 					; reset the soft memory alloc pointer.
		sta 	softMemAlloc 				; to speed up slightly, we only reset this when we first need it
		ldy 	highMemory+1 				; but it needs to be reset before each command.
		dey
		sty 	softMemAlloc+1

_ASSDone:
		sec 								; allocate downwards enough memory
		lda 	softMemAlloc 
		sbc 	tempShort
		sta 	softMemAlloc
		lda 	softMemAlloc+1
		sbc 	#0
		sta 	softMemAlloc+1
		;
		lda 	#0 							; empty that string, set the length = 0.
		tay
		sta 	(softMemAlloc),y
		puly 								; restore Y and exit.
		rts

; ************************************************************************************************
;
;							Write character A to current soft string
;
; ************************************************************************************************

WriteSoftString:
		sty 	tempShort 					; save Y
		;
		pha
		ldy 	#0 							; get and bump length
		lda 	(softMemAlloc),y
		clc
		adc 	#1
		sta 	(softMemAlloc),y
		tay 								; pointer in Y
		;
		pla 								; get char and write.
		sta 	(softMemAlloc),y
		ldy 	tempShort 					; restore Y and exit.
		rts

		.send code		
		