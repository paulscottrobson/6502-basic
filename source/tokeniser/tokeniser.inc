;
;	Automatically generated
;
.section code
tokeniser_controlhandler .macro
	ldx	#0
	jsr	tokeniserHandler
	.endm

tokeniser_detokenise .macro
	ldx	#2
	jsr	tokeniserHandler
	.endm

tokeniser_list .macro
	ldx	#4
	jsr	tokeniserHandler
	.endm

tokeniser_test .macro
	ldx	#6
	jsr	tokeniserHandler
	.endm

tokeniser_tokenise .macro
	ldx	#8
	jsr	tokeniserHandler
	.endm

tokeniser_tokenisez .macro
	ldx	#10
	jsr	tokeniserHandler
	.endm

.send code
