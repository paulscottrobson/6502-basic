;
;	Automatically generated
;
.section code
variable_access .macro
	ldx	#0
	jsr	variableHandler
	.endm

variable_repeat .macro
	jsr	variableHandler
	.endm

.send code
