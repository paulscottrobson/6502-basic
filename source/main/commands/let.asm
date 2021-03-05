; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		let.asm
;		Purpose:	Assignment statement (LET is optional)
;		Created:	28th February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;										Let command
;
; ************************************************************************************************

CommandLet: ;; [let]
		ldx 	#0  						; get address to write.
		jsr 	EvaluateReference
		lda 	#TKW_EQUAL 					; check for equals
		jsr 	CheckToken
		inx 								; do RHS
		jsr 	Evaluate 					; evaluate and derefernce
		dex
		jsr 	WriteValue 					; write it out
		rts

; ************************************************************************************************
;
;				Write value at stack+1 to reference at stack+0, type checking.
;
; ************************************************************************************************

WriteValue:
		.pshy
		jsr 	TOSToTemp0 					; set temp0 to point to target address.
		;
		;		Check not assigning string to number or vice versa.
		;
		lda 	esType,x 					; check the string/integer flags match
		eor 	esType+1,x
		and 	#$40
		bne		_WVType
		;
		;		Check for string->string.
		;
		ldy 	#1 							; for string, copy 0 and 1.
		lda 	esType,x 					; check for string assignment
		and 	#$40
		bne 	_WVCopyString
		;
		;		Check for integer->integer
		;
		lda 	esType,x 					; check both are integer.
		ora 	esType+1,x
		lsr 	a
		bcc 	_WVCopyData4
		;
		;		Check for float->integer, which is a type error. At least one is a float.
		;
		lda 	esType,x
		lsr 	a
		bcc 	_WVType
		;
		;		Now could be integer->float or float->float
		;
		inx 								; force the value being written to be a float.
		jsr 	BPMakeFloat
		dex
		jsr 	TOSToTemp0 					; set Temp0 to write address
		inx
		txa 							
		.floatingpoint_storefp 				; write using FP write function.
		tax
		jmp 	_WVCopyExit
		;
		;		Copy string. This is done by the string library as may include concretion.
		;
_WVCopyString:	
		txa
		.string_write
		tax
		jmp 	_WVCopyExit		
		;
		;		Copy 4,2 or 1
		;
_WVCopyData4:
		lda 	esType,x 					; is the int ref a byte ref ?
		and 	#$20
		bne 	_WVCopyData1  			
		;
		ldy 	#3
		lda 	esInt3+1,x
		sta 	(temp0),y
		dey		
		lda 	esInt2+1,x
		sta 	(temp0),y
		dey
		lda 	esInt1+1,x
		sta 	(temp0),y
_WVCopyData1:		
		ldy 	#0
		lda 	esInt0+1,x
		sta 	(temp0),y
_WVCopyExit:
		.puly
		rts


_WVType:
		error 	BadType		

; ************************************************************************************************
;
;										Copy TOS 0/1 to temp0
;
; ************************************************************************************************

TOSToTemp0:
		lda 	esInt0,x
		sta 	temp0
		lda 	esInt1,x
		sta 	temp0+1
		rts

		.send code
