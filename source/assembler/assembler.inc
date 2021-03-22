;
;	Automatically generated
;
.section code
assembler_controlhandler .macro
	ldx	#0
	jsr	assemblerHandler
	.endm

assembler_assemble .macro
	ldx	#2
	jsr	assemblerHandler
	.endm

assembler_label .macro
	ldx	#4
	jsr	assemblerHandler
	.endm

.send code
