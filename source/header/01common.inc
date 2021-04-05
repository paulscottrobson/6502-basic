; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		01common.inc
;		Purpose:	Common includes/defines/setups
;		Created:	21st February 2021
;		Reviewed: 	7th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;			Specify CPU type
;
; ************************************************************************************************

		.if cputype == 0
		.cpu "65c02"				; TODO: Not a bug, haven't replaced jmp (nnnn,x) yet.
		.endif
		.if cputype == 1
		.cpu "65c02"
		.endif

; ************************************************************************************************
;
;		Version Information
;
; ************************************************************************************************

VersionText .macro
		.text "0.21"		
		.endm

VersionDate .macro
		.text "05-Apr-2021"
		.endm
				
; ************************************************************************************************
;
;		Flags which modules are installed
;
; ************************************************************************************************

		.include "../generated/installed.inc"

; ************************************************************************************************
;
;		Number of hash table entries per variable type (maximum of 16)
;
; ************************************************************************************************

hashTableSize = 8			; if this changes, the calculation is AccessSetup has to match it.

; ************************************************************************************************
;
;		Structure markers. All alphabetical except local storage
;
; ************************************************************************************************

markerGOSUB = 'G'
markerREPEAT = 'R'
markerFOR = 'F'
markerWHILE = 'W'
markerPROC = 'P'
;
;		Local variable storage. All must be ASCII < 'A'
;
markerSTRING = '$'		
markerFLOAT = '#'
markerINT = '%'

; ************************************************************************************************
;
;		Size of variable record parts
;
; ************************************************************************************************

VarHSize = 5 								; header (2 link, 2 name, 1 hash)
;
VarASize = 2 								; array [address of first level]
;
;		Note, if these change, the dedicated multiplier in the ArrayAccess code needs
;		changing. 
;
VarISize = 4 								; integer (32 bit)
VarFSize = 6 								; float (4 mantissa, 1 exponent 1 sign/zero)
VarSSize = 2 								; address (2 bytes)

; ************************************************************************************************
;
;		Set up code and data sections
;
; ************************************************************************************************

		* = ZeroPageStorage
		.dsection zeropage
		* = MemoryStorage
		.dsection storage
		* = CodeStart
		.dsection code
