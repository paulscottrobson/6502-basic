; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		locals.asm
;		Purpose:	Handle localising/delocalising.
;		Created:	4th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
storeSize:
		.fill 	1
		.send storage

		.section code

; ************************************************************************************************
;
;									Local command
;
; ************************************************************************************************

CommandLocal:		;; [local]
		ldx 	#0
		jsr 	LocaliseVariable 			; localise one.
_CLCheckNext:
		lda 	(codePtr),y 				; what follows ?
		iny
		cmp 	#TKW_EQUAL 					; local x = 2 ?
		beq 	_CLAssignment
		cmp 	#TKW_COMMA 					; comma try again.
		beq 	CommandLocal
		dey
		rts

_CLAssignment:
		ldx 	#1
		jsr 	Evaluate 					; evaluate RHS
		dex
		jsr 	WriteValue
		jmp 	_CLCheckNext

; ************************************************************************************************
;
;					Get a variable reference, push current value on the stack.
;		
; ************************************************************************************************

LocaliseVariable:
		lda 	(codePtr),y 				; check it's a variable.
		cmp 	#$40
		bcs 	_LVSyntax
		txa 								; get the address of that variable.
		.variable_access
		tax
		.pshx
		.pshy 								; save Y.
		;
		jsr 	TOSToTemp0 					; the address of the variable is now in temp0.
		lda 	esType,x 					; get the type
		asl 	a
		bpl 	_LVPushNumber
		;
		;		String code
		;
		ldy 	#0 							; put address of data in temp1
		lda 	(temp0),y
		iny
		sta 	temp1
		lda 	(temp0),y
		sta 	temp1+1
		;
		ldy 	#0 	 						; get length
		lda 	(temp1),y
		tax 								; into X
		inx 								; +1 for length.
		lda 	#markerString
		jmp 	_LVWriteFrame
		;
		;
		;		Push an integer or a float onto the stack.
		;
_LVPushNumber:		
		lda 	temp0 						; storage address and data source are the same
		sta 	temp1
		lda 	temp0+1
		sta 	temp1+1
		lda 	esType,x 					; put float flag into carry.
		lsr 	a
		lda 	#markerInt 					; get marker and size.
		ldx 	#VarISize
		bcc 	_LVIsInteger
		lda 	#markerFloat
		ldx 	#VarFSize
_LVIsInteger:
;
;		temp0 points to the variable entry in the record being saved
;		temp1 points to the data source.
;		X is the data size
;		A is the marker.
;
_LVWriteFrame:
		stx 	storeSize 					; number of bytes to copy from (temp0)
		inx 								; allocate 3 bytes, 2 for the address, 1 for the marker.
		inx
		inx				
		jsr 	RSClaim 					; create the stack frame.
		;
		lda 	temp0 						; copy the target address to slots 1 & 2
		ldy 	#1
		sta 	(rsPointer),y
		iny
		lda 	temp0+1
		sta 	(rsPointer),y
		ldy 	#0
_LVCopyData:
		lda 	(temp1),y 					; get data from source, temp1
		iny 								; write allowing for the header bit.
		iny
		iny
		sta 	(rsPointer),y
		dey
		dey
		dec 	storeSize 					; do it storesize times
		bne 	_LVCopyData
		;
		.puly
		.pulx
		rts

_LVSyntax:
		error 	Syntax		

; ************************************************************************************************
;
;							Restore any locals on the return stack
;							Stops when it hits a structure or top
;
; ************************************************************************************************

RestoreLocals:
		ldx 	#0
		lda 	(rsPointer,x)
		cmp	 	#64
		bcc 	_RLocal
		rts
_RLocal:
		.pshx
		.pshy

		ldy 	#1 							; copy target address to temp0
		lda 	(rsPointer),y
		sta 	temp0
		iny
		lda 	(rsPointer),y
		sta 	temp0+1
 
		ldy 	#0 							; get type back.
		lda 	(rsPointer),y
		cmp 	#markerString 				; string is ... different :)
		beq 	_RString

		ldx		#VARISize 					; size integer	
		cmp 	#markerInt
		beq 	_RIsInteger
		ldx 	#VARFSize 					; size float
_RIsInteger:
		.pshx 								; save size on stack.
		ldy 	#3							; start size to copy back from pointer.
_RCopyBack:				
		lda 	(rsPointer),y
		dey
		dey
		dey
		sta 	(temp0),y
		iny
		iny
		iny
		iny
		dex 
		bne 	_RCopyBack
		pla 								; get size add 3
		clc
		adc 	#3 							; (2 for address one for marker)
_RRestoreAAndLoop:		
		jsr 	RSFree
		.puly
		.pulx
		jmp 	RestoreLocals 				; go see if there are any more locals.
		;
		;		Handle strings.
		;		
_RString:
		ldx 	#0
		ldy 	#1 							; set up for a string write.
		lda 	(rsPointer),y
		sta 	esInt0,x
		iny
		lda 	(rsPointer),y
		sta 	esInt1,x
		;
		clc
		lda 	rsPointer
		adc 	#3
		sta 	esInt0+1,x
		lda 	rsPointer+1
		adc 	#0
		sta 	esInt1+1,x
		txa
		.string_write
		;
		;		Assign variable to string.
		;
		ldy 	#3 							; get string length
		lda 	(rsPointer),y
		clc
		adc 	#4 							; add 4 (pointer, marker, length) to restore.
		jmp 	_RRestoreAAndLoop

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
