;
;	Automatically generated
;
	.include "detokenise.asm"

.section code

tokeniserHandler:
	dispatch tokeniserVectors

tokeniserVectors:
	.word Detokenise           ; index 0
	.word ListLine             ; index 2
.send code
