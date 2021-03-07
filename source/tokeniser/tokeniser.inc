;
;	Automatically generated
;
.section code
tokeniser_detokenise .macro
	ldx	#0
	jsr	tokeniserHandler
	.endm

tokeniser_list .macro
	ldx	#2
	jsr	tokeniserHandler
	.endm

.send code
