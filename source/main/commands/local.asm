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
;					Get a variable reference, push current value on the stack.
;		
; ************************************************************************************************

LocaliseVariable:
		lda 	(codePtr),y 				; check it's a variable.
		cmp 	#$40
		bcs 	_LVSyntax
		txa 								; get the address of that variable.
		variable_access
		tax
		pshx
		pshy 								; save Y.
		;
		jsr 	TOSToTemp0 					; the address of the variable is now in temp0.
		lda 	esType,x 					; get the type
		asl 	a
		bpl 	_LVPushNumber
		;
		;		String code
		;
		ldx 	#2 							; save that address
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
		puly
		pulx
		rts

_LVSyntax:
		error 	Syntax		

; ************************************************************************************************
;
;							Restore any locals on the return stack
;
; ************************************************************************************************

RestoreLocals:
		lda 	(rsPointer),y
		rts

		.send 	code