;
;	Automatically generated
;
.section code
floatingpoint_fAbs .macro
	ldx	#0
	jsr	floatingpointHandler
	.endm

floatingpoint_fAdd .macro
	ldx	#2
	jsr	floatingpointHandler
	.endm

floatingpoint_fCompare .macro
	ldx	#4
	jsr	floatingpointHandler
	.endm

floatingpoint_fDivide .macro
	ldx	#6
	jsr	floatingpointHandler
	.endm

floatingpoint_fImpossible .macro
	ldx	#8
	jsr	floatingpointHandler
	.endm

floatingpoint_fMultiply .macro
	ldx	#10
	jsr	floatingpointHandler
	.endm

floatingpoint_fNegate .macro
	ldx	#12
	jsr	floatingpointHandler
	.endm

floatingpoint_fSgn .macro
	ldx	#14
	jsr	floatingpointHandler
	.endm

floatingpoint_fSubtract .macro
	ldx	#16
	jsr	floatingpointHandler
	.endm

floatingpoint_floatToInt .macro
	ldx	#18
	jsr	floatingpointHandler
	.endm

floatingpoint_fpower .macro
	ldx	#20
	jsr	floatingpointHandler
	.endm

floatingpoint_importtoken .macro
	ldx	#22
	jsr	floatingpointHandler
	.endm

floatingpoint_intToFloat .macro
	ldx	#24
	jsr	floatingpointHandler
	.endm

floatingpoint_loadfp .macro
	ldx	#26
	jsr	floatingpointHandler
	.endm

floatingpoint_storefp .macro
	ldx	#28
	jsr	floatingpointHandler
	.endm

.send code
