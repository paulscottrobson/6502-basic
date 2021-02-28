;
;	Automatically generated
;
.section code
device_crlf .macro
	ldx	#0
	jsr	deviceHandler
	.endm

device_print .macro
	ldx	#2
	jsr	deviceHandler
	.endm

.send code
