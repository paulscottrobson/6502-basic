; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		search.asm
;		Purpose:	Search for token in the token tables
;		Created:	8th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage 
currentSet: 								; token set being searched (0-3)
		.fill 	1		
		.send storage

		.section code

; ************************************************************************************************
;
;		Find token in convertBuffer (length prefix string), if found compile it and
;		return CS, else return CC
;
; ************************************************************************************************

TokenSearch:
		.pshx
		.pshy
		lda 	#0
		sta 	currentSet
_TSLoop:
		lda 	currentSet 					; 2 x currentset in X
		asl 	a
		tax
		;
		lda 	TokenTableAddress,x 		; set temp0 to the table address
		sta 	temp0
		lda 	TokenTableAddress+1,x
		sta 	temp0+1
		;
		jsr 	TokenSearchOne 				; search one table
		bcs 	_TSFound 					; found a token.
		;
		inc 	currentSet 					; next set
		lda 	currentSet
		cmp 	#4
		bne 	_TSLoop 					; back if not done all four.
		clc 								; clear carry and exit
		bcc 	_TSExit
		;
_TSFound:
		pha 								; save token
		lda 	currentSet					; if set zero no shift
		beq 	_TSNoShift
		ora 	#$80 						; Write as $81-$83
		jsr 	TokenWrite
_TSNoShift:
		pla 								; get token back		
		jsr 	TokenWrite 					; write it
		sec 								; carry set indicating success
_TSExit:
		.puly
		.pulx		
		rts

; ************************************************************************************************
;
;		Search token list at temp0 for the token in convertBuffer. If found return CS and
;		token# in A.
;
; ************************************************************************************************

TokenSearchOne:
		ldx 	#$86 						; current token being tested.
_TSOLoop:
		ldy 	#0
		lda 	(temp0),y 					; get length of token
		beq 	_TSOFail 					; if zero, end of table
		cmp 	convertBuffer 				; length is the same, compare the text matches.
		beq 	_TSOCheckText
		;
_TSONext:									; go to next
		inx 								; bump token
		ldy 	#0							; get length
		lda 	(temp0),y
		sec 
		adc 	temp0 						; add to temp0 + 1
		sta 	temp0
		bcc 	_TSOLoop
		inc 	temp0+1
		jmp 	_TSOLoop
		;
		;		Check if the token at temp0 and the token in the convertBuffer match.
		;
_TSOCheckText:			
		tay 								; compare length downto 1.
_TSOCheckLoop:
		lda 	(temp0),y 					; use EOR to compare
		eor 	convertBuffer,y		
		and 	#$7F 						; ignore bit 7
		bne 	_TSONext 					; different goto next.
		dey 								; do all
		bne 	_TSOCheckLoop
		;
		txa 								; return token in A and carry set
		sec
		rts

_TSOFail:
		clc
		rts



		.send 	code
