; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		find.asm
;		Purpose:	Locate a variable
;		Created:	1st March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;					(codePtr),y points to the variable and it is already setup
;
; ************************************************************************************************

FindVariable:
		.pshy
		;
		tya 								; point temp2 to the actual name.
		clc
		adc 	codePtr
		sta 	temp2
		lda 	codePtr+1
		adc 	#0
		sta 	temp2+1
		;
		ldy 	#0
		lda 	hashList 					; copy hashlist to temp0
		sta 	temp0
		lda 	hashList+1
		sta 	temp0+1
		;
		;		Loop. First follow link (temp0)
		;
_FVNext:ldy 	#1 							; get MSB
		lda 	(temp0),y
		beq 	_FVFail
		tax
		dey		 							; get LSB
		lda 	(temp0),y
		sta 	temp0 						; update pointer.
		stx 	temp0+1
		;
		;		Check the hash at offset 4 matches
		;
		ldy 	#4 							; check hashes match
		lda 	(temp0),y
		cmp 	varHash
		bne 	_FVNext 					; if not, no point in checking the name.
		;
		;		Copy the name address into temp1.
		;
		dey 								; copy name pointer to temp1.
		lda 	(temp0),y
		sta 	temp1+1
		dey
		lda 	(temp0),y
		sta 	temp1
		;
		;		Compare (temp1) against (temp2)
		;
		ldy 	#0 						
_FVCheck:
		lda 	(temp1),y 					; compare names
		cmp 	(temp2),y
		bne 	_FVNext		 				; fail if different.
		iny
		cmp 	#$3A 						; until reached the end marker.
		bcc 	_FVCheck 
		;
		.puly 								; return with CS as found.
		sec 
		rts
		
		;
		;		Didn't find it, return CC
		;
_FVFail:
		.puly
		clc
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
		