;
;	Automatically generated
;
	.include "access.asm"
	.include "create.asm"
	.include "createarray.asm"
	.include "find.asm"
	.include "reset.asm"

.section code

variableHandler:
	dispatch variableVectors

variableVectors:
	.word AccessVariable       ; index 0
	.word CreateArray          ; index 2
	.word HashTableReset       ; index 4
.send code
