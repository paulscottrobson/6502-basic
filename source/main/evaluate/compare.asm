; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		comparison.asm
;		Purpose:	Binary Compare Routines
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code		
		
; ************************************************************************************************
;
;				2 parameters. compare value, test for true.			
;				so = would be $00,beq
;
; ************************************************************************************************

comparer 	.macro 
		jsr 	PerformComparison
		cmp 	#\1
		\2  	CompareTrue
		jmp 	CompareFalse
		.endm

; ************************************************************************************************
;
;						  Do the appropriate float,int,string comparison
;
;							Note: this is also used in min() and max()
;
; ************************************************************************************************

PerformComparison:
		jsr 	DereferenceTwo 				; make both values.
		lda 	esType,x 					; check for two strings.
		and 	esType+1,x
		asl 	a
		bmi 	_PCIsString 				
		;
		lda 	esType,x 					; check either is floating point.
		ora 	esType+1,x
		asl 	a 							; shift bit 6 (string) to bit 7
		bmi 	_PCError 					
		and 	#$02 						; because of ASL, check type in bit 0
		beq 	_PCIsInteger 				; if not two integers
		jsr 	BPMakeBothFloat 			; make both float
		txa
		.floatingpoint_fCompare 				; and compare them.
		stx 	tempShort 					; save result
		tax
		lda 	tempShort
		rts

_PCIsInteger:
		jmp 	MInt32Compare

_PCIsString:
		txa 								; A has SP
		.string_sCompare 					; compare strings
		stx 	tempShort 					; save result
		tax 								; put SP back in X and get result.
		lda 	tempShort
		rts

_PCError:									; mixed types
		error 	BadType

; ************************************************************************************************
;
;										Compare operators
;
; ************************************************************************************************

CompareEquals:	;; [=]
		comparer 	$00,beq 				

CompareLess: 	;; [<]
		comparer 	$FF,beq 				

CompareGreater: ;; [>]
		comparer 	$01,beq 				

; ================================================================================================

CompareNotEquals:	;; [<>]
		comparer 	$00,bne 				

CompareGreaterEq: 	;; [>=]
		comparer 	$FF,bne 				

CompareLessEq: ;; [<=]
		comparer 	$01,bne

; ************************************************************************************************
;
;							Return true or false with integer type
;
; ************************************************************************************************

CompareTrue:
		jmp 	MInt32True

CompareFalse:
		jmp 	MInt32False		

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
			