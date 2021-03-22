;
;	Automatically generated
;
.section code
interaction_controlhandler .macro
	ldx	#0
	jsr	interactionHandler
	.endm

interaction_coldstart .macro
	ldx	#2
	jsr	interactionHandler
	.endm

interaction_warmstart .macro
	ldx	#4
	jsr	interactionHandler
	.endm

.send code
