;
;	Automatically generated
;
	.include "concat.asm"

stringHandler:
	dispatch stringVectors

stringVectors:
	.word StringConcat         ; index 0
