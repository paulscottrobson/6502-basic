;
;	Automatically generated
;
	.include "importexport.asm"

floatingpointHandler:
	dispatch floatingpointVectors

floatingpointVectors:
	.word FPImport             ; index 0
