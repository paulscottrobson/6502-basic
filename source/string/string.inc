;
;	Automatically generated
;
.section code
string_concat .macro
	ldx	#0
	jsr	stringHandler
	.endm

string_repeat .macro
	jsr	stringHandler
	.endm

.send code
