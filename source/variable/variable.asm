;
;	Automatically generated
;
	.include "access.asm"
.section code

variableHandler:
	dispatch variableVectors

variableVectors:
	.word AccessVariable       ; index 0
.send code
