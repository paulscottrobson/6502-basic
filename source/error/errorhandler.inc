; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		errorhandler.inc
;		Purpose:	Handles errors.
;		Created:	21st February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;							Automatically generated list of error IDs
;										(from errorgen.py)
;
; ************************************************************************************************

		.include "../generated/errorid.inc"

; ************************************************************************************************
;
;									Macro to raise an error
;
; ************************************************************************************************

;
;		Standard dispatcher is disabled, the errorcode is passed straight through the handler.
;
throw 	.macro
		ldx 	#ErrorID_\1 			
		.error_execown
		.endm
