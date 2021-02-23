;
;	Automatically generated
;
	.include "addsub.asm"
	.include "compare.asm"
	.include "convert.asm"
	.include "importexport.asm"
	.include "loadstore.asm"
	.include "muldiv.asm"

floatingpointHandler:
	dispatch floatingpointVectors

floatingpointVectors:
	.word FPLoad               ; index 0
	.word FPAdd                ; index 2
	.word FLTCompare           ; index 4
	.word FPDivide             ; index 6
	.word FPImpossible         ; index 8
	.word FPMultiply           ; index 10
	.word FPSubtract           ; index 12
	.word FPFtoI               ; index 14
	.word FPPower              ; index 16
	.word FPImport             ; index 18
	.word FPItoF               ; index 20
