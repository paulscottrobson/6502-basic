; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		tokident.asm
;		Purpose:	Tokenise identifier
;		Created:	9th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section code

; ************************************************************************************************
;
;					Tokenise identifier at (codePtr) into a token/identifier
;								CS if tokenising successful.
;
; ************************************************************************************************

TokeniseIdentifier:
		;
		;		Firstly copy identifier to convertBuffer. We know the first letter is A-Z.
		;
		ldx 	#0
_TICopyID:
		lda 	(codePtr),y					; get characters
		cmp 	#"_" 						; underscore converted to minus internally.
		beq 	_TICopyUnderscore
		cmp 	#"."
		beq 	_TICopyIn
		cmp 	#"0"
		bcc 	_TIEndCopy
		cmp 	#"9"+1
		bcc 	_TICopyIn
		cmp 	#"A"
		bcc 	_TIEndCopy
		cmp 	#"Z"+1
		bcs		_TIEndCopy
		bcc 	_TICopyIn
_TICopyUnderScore:
		lda 	#"-"						; _ is mapped to -
_TICopyIn:
		inx 								; write into buffer in 7 bit ASCII form
		sta 	convertBuffer,x
		stx 	convertBuffer
		iny 								; next character
		jmp 	_TICopyID 					; loop round
_TIEndCopy:
		;
		;		Check if followed by $/# then (, copy as is.
		;
		lda 	#"$"
		jsr 	TIDCheckCopy
		lda 	#"#"
		jsr 	TIDCheckCopy
		lda 	#"("
		jsr 	TIDCheckCopy
		;
		;		Is it a token
		;
		jsr 	TokenSearch 				; is it a token
		bcs 	_TIExit 					; if so, then exit.
		;
		;		Convert the ending #$( to the $3A-$3F end of identifier markers.
		;
		.pshy 								; save Y
		ldy 	#$3A 						; default type.
		ldx 	convertBuffer 				; is last character (
		lda 	convertBuffer,x
		cmp 	#"("
		bne 	_TINotArray
		dex 								; yes, remove it and convert to array.
		iny
_TINotArray:
		lda 	convertBuffer,x 			; check for $
		cmp 	#"$"
		bne 	_TINotString
		dex
		iny
		iny
_TINotString:		
		lda 	convertBuffer,x 			; check for #
		cmp 	#"#"
		bne 	_TINotFloat
		dex
		iny
		iny
		iny
		iny
_TINotFloat:
		inx 								; write end marker for identifier.
		tya
		sta 	convertBuffer,x		
		stx 	convertBuffer 				; update length.
		;
		;		Copy into tokenise buffer
		;
		ldx 	#1
_TIOutput:
		lda 	convertBuffer,x
		and 	#$3F
		pha
		jsr 	TokenWrite
		inx
		pla
		cmp 	#$3A
		bcc 	_TIOutput		
		.puly
_TIExit:
		sec 								; this can't fail.
		rts

;
;		If next character in stream is A, then copy it to the convertBuffer
;
TIDCheckCopy:
		cmp 	(codePtr),y		
		bne 	_TIDCCExit
		inx
		sta 	convertBuffer,x
		stx 	convertBuffer
		iny
_TIDCCExit:
		rts		
		.send 	code