InitialiseAll:
	lda #0
	.assembler_controlhandler
	lda #0
	.device_controlhandler
	lda #0
	.interaction_controlhandler
	lda #0
	.main_controlhandler
	lda #0
	.string_controlhandler
	lda #0
	.tokeniser_controlhandler
	lda #0
	.variable_controlhandler
	rts
