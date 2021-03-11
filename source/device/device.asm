;
;	Automatically generated
;
	.include "option_x16/x16file.asm"
	.include "option_x16/x16io.asm"
	.include "option_x16/x16timer.asm"

.section code

deviceHandler:
	dispatch deviceVectors

deviceVectors:
	.word IOClearScreen        ; index 0
	.word IONewLine            ; index 2
	.word IOInitialise         ; index 4
	.word IOInk                ; index 6
	.word IOInkey              ; index 8
	.word IOInput              ; index 10
	.word ExternLoad           ; index 12
	.word IOLocate             ; index 14
	.word IOPaper              ; index 16
	.word IOPrintChar          ; index 18
	.word ExternSave           ; index 20
	.word IOTab                ; index 22
	.word IOReadTimer          ; index 24
.send code
