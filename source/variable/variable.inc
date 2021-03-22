;
;	Automatically generated
;
.section code
variable_controlhandler .macro
	ldx	#0
	jsr	variableHandler
	.endm

variable_access .macro
	ldx	#2
	jsr	variableHandler
	.endm

variable_createarray .macro
	ldx	#4
	jsr	variableHandler
	.endm

variable_reset .macro
	ldx	#6
	jsr	variableHandler
	.endm

.send code
