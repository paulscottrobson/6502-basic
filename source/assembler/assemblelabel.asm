; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		assemblelabel.asm
;		Purpose:	Assembler label handler
;		Created:	14th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code	

; ************************************************************************************************
;
;						Assemble instruction in A, rest is (codePtr),y
;
; ************************************************************************************************

AssembleLabel:	;; <label>		
		lda 	(codePtr),y 				; check it's followed by a variable name.
		cmp 	#$3A
		bcs 	_ALSyntax

		lda 	#0							; get a variable name on to stack:0
		.variable_access
		lda 	esType 						; check integer reference
		cmp 	#$80
		bne 	_ALSyntax

		lda 	esInt0 						; copy that reference address to temp0
		sta 	temp0
		lda 	esInt1
		sta 	temp0+1
		.pshy

		lda 	SingleLetterVar+("O"-"A")*4	; are we in Pass 2
		lsr 	a
		bcc 	_ALWrite

		ldy 	#0
		lda 	SingleLetterVar+("P"-"A")*4 ; compare the value in P to the variable
		cmp 	(temp0),y
		bne 	_ALChanged
		iny
		lda 	SingleLetterVar+("P"-"A")*4+1
		cmp 	(temp0),y
		bne 	_ALChanged

_ALWrite:
		ldy 	#0
		lda 	SingleLetterVar+("P"-"A")*4 ; copy the value in P into the variable
		sta 	(temp0),y
		lda 	SingleLetterVar+("P"-"A")*4+1
		iny 
		sta 	(temp0),y
		lda 	#0
		iny 
		sta 	(temp0),y
		iny 
		sta 	(temp0),y

		.puly
		rts

_ALChanged:
		.throw 	Label

_ALSyntax:
		.throw 	Syntax

		.send 	code		

; In pass 2, a label cannot change value. 