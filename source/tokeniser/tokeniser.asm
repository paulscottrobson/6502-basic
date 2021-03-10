;
;	Automatically generated
;
	.include "detokenise/detokenise.asm"
	.include "detokenise/dtprint.asm"
	.include "detokenise/identifier.asm"
	.include "detokenise/token.asm"
	.include "tokenise/search.asm"
	.include "tokenise/test.asm"
	.include "tokenise/tokenise.asm"
	.include "tokenise/tokident.asm"
	.include "tokenise/tokinteger.asm"
	.include "tokenise/tokpunct.asm"
	.include "tokenise/tokstring.asm"
	.include "tokentext.asm"

.section code

tokeniserHandler:
	dispatch tokeniserVectors

tokeniserVectors:
	.word Detokenise           ; index 0
	.word ListLine             ; index 2
	.word Tokenise             ; index 4
	.word TokeniseASCIIZ       ; index 6
.send code
