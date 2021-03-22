;
;	Automatically generated
;
	.include "asmoperand.asm"
	.include "asmwrite.asm"
	.include "assemblecmd.asm"
	.include "assemblelabel.asm"
	.include "subgroup.asm"

.section code

assemblerHandler:
	dispatch assemblerVectors

assemblerVectors:
	.word _DummyControlHandler ; index 0
	.word AssembleOneInstruction ; index 2
	.word AssembleLabel        ; index 4
_DummyControlHandler:
	rts
.send code
