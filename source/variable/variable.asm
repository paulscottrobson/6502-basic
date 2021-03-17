;
;	Automatically generated
;
	.include "array/access.asm"
	.include "array/create.asm"
	.include "variable/access.asm"
	.include "variable/create.asm"
	.include "variable/find.asm"
	.include "variable/reset.asm"

.section code

variableHandler:
	dispatch variableVectors

variableVectors:
	.word AccessVariable       ; index 0
	.word CreateArray          ; index 2
	.word HashTableReset       ; index 4
.send code
