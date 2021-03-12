;
;	Automatically generated
;
.section code
device_break .macro
	ldx	#0
	jsr	deviceHandler
	.endm

device_clear .macro
	ldx	#2
	jsr	deviceHandler
	.endm

device_crlf .macro
	ldx	#4
	jsr	deviceHandler
	.endm

device_initialise .macro
	ldx	#6
	jsr	deviceHandler
	.endm

device_ink .macro
	ldx	#8
	jsr	deviceHandler
	.endm

device_inkey .macro
	ldx	#10
	jsr	deviceHandler
	.endm

device_inputline .macro
	ldx	#12
	jsr	deviceHandler
	.endm

device_load .macro
	ldx	#14
	jsr	deviceHandler
	.endm

device_locate .macro
	ldx	#16
	jsr	deviceHandler
	.endm

device_paper .macro
	ldx	#18
	jsr	deviceHandler
	.endm

device_print .macro
	ldx	#20
	jsr	deviceHandler
	.endm

device_save .macro
	ldx	#22
	jsr	deviceHandler
	.endm

device_tab .macro
	ldx	#24
	jsr	deviceHandler
	.endm

device_timer .macro
	ldx	#26
	jsr	deviceHandler
	.endm

.send code
