;
;	Automatically generated
;
	.include "x16/x16io.asm"
	.include "x16/x16timer.asm"

.section code

deviceHandler:
	dispatch deviceVectors

deviceVectors:
	.word IONewLine            ; index 0
	.word IOInkey              ; index 2
	.word IOPrintChar          ; index 4
	.word IOTab                ; index 6
	.word IOReadTimer          ; index 8
.send code
