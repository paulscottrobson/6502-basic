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
	.word _DummyControlHandler ; index 0
	.word Detokenise           ; index 2
	.word ListLine             ; index 4
	.word TokTest              ; index 6
	.word Tokenise             ; index 8
	.word TokeniseASCIIZ       ; index 10
_DummyControlHandler:
	rts
.send code
