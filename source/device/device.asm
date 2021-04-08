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
	.word IOControlHandler     ; index 0
	.word IOClearScreen        ; index 2
	.word IONewLine            ; index 4
	.word IOInk                ; index 6
	.word IOInkey              ; index 8
	.word IOInput              ; index 10
	.word ExternLoad           ; index 12
	.word IOLocate             ; index 14
	.word IOPaper              ; index 16
	.word IOPrintChar          ; index 18
	.word IOPrintAscii         ; index 20
	.word ExternSave           ; index 22
	.word X16SyncBreak         ; index 24
	.word IOTab                ; index 26
	.word IOReadTimer          ; index 28
_DummyControlHandler:
	rts
.send code
