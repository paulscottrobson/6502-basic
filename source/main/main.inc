;
;	Automatically generated
;
.section code
main_evaluate .macro
	ldx	#0
	jsr	mainHandler
	.endm

main_evaluateint .macro
	ldx	#2
	jsr	mainHandler
	.endm

main_evaluatesmall .macro
	ldx	#4
	jsr	mainHandler
	.endm

.send code
