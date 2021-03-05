;
;	Automatically generated
;
.section code
device_crlf .macro
	ldx	#0
	jsr	deviceHandler
	.endm

device_initialise .macro
	ldx	#2
	jsr	deviceHandler
	.endm

device_inkey .macro
	ldx	#4
	jsr	deviceHandler
	.endm

device_print .macro
	ldx	#6
	jsr	deviceHandler
	.endm

device_tab .macro
	ldx	#8
	jsr	deviceHandler
	.endm

device_timer .macro
	ldx	#10
	jsr	deviceHandler
	.endm

.send code
