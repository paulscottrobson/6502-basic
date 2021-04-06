; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		access.asm
;		Purpose:	Access an array (multidimensional version)
;		Created:	17th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		

; ************************************************************************************************
;
;									Access Array element
;
; ************************************************************************************************

AccessArray:
		;
		;		Get the indices of the array
		;
		.pshx 								; preserve X
		inx
		jsr 	GetArrayDimensions 			; get the array dimensions one up from here.
		.pulx
		;
		;		Copy address of first array block => temp0
		;
		lda 	esInt0,x 					; restore address to follow in temp0.
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		.pshx 								; save XY
		.pshy
		;
		;		Follow the array indices - main loop
		;
_AAFollow:
		;
		;		do (temp0) => temp0, e.g. follow link to array block.
		;
		ldy 	#0 							
		lda 	(temp0),y
		pha
		iny
		lda 	(temp0),y
		sta 	temp0+1
		pla
		sta 	temp0
		;
		;		Check the relevant index in the next stack slot
		;		
		inx 								; advance to next stack slot.
		ldy 	#0
		lda 	(temp0),y 					; compare max index vs required index
		cmp 	esInt0,x
		iny
		lda 	(temp0),y 					; drop bit 7 of the size, indicates follow.
		sta 	temp1 						; save the size in temp1 for later use.
		and 	#$7F
		sbc 	esInt1,x
		bcc 	_AABadIndex 				; failed on index if max index < required.
		;
		;		Advance temp0 by 2, skipping the size word
		;
		clc
		lda 	temp0
		adc 	#2
		sta 	temp0
		bcc 	_AANoCarry
		inc 	temp0+1
_AANoCarry:
		;
		;		Copy the index into temp2
		;
		lda 	esInt0,x
		sta 	temp2
		lda 	esInt1,x
		sta 	temp2+1
		;
		;		Calculate size of data type.
		;
		ldy 	varType
		lda 	CAActualSize-$3A,y
		ldy 	esType+1,x 					; is it top level
		bmi 	_AANotPointer
		lda 	#2 							; array of pointers is 2.
_AANotPointer:
		;
		;		Multiply by index and add to temp0
		;
		jsr 	MultiplyTemp2ByA 			; multiply the index by the data size, in temp2.
		clc
		lda 	temp0
		adc 	temp2
		sta 	temp0
		lda 	temp0+1
		adc 	temp2+1
		sta 	temp0+1
		;
		;		Check if there is another 
		;
		lda 	esType+1,x 					
		bmi 	_AAUsedAllIndices
		;
		;		Check if we can go round again, and if so do so.
		;
		lda 	temp1 						; check if this is a pointer array e.g. there are subarrays
		bpl 	_AABadDepth 				; no, too many indexes.
		jmp 	_AAFollow 					; otherwise follow them.
		;
		;		Reached the end, check all indices have been used
		;
_AAUsedAllIndices:		
		lda 	temp1 						; get original high length byte.
		bmi 	_AABadDepth 				; if -ve then this is an array of pointers.		
		.puly 								; restore YX
		.pulx
		lda 	temp0 						; copy address of array element to stack,x
		sta 	esInt0,x
		lda 	temp0+1
		sta 	esInt1,x
		rts

_AABadDepth:
		.throw 	ArrayDepth
_AABadIndex:
		.throw 	ArrayIndex		

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
