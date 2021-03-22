;
;	Automatically generated
;
	.include "cold.asm"
	.include "delete.asm"
	.include "insert.asm"
	.include "warm.asm"

.section code

interactionHandler:
	dispatch interactionVectors

interactionVectors:
	.word _DummyControlHandler ; index 0
	.word ColdStartEntry       ; index 2
	.word WarmStartEntry       ; index 4
_DummyControlHandler:
	rts
.send code
