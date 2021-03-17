;
;	Automatically generated
;
	.include "commands/compat/readdata.asm"
	.include "commands/compat/transfer.asm"
	.include "commands/io/input.asm"
	.include "commands/io/print.asm"
	.include "commands/io/text.asm"
	.include "commands/io/vdu.asm"
	.include "commands/link.asm"
	.include "commands/misc/assert.asm"
	.include "commands/misc/dim.asm"
	.include "commands/misc/let.asm"
	.include "commands/misc/poke.asm"
	.include "commands/misc/rem.asm"
	.include "commands/misc/stopend.asm"
	.include "commands/structures/for.asm"
	.include "commands/structures/if.asm"
	.include "commands/structures/local.asm"
	.include "commands/structures/proc.asm"
	.include "commands/structures/proctable.asm"
	.include "commands/structures/repeat.asm"
	.include "commands/structures/scanner.asm"
	.include "commands/structures/while.asm"
	.include "commands/system/clear.asm"
	.include "commands/system/list.asm"
	.include "commands/system/loadsave.asm"
	.include "commands/system/new.asm"
	.include "commands/system/run.asm"
	.include "evaluate/binary/binary.asm"
	.include "evaluate/binary/compare.asm"
	.include "evaluate/dereference.asm"
	.include "evaluate/evaluate.asm"
	.include "evaluate/support.asm"
	.include "evaluate/unary/convert.asm"
	.include "evaluate/unary/event.asm"
	.include "evaluate/unary/unary.asm"
	.include "evaluate/unary/unary2.asm"
	.include "evaluate/unary/unarystr.asm"
	.include "imath/int32binary.asm"
	.include "imath/int32compare.asm"
	.include "imath/int32divide.asm"
	.include "imath/int32fromstr.asm"
	.include "imath/int32math.asm"
	.include "imath/int32multiply.asm"
	.include "imath/int32tostr.asm"
	.include "imath/int32unary.asm"
	.include "utility/check.asm"
	.include "utility/stack.asm"
	.include "utility/warmstart.asm"

.section code

mainHandler:
	dispatch mainVectors

mainVectors:
	.word CheckRightParen      ; index 0
	.word XCommandClear        ; index 2
	.word LinkEvaluate         ; index 4
	.word LinkEvaluateInteger  ; index 6
	.word LinkEvaluateSmallInt ; index 8
	.word LinkEvaluateTerm     ; index 10
	.word MLInt32ToString      ; index 12
	.word Command_XNew         ; index 14
	.word XCommand_Run         ; index 16
	.word Command_RunFrom      ; index 18
	.word LinkInt32FromString  ; index 20
.send code
