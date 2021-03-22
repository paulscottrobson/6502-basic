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
	.word _DummyControlHandler ; index 0
	.word AccessVariable       ; index 2
	.word CreateArray          ; index 4
	.word HashTableReset       ; index 6
_DummyControlHandler:
	rts
.send code
