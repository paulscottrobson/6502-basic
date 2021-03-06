;
;	Automatically generated
;
	.include "chr.asm"
	.include "compare.asm"
	.include "concat.asm"
	.include "memory.asm"
	.include "setcase.asm"
	.include "substring.asm"
	.include "write.asm"

.section code

stringHandler:
	dispatch stringVectors

stringVectors:
	.word StringChrs           ; index 0
	.word StrClone             ; index 2
	.word StringConcat         ; index 4
	.word STRCompare           ; index 6
	.word CaseString           ; index 8
	.word StringSubstring      ; index 10
	.word StringWrite          ; index 12
.send code
