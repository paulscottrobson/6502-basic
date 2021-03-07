; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		convert.asm
;		Purpose:	str$() val() isval() functions
;		Created:	3rd March 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;								STR$(<value>[,<base>])
;
; ************************************************************************************************

Event_Str: 	;; [str$(]
		jsr 	EvaluateNumeric 			; get a number.
		lda 	esType,x 					; is it floating point
		bne 	_ESFloat
		jsr 	ConvertGetBase 				; get base, or default.
		set16 	temp0,convertBuffer 		; convert here.
		lda 	esInt0+1,x 					; get the base
		jsr 	MInt32ToString 				; convert to string.		
		jmp 	_ESCloneExit 				; clone and exit.

_ESFloat:
		jsr 	CheckRightParen 			; check closing )
		jsr 	TOSToTemp0 					; string address in temp0, goes here.
		txa
		.floatingpoint_floatToString 		; convert to string at temp0.
		tax

_ESCloneExit:
		txa
		.string_clone 						; clone string at temp0 to TOS in soft string memory
		tax
		rts

; ************************************************************************************************
;
;							VAL(<string>[,<base>]) ISVAL(same)
;
;		Base only for floats. ISVAL and VAL are identical except one returns the number
;		and the other returns the value.
;
; ************************************************************************************************

UnaryVal:		;; [val(]
		sec 								; Carry set to return value
		bcs 	ValueMain
UnaryIsVal:		;; [isval(] 				
		clc									; Carry clear to return legitimacy
ValueMain:
		php 								; save results (CS is value, CC is validation)
		jsr 	EvaluateString
		jsr 	ConvertGetBase 				; get base, if any.
		.pshy 								; save Y on stack
		;
		jsr 	TOSToTemp0 					; string address in temp0, goes here.
		;
		lda 	esInt0+1,x 					; get the base
		and 	#$7F 						; ignore the sign bit.
		;
		jsr 	MInt32FromString 			; convert it back from a string.
		bcs 	_VMSuccess 					; successfully converted.
		;
		lda 	esInt0+1,x 					; is base the default
		cmp 	#$80+10 					; if no, then it is integer only.
		beq 	_VMFailed 	 				; so we failed.
		; 
		;		If fp installed check fp, else fail.
		;
		.if installed_floatingpoint == 1
		txa
		.floatingpoint_stringToFloat 
		tax
		bcs 	_VMSuccess					; it converted okay.
		.endif
		;
		;		Conversion worked
		;
_VMFailed:
		.puly
		plp 				
		jmp 	MInt32False 				; return 0 whatever.
		;
		;		Conversion succeeded
		;
_VMSuccess:				
		.puly
		plp 								; if CS the it was val() so we want the value.
		bcs 	_VMExit
		jmp 	MInt32True 					; otherwise return true as successful.
_VMExit:	
		rts		



; ************************************************************************************************
;
;		looks for ) or ,[base]), puts base in esInt0+1, defaulting to 10
;
; ************************************************************************************************

ConvertGetBase:
		lda 	#10+$80 					; default base 10 signed.	
		sta 	esInt0+1,x
		lda 	(codePtr),y 				; check for ,base)
		cmp 	#TKW_COMMA
		bne 	_CGBDone 					; not found, should be )
		;
		inx 								; next level
		iny 								; skip comma.
		jsr 	EvaluateSmallInteger		; evaluate the base.
		dex
		cmp 	#2 							; base range is 2..16
		bcc 	_CGBValue 					; (it should work as high as 37)
		cmp 	#17
		bcs 	_CGBValue
_CGBDone:
		jsr 	CheckRightParen
		rts

_CGBValue:
		error 	BadValue

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
		