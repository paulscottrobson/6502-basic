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
	.word AssembleOneInstruction ; index 0
	.word AssembleLabel        ; index 2
.send code
