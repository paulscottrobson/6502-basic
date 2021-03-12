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
	.word StringNull           ; index 6
	.word STRCompare           ; index 8
	.word CaseString           ; index 10
	.word StringSubstring      ; index 12
	.word StringWrite          ; index 14
.send code
