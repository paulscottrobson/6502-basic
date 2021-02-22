;
;	Automatically generated
;
.section code
floatingpoint_fAdd .macro
	ldx	#0
	jsr	floatingpointHandler
	.endm

floatingpoint_fDivide .macro
	ldx	#2
	jsr	floatingpointHandler
	.endm

floatingpoint_fImpossible .macro
	ldx	#4
	jsr	floatingpointHandler
	.endm

floatingpoint_fMultiply .macro
	ldx	#6
	jsr	floatingpointHandler
	.endm

floatingpoint_fSubtract .macro
	ldx	#8
	jsr	floatingpointHandler
	.endm

floatingpoint_floatToInt .macro
	ldx	#10
	jsr	floatingpointHandler
	.endm

floatingpoint_importtoken .macro
	ldx	#12
	jsr	floatingpointHandler
	.endm

floatingpoint_intToFloat .macro
	ldx	#14
	jsr	floatingpointHandler
	.endm

floatingpoint_repeat .macro
	jsr	floatingpointHandler
	.endm

.send code
