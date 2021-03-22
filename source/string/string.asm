;
;	Automatically generated
;
	.include "functions/chr.asm"
	.include "functions/compare.asm"
	.include "functions/concat.asm"
	.include "functions/memory.asm"
	.include "functions/setcase.asm"
	.include "functions/substring.asm"
	.include "functions/write.asm"

.section code

stringHandler:
	dispatch stringVectors

stringVectors:
	.word _DummyControlHandler ; index 0
	.word StringChrs           ; index 2
	.word StrClone             ; index 4
	.word StringConcat         ; index 6
	.word StringNull           ; index 8
	.word STRCompare           ; index 10
	.word CaseString           ; index 12
	.word StringSubstring      ; index 14
	.word StringWrite          ; index 16
_DummyControlHandler:
	rts
.send code
