;
;	Automatically generated
;
	.include "00header/00start.asm"
	.include "commands/assert.asm"
	.include "commands/clear.asm"
	.include "commands/dim.asm"
	.include "commands/for.asm"
	.include "commands/if.asm"
	.include "commands/input.asm"
	.include "commands/let.asm"
	.include "commands/list.asm"
	.include "commands/local.asm"
	.include "commands/new.asm"
	.include "commands/poke.asm"
	.include "commands/print.asm"
	.include "commands/proc.asm"
	.include "commands/readdata.asm"
	.include "commands/rem.asm"
	.include "commands/repeat.asm"
	.include "commands/run.asm"
	.include "commands/scanner.asm"
	.include "commands/stopend.asm"
	.include "commands/text.asm"
	.include "commands/transfer.asm"
	.include "commands/vdu.asm"
	.include "commands/while.asm"
	.include "evaluate/binary.asm"
	.include "evaluate/compare.asm"
	.include "evaluate/convert.asm"
	.include "evaluate/dereference.asm"
	.include "evaluate/evaluate.asm"
	.include "evaluate/event.asm"
	.include "evaluate/support.asm"
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
	.word CheckRightParen      ; index 0
	.word LinkEvaluate         ; index 2
	.word LinkEvaluateInteger  ; index 4
	.word LinkEvaluateSmallInt ; index 6
	.word LinkEvaluateTerm     ; index 8
	.word MLInt32ToString      ; index 10
	.word PrintString          ; index 12
	.word LinkInt32FromString  ; index 14
.send code
