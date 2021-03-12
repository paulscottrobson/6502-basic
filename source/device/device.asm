;
;	Automatically generated
;
	.include "option_x16/x16break.asm"
	.include "option_x16/x16file.asm"
	.include "option_x16/x16io.asm"
	.include "option_x16/x16timer.asm"

.section code

deviceHandler:
	dispatch deviceVectors

deviceVectors:
	.word X16Break             ; index 0
	.word IOClearScreen        ; index 2
	.word IONewLine            ; index 4
	.word IOInitialise         ; index 6
	.word IOInk                ; index 8
	.word IOInkey              ; index 10
	.word IOInput              ; index 12
	.word ExternLoad           ; index 14
	.word IOLocate             ; index 16
	.word IOPaper              ; index 18
	.word IOPrintChar          ; index 20
	.word ExternSave           ; index 22
	.word IOTab                ; index 24
	.word IOReadTimer          ; index 26
.send code
