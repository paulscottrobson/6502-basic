;
;	Automatically generated
;
.section code
main_test0 .macro
	ldx	#0
	jsr	mainHandler
	.endm

main_test1 .macro
	ldx	#2
	jsr	mainHandler
	.endm

main_repeat .macro
	jsr	mainHandler
	.endm

.send code
