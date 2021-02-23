;
;	Automatically generated
;
.section code
string_concat .macro
	ldx	#0
	jsr	stringHandler
	.endm

string_sCompare .macro
	ldx	#2
	jsr	stringHandler
	.endm

.send code
