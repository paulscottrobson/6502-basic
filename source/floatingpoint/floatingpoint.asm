;
;	Automatically generated
;
	.include "addsub.asm"
	.include "convert.asm"
	.include "importexport.asm"
	.include "muldiv.asm"

floatingpointHandler:
	dispatch floatingpointVectors

floatingpointVectors:
	.word FPAdd                ; index 0
	.word FPDivide             ; index 2
	.word FPImpossible         ; index 4
	.word FPMultiply           ; index 6
	.word FPSubtract           ; index 8
	.word FPFtoI               ; index 10
	.word FPImport             ; index 12
	.word FPItoF               ; index 14
