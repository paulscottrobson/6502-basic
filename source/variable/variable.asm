;
;	Automatically generated
;
	.include "access.asm"
	.include "create.asm"
	.include "find.asm"
	.include "reset.asm"

.section code

variableHandler:
	dispatch variableVectors

variableVectors:
	.word AccessVariable       ; index 0
	.word HashTableReset       ; index 2
.send code
