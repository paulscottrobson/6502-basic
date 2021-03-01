;
;	Automatically generated
;
	.include "x16/x16io.asm"

.section code

deviceHandler:
	dispatch deviceVectors

deviceVectors:
	.word IONewLine            ; index 0
	.word IOPrintChar          ; index 2
	.word IOTab                ; index 4
.send code
