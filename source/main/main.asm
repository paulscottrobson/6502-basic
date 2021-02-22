;
;	Automatically generated
;
	.include "00start.asm"
	.include "evaluate/binary.asm"
	.include "evaluate/dereference.asm"
	.include "evaluate/evaluate.asm"
	.include "imath/int32binary.asm"
	.include "imath/int32compare.asm"
	.include "imath/int32divide.asm"
	.include "imath/int32fromstr.asm"
	.include "imath/int32math.asm"
	.include "imath/int32multiply.asm"
	.include "imath/int32tostr.asm"
	.include "imath/int32unary.asm"

mainHandler:
	dispatch mainVectors

mainVectors:
