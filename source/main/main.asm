;
;	Automatically generated
;
	.include "00start.asm"
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
	.word test0                ; index 0
	.word test1                ; index 2
