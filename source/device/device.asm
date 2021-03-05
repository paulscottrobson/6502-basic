;
;	Automatically generated
;
	.include "option_x16/x16io.asm"
	.include "option_x16/x16timer.asm"

.section code

deviceHandler:
	dispatch deviceVectors

deviceVectors:
	.word IONewLine            ; index 0
	.word IOInitialise         ; index 2
	.word IOInkey              ; index 4
	.word IOPrintChar          ; index 6
	.word IOTab                ; index 8
	.word IOReadTimer          ; index 10
.send code
