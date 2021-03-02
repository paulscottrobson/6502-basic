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
	.word StringConcat         ; index 2
	.word STRCompare           ; index 4
	.word StringSubstring      ; index 6
	.word StringWrite          ; index 8
.send code
