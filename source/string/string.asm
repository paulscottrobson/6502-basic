;
;	Automatically generated
;
	.include "compare.asm"
	.include "concat.asm"

stringHandler:
	dispatch stringVectors

stringVectors:
	.word StringConcat         ; index 0
	.word STRCompare           ; index 2
