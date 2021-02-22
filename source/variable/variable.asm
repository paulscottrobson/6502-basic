;
;	Automatically generated
;
	.include "access.asm"

variableHandler:
	dispatch variableVectors

variableVectors:
	.word AccessVariable       ; index 0
