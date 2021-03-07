; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		compare.asm
;		Purpose:	Comparison for strings
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;					Compare two strings TOS, return $FF,$00,$01 in X,  SP = A
;
; ************************************************************************************************

STRCompare:	;; <sCompare>
		pha 								; save A
		tax 								; put stack pos in X
		.pshy								; save Y
		jsr 	CopyStringPair

		ldy 	#0 							; get the smaller of the two string sizes.
		lda 	(temp0),y
		cmp 	(temp1),y
		bcc 	_SCNotSmaller
		lda 	(temp1),y
_SCNotSmaller:
		tax 								; put that in X. We compare this many chars first.
	
_SCCompareLoop:
		cpx 	#0 							; if compared all the smaller, then it is the shorter
		beq 	_SCSameToEndShortest 		; one that is the smallest if they are different lengths.
		dex 								; decrement chars to compare.
		;
		iny 								; move to next character
		sec 								; calculate s1[y]-s2[y]
		lda 	(temp0),y
		sbc 	(temp1),y 
		bne 	_SCReturnResult 			; if different return sign of A
		jmp 	_SCCompareLoop
		;
		;		As far as the common length, they are the same, so the lesser depends on the length.
		;
_SCSameToEndShortest		
		ldy 	#0 							; compare len(s1) - len(s2)
		sec		
		lda 	(temp0),y
		sbc 	(temp1),y 
		;
		;		If Z return 0. If CC return -1. If CS & NZ return 1.
		;
_SCReturnResult:
		php 								; set return to zero preserving PSW.
		ldx 	#0
		plp
		beq 	_SCExit 					; two values equal, then exit
		dex 								; X = $FF
		bcc 	_SCExit 					; if 1st < 2nd then -1
		ldx 	#1 							; X = $01 if greater
_SCExit:
		.puly 								; restore YA and exit with result in X
		pla
		rts

; ************************************************************************************************
;
;							Copy string addresses to temp0,temp1
;
; ************************************************************************************************

CopyStringPair:
		lda 	esInt0+1,x
		sta 	temp1
		lda 	esInt1+1,x
		sta 	temp1+1
CopyStringTop:		
		lda 	esInt0,x		
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		rts

		.send code		
		
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
