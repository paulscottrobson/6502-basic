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
		;
		;		TODO: Stack variable value.
		;
		rts

_LVSyntax:
		error 	Syntax		

; ************************************************************************************************
;
;							Restore any locals on the return stack
;
; ************************************************************************************************

RestoreLocals:
		rts

		.send 	code