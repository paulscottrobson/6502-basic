; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		01common.inc
;		Purpose:	Common includes/defines/setups
;		Created:	21st February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		* = $02
		.dsection zeropage
		* = $800
		.dsection storage

		* = $1000
		.dsection code

;
;		Size of evaluation stack
;		
StackSize = 8
;
;		Size of return stack.
;
retStackSize = 512
;
;		Structure markers.
;
markerGOSUB = 'G'
markerREPEAT = 'R'
markerFOR = 'F'
