;
;	Automatically generated
;
	.include "cold.asm"
	.include "warm.asm"

.section code

interactionHandler:
	dispatch interactionVectors

interactionVectors:
	.word ColdStartEntry       ; index 0
	.word WarmStartEntry       ; index 2
.send code
