;
;	Automatically generated
;
	.include "00start.asm"
	.include "commands/assert.asm"
	.include "commands/clear.asm"
	.include "commands/for.asm"
	.include "commands/if.asm"
	.include "commands/let.asm"
	.include "commands/new.asm"
	.include "commands/poke.asm"
	.include "commands/print.asm"
	.include "commands/proc.asm"
	.include "commands/rem.asm"
	.include "commands/repeat.asm"
	.include "commands/run.asm"
	.include "commands/scanner.asm"
	.include "commands/stopend.asm"
	.include "commands/transfer.asm"
	.include "commands/vdu.asm"
	.include "commands/while.asm"
	.include "evaluate/binary.asm"
	.include "evaluate/compare.asm"
	.include "evaluate/convert.asm"
	.include "evaluate/dereference.asm"
	.include "evaluate/evaluate.asm"
	.include "evaluate/event.asm"
	.include "evaluate/unary.asm"
	.include "evaluate/unary2.asm"
	.include "evaluate/unarystr.asm"
	.include "imath/int32binary.asm"
	.include "imath/int32compare.asm"
	.include "imath/int32divide.asm"
	.include "imath/int32fromstr.asm"
	.include "imath/int32math.asm"
	.include "imath/int32multiply.asm"
	.include "imath/int32tostr.asm"
	.include "imath/int32unary.asm"
	.include "utility/check.asm"
	.include "utility/scanner.asm"
	.include "utility/stack.asm"

.section code

mainHandler:
	dispatch mainVectors

mainVectors:
	.word LinkEvaluate         ; index 0
	.word LinkEvaluateInteger  ; index 2
	.word LinkEvaluateSmallInt ; index 4
.send code
