;
;	Automatically generated
;
	.include "addsub.asm"
	.include "compare.asm"
	.include "convert.asm"
	.include "importexport.asm"
	.include "loadstore.asm"
	.include "muldiv.asm"
	.include "unary.asm"
.section code

floatingpointHandler:
	dispatch floatingpointVectors

floatingpointVectors:
	.word FPLoad               ; index 0
	.word FAbs                 ; index 2
	.word FPAdd                ; index 4
	.word FLTCompare           ; index 6
	.word FPDivide             ; index 8
	.word FPImpossible         ; index 10
	.word FPMultiply           ; index 12
	.word FNegate              ; index 14
	.word FSgn                 ; index 16
	.word FPSubtract           ; index 18
	.word FPFtoI               ; index 20
	.word FPPower              ; index 22
	.word FPImport             ; index 24
	.word FPItoF               ; index 26
.send code
