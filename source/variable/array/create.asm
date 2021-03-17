; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		create.asm
;		Purpose:	Create an array
;		Created:	17th March 2021 (version 2)
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

elementSize:								; size of one element in array storage
		.fill	 1
		.send 	 storage

		.section code		

; ************************************************************************************************
;
;					Dim Definition - (codePtr),y points to the variable
;
; ************************************************************************************************

CreateArray:	;; <createarray>
		;
		;		Create the basic array element, checking it doesn't already exist.
		;
		jsr 	AccessSetup 				; set up the basic stuff.
		;
		lda 	varType 					; is the variable type an array
		lsr 	a
		bcc 	CANotArray 					; no, cause an error.
		;
		jsr 	FindVariable 				; does the variable exist already
		bcs 	CAFound 					; cannot redefine it.
		;
		jsr 	CreateVariable 				; create the variable entry.
		;
		lda 	temp0 						; push address of new variable entry on the stack
		pha
		lda 	temp0+1
		pha
		jsr 	GetArrayDimensions 			; get the array dimensions
		;
		;		Create array at level 0. This function calls itself recursively to create
		; 		other levels.
		;
		ldx 	#0 							; create at level $00
		jsr 	CreateArrayLevel 			; level to YA
		tax 								; level now in YX
		;
		pla 								; get address back to temp0 to write.
		sta 	temp0+1
		pla
		sta 	temp0
		;
		tya 								; write YX there.
		ldy 	#6
		sta 	(temp0),y
		dey
		txa
		sta 	(temp0),y

		ldy 	varEnd 						; restore Y and exit.
		rts

CASize:		
		.throw 	BadValue
CAFound:	
		.throw 	DupArray
CANotArray:		
		.throw 	NotArray

; ************************************************************************************************
;
;		Get array dimensions into stack. the type for the level above the last has the
;		type set to $FF
;
; ************************************************************************************************

GetArrayDimensions:
		lda 	varType 					; push variable type on the stack.
		pha
		;
		ldx 	#0 							; start index position.
		ldy 	varEnd
		;
		;		Get next index loop,
		;
_CAGetDimensions:
		txa 								; get the next level
		.main_evaluateint 
		tax				
		;
		lda 	esInt1,x 					; index must be < 8192
		and 	#$E0
		ora 	esInt2,x
		ora 	esInt3,x
		bne 	CASize 						
		;
		inx 								; next level.
		lda 	(codePtr),y 				; get/consume following character
		iny
		cmp 	#TKW_COMMA 					; loop back if more dimensions
		beq 	_CAGetDimensions
		;
		cmp 	#TKW_RPAREN 				; right bracket ?
		bne 	CASize
		;
		lda 	#$FF 						; set the type past the end to $FF so we know how many
		sta 	esType,x 					; dimensions there are.

		pla 								; restore the variable type ($3A-$3F)
		sta 	varType 					
		sty 	varEnd 						; save exit Y value, after dimensions
		rts

; ************************************************************************************************
;
;		Create an array block at level X. The array highest index is in esInt0,x esInt1,x
;
; ************************************************************************************************

CreateArrayLevel:
		;
		;		Get the size of the element this level.
		;
		ldy 	varType
		lda 	CAActualSize-$3A,y
		sta 	elementSize 				; get element size this level.
		ldy 	esType+1,x 					; is it top level
		bmi 	_CANotPointer
		lda 	#2 							; array of pointers is 2.
		sta 	elementSize
_CANotPointer:
		;
		;		Copy lowMemory to temp0 and save on stack
		;
		lda 	lowMemory 					; start creating at temp0, saving start on stack.
		sta 	temp0
		pha
		lda 	lowMemory+1
		sta 	temp0+1
		pha
		;
		;		Allocate memory for new level.
		;
		jsr 	AllocateArraySpace 			; allocate space for all array stuff at this level.
		;
		;		Copy the size of this level of the array into offsets+0,+1
		;
		ldy 	#0 					
		lda 	esInt0,x
		sta 	(temp0),y
		iny
		lda 	esInt1,x
		sta 	(temp0),y
		;		
		;		If this is an array of pointers, e.g. sub levels, then set bit 15 of the
		;		maximum index.
		;
		lda 	esType+1,x 					; do we have another level ?
		bmi 	_CALNotLast
		;
		lda 	(temp0),y 					; set bit 7, indicates an array of pointers to other levels.
		ora 	#$80
		sta 	(temp0),y
_CALNotLast:		
		;
		;		Advance pointer (temp0) past the size word.
		;
		lda 	#2
		jsr 	_CALAddTemp0
		;
		;		stack2,x and stack3,x are used as a down counter.
		;
		lda 	esInt0,x 					; copy stack:01 to stack:23 so we can use it to 
		sta 	esInt2,x 					; count.
		lda 	esInt1,x
		sta 	esInt3,x
		;
		;		Initialises all the elements in this level.
		;		
_CALClear:
		jsr 	EraseOneElement
		lda 	elementSize 				; move to next element
		jsr 	_CALAddTemp0
		;
		lda 	esInt2,x 					; decrement counter
		bne 	_CALNoBorrow
		dec 	esInt3,x
_CALNoBorrow:
		dec 	esInt2,x

		lda 	esInt3,x 					; loop back if >= 0 - we need +1 because indices
		bpl 	_CALClear 					; start at 0 e.g. x(10) is actually 11 array entries.

		pla 								; restore the start of this into YA.
		tay
		pla
		rts
;
;		Add A to temp0
;
_CALAddTemp0:
		clc
		adc 	temp0
		sta 	temp0
		bcc 	_CALANoCarry
		inc 	temp0+1
_CALANoCarry:
		rts

CAActualSize:
		.byte 	VarISize,VarISize
		.byte 	VarSSize,VarSSize
		.byte 	VarFSize,VarFSize

; ************************************************************************************************
;
;								Erase the element at temp0
;
; ************************************************************************************************

EraseOneElement:
		lda 	esType+1,x 					; is this a list of sub arrays
		bpl 	_EOESubArray
		;
		;		Erase a value - string/float/integer
		;
		ldy 	#0 							; write the empty variable value out.
		lda 	varType
		jsr 	ZeroTemp0Y		
		rts
		;
		;		Create a sub-array here - this calls CreateArrayLevel recursively.
		;
_EOESubArray:		
		lda 	temp0 						; save temp0, these are effectively locals.
		pha
		lda 	temp0+1
		pha
		lda 	elementSize 				; save element size
		pha

		inx 								; create at next level
		jsr 	CreateArrayLevel
		dex

		sta 	tempShort 					; save A
		;
		pla  								; restore element size.
		sta 	elementSize 
		pla 								; restore temp0, which is where this new array level goes.
		sta 	temp0+1
		pla 
		sta 	temp0
		;
		tya 								; store Y/A there
		ldy 	#1
		sta 	(temp0),y
		lda 	tempShort
		dey
		sta 	(temp0),y
		rts

; ************************************************************************************************
;
;					Allocate space for array size esInt0,x esInt1,x 
;
; ************************************************************************************************

AllocateArraySpace:			
		clc 								; element count + 1 => temp2.
		lda 	esInt0,x
		adc 	#1
		sta 	temp2
		lda 	esInt1,x
		adc 	#0
		sta 	temp2+1
		;
		lda 	elementSize 				; bytes per element
		jsr 	MultiplyTemp2ByA 			; temp2 = (count + 1) x bytes per element.
		;
		clc 								; add 2 for 'max element' byte.
		lda 	temp2
		adc 	#2
		sta 	temp2
		bcc 	_AASNoCarry
		inc 	temp2+1
_AASNoCarry:
		clc 								; add to low memory, allocating space.
		lda 	lowMemory
		adc 	temp2
		sta 	lowMemory
		lda 	lowMemory+1
		adc 	temp2+1
		sta 	lowMemory+1
		bcs 	_AASFail 					; out of memory as adding causes wrapround
		cmp 	highMemory+1 				; >= high memory pointer.
		bcs 	_AASFail
		rts	
_AASFail:
		.throw	Memory

; ************************************************************************************************
;
;							Specialist 2,4 and 6 multipliers
;
; ************************************************************************************************

		.if VarISize * VarFSize * VarSSize != 48
		Fix Me ! You have changed the variable sizes so this function now won't work properly.
		.endif

MultiplyTemp2ByA:
		pha
		lda 	temp2 						; copy temp2 to temp3.
		sta 	temp3
		lda 	temp2+1
		sta 	temp3+1
		pla
		;
		asl 	temp2 						; double it.
		rol 	temp2+1
		cmp 	#2 							; if x 2 then exit.
		beq 	_MTBAExit
		cmp 	#6 							; if x 6 then add temp3 to temp2
		bne 	_MTBANotFloat
		;
		clc 								; so this will make it x 3
		lda 	temp2
		adc 	temp3
		sta 	temp2
		lda 	temp2+1
		adc 	temp3+1
		sta 	temp2+1
		;
_MTBANotFloat:		
		asl 	temp2 						; double it.
		rol 	temp2+1
_MTBAExit:		
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
;		17-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
