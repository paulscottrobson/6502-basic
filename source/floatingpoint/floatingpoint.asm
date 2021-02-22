;
;	Automatically generated
;
	.include "addsub.asm"
	.include "compare.asm"
	.include "convert.asm"
	.include "importexport.asm"
	.include "muldiv.asm"

floatingpointHandler:
	dispatch floatingpointVectors

floatingpointVectors:
	.word FPAdd                ; index 0
	.word FLTCompare           ; index 2
	.word FPDivide             ; index 4
	.word FPImpossible         ; index 6
	.word FPMultiply           ; index 8
	.word FPSubtract           ; index 10
	.word FPFtoI               ; index 12
	.word FPImport             ; index 14
	.word FPItoF               ; index 16
