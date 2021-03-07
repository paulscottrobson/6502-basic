;
;	Automatically generated
;
.section code
main_checkrightparen .macro
	ldx	#0
	jsr	mainHandler
	.endm

main_evaluate .macro
	ldx	#2
	jsr	mainHandler
	.endm

main_evaluateint .macro
	ldx	#4
	jsr	mainHandler
	.endm

main_evaluatesmall .macro
	ldx	#6
	jsr	mainHandler
	.endm

main_evaluateterm .macro
	ldx	#8
	jsr	mainHandler
	.endm

main_inttostr .macro
	ldx	#10
	jsr	mainHandler
	.endm

main_printstring .macro
	ldx	#12
	jsr	mainHandler
	.endm

.send code
