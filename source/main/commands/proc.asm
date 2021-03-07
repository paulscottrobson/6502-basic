; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		proc.asm
;		Purpose:	Proc handler/scanner
;		Created:	4th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
paramCount: 								; number of parameters + 1
		.fill 	1

		.send storage

		
		.section code
		
; ************************************************************************************************
;
;									Call a procedure
;
; ************************************************************************************************

CallProc:	;; [proc]
		jsr 	FindProcedure 				; find procedure, put in temp0. A contains name length.		
		pha 								; save length on stack
		sta 	tempShort 					; save length in tempShort
		lda 	temp0+1 					; save procedure target on stack.
		pha
		lda 	temp0
		pha
		;
		;		Point to the params in code and evaluate them on the stack.
		;
		tya 								; calculate Y + length
		clc
		adc 	tempShort
		tay
		ldx 	#0 							; where the first parameter goes - 1
_CallProcEvalParams:
		inx
		lda 	(codePtr),y 				; do we have ) ?
		cmp 	#TKW_RPAREN
		beq 	_CPDoneParams
		jsr 	Evaluate 					; evaluate a parameter
		lda 	(codePtr),Y 				; get what's next, preconsume
		iny
		cmp 	#TKW_COMMA 					; if comma, go get another parameter
		beq 	_CallProcEvalParams
		dey 								; undo consumption.
		;
		;		Params are evaluated on the stack. There are X-1 of them.		
		;
_CPDoneParams:				
		jsr 	CheckRightParen 			; check closing parenthesis.
		;
		stx 	paramCount 					; store parameter count+1
		;
		;		Push the return address on the stack.
		;	
		ldx 	#4							; make space on stack
		lda 	#markerPROC 
		jsr 	RSClaim
		lda 	#1 							; store return address.
		jsr 	RSSavePosition 				
		;
		;		Get the position of the param list start into (CodePtr),y
		;
		pla 								; get the new code Ptr
		sta 	codePtr
		pla
		sta 	codePtr+1
		pla 								; length of name + 4 is the param start.
		clc
		adc 	#4
		tay
		;
		;		Load the parameters back.
		;
		ldx 	#$FF
_CPLoadParameters:
		inx 								; point to where the address should be loaded.
		cpx 	paramCount 					; too many parameters in definition ?
		beq 	_CPParamError
		; 							
		lda 	(codePtr),y					; what follows
		cmp 	#TKW_RPAREN 				; is it the right bracket
		beq 	_CPParamComplete 			; done all the parameters
		;
		jsr 	LocaliseVariable 			; make following variable local, ref in tos,x
		jsr 	WriteValue 					; copy the evaluated parameter into there.
		;
		lda 	(codePtr),y 				; followed by a comma ?
		iny
		cmp 	#TKW_COMMA
		beq 	_CPLoadParameters
		dey 								; no, unconsume and check for )
		;
		;		Done all the parameters
		;
_CPParamComplete:
		jsr 	CheckRightParen 			; check )
		inx 								; check right number of parameters
		cpx 	paramCount 		
		bne 	_CPParamError
		rts

_CPParamError:
		error 	Params		

; ************************************************************************************************
;
;									Leave a procedure
;
; ************************************************************************************************

ReturnProc:	;; [endproc]
		jsr 	RestoreLocals 				; get the locals back.
		rscheck markerPROC,endProcErr 		; check TOS is a ENDPROC
		lda 	#1
		jsr 	RSLoadPosition 				; reload the position from offset 1.
		lda 	#4 							; throw 4 bytes from stack.
		jsr 	RSFree 
		;
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
		