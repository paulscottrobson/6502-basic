;
;	Automatically generated
;
.section code
floatingpoint_importtoken .macro
	ldx	#0
	jsr	floatingpointHandler
	.endm

floatingpoint_repeat .macro
	jsr	floatingpointHandler
	.endm

.send code
