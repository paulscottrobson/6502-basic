;
;	Automatically generated
;
	.include "chr.asm"
	.include "compare.asm"
	.include "concat.asm"
	.include "memory.asm"
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
	.word StringSubstring      ; index 8
	.word StringWrite          ; index 10
.send code
