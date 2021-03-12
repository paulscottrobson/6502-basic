;
;	Automatically generated
;
.section code
string_chrs .macro
	ldx	#0
	jsr	stringHandler
	.endm

string_clone .macro
	ldx	#2
	jsr	stringHandler
	.endm

string_concat .macro
	ldx	#4
	jsr	stringHandler
	.endm

string_null .macro
	ldx	#6
	jsr	stringHandler
	.endm

string_sCompare .macro
	ldx	#8
	jsr	stringHandler
	.endm

string_setcase .macro
	ldx	#10
	jsr	stringHandler
	.endm

string_substring .macro
	ldx	#12
	jsr	stringHandler
	.endm

string_write .macro
	ldx	#14
	jsr	stringHandler
	.endm

.send code
