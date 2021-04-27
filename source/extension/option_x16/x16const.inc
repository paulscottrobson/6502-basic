; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		x16const.asm
;		Purpose:	X16 constants
;		Created:	22nd March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

X16MaxImages = 64 							; max # of sprite images.

X16VeraAddLow = $9F20
X16VeraAddMed = $9F21
X16VeraAddHigh = $9F22
X16VeraData0 = $9F23
X16VeraData1 = $9F24
X16VeraControl = $9F25
X16VeraDCVideo = $9F29
X16VeraHScale = $9F2A
X16VeraVScale = $9F2B

X16VeraLayerConfig = $9F2D
X16VeraLayerMapBase = $9F2E
X16VeraLayerTileBase = $9F2F

X16KReadJoystick = $FF56
X16KReadRTC = $FF50

X16VeraSound = $1F9C0
X16VeraPalette = $1FA00

GrWidth = 320 								; gfx mode size.
GrHeight = 200

VeraDefaultFont = $F800 					; where font is in Vera

;
;	gdSetDrawPosition in coords.asm is hard coded for 320 pixels across
;

