;
;	Automatically generated
;
.section code
main_checkrightparen .macro
	ldx	#0
	jsr	mainHandler
	.endm

main_clear .macro
	ldx	#2
	jsr	mainHandler
	.endm

main_evaluate .macro
	ldx	#4
	jsr	mainHandler
	.endm

main_evaluateint .macro
	ldx	#6
	jsr	mainHandler
	.endm

main_evaluatesmall .macro
	ldx	#8
	jsr	mainHandler
	.endm

main_evaluateterm .macro
	ldx	#10
	jsr	mainHandler
	.endm

main_inttostr .macro
	ldx	#12
	jsr	mainHandler
	.endm

main_new .macro
	ldx	#14
	jsr	mainHandler
	.endm

main_printstring .macro
	ldx	#16
	jsr	mainHandler
	.endm

main_runfrom .macro
	ldx	#18
	jsr	mainHandler
	.endm

main_strtoint .macro
	ldx	#20
	jsr	mainHandler
	.endm

.send code
