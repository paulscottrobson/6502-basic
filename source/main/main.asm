;
;	Automatically generated
;
	.include "00start.asm"
	.include "commands/assert.asm"
	.include "commands/clear.asm"
	.include "commands/if.asm"
	.include "commands/let.asm"
	.include "commands/run.asm"
	.include "commands/stopend.asm"
	.include "commands/transfer.asm"
	.include "evaluate/binary.asm"
	.include "evaluate/compare.asm"
	.include "evaluate/dereference.asm"
	.include "evaluate/evaluate.asm"
	.include "evaluate/unary.asm"
	.include "imath/int32binary.asm"
	.include "imath/int32compare.asm"
	.include "imath/int32divide.asm"
	.include "imath/int32fromstr.asm"
	.include "imath/int32math.asm"
	.include "imath/int32multiply.asm"
	.include "imath/int32tostr.asm"
	.include "imath/int32unary.asm"
	.include "utility/check.asm"

.section code

mainHandler:
	dispatch mainVectors

mainVectors:
.send code
