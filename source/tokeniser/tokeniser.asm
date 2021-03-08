;
;	Automatically generated
;
	.include "detokenise/detokenise.asm"
	.include "detokenise/dtprint.asm"
	.include "detokenise/identifier.asm"
	.include "detokenise/token.asm"
	.include "tokenise/test.asm"
	.include "tokenise/tokenise.asm"
	.include "tokentext.asm"

.section code

tokeniserHandler:
	dispatch tokeniserVectors

tokeniserVectors:
	.word Detokenise           ; index 0
	.word ListLine             ; index 2
.send code
