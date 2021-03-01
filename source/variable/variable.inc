;
;	Automatically generated
;
.section code
variable_access .macro
	ldx	#0
	jsr	variableHandler
	.endm

variable_reset .macro
	ldx	#2
	jsr	variableHandler
	.endm

.send code
