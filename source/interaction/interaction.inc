;
;	Automatically generated
;
.section code
interaction_coldstart .macro
	ldx	#0
	jsr	interactionHandler
	.endm

interaction_warmstart .macro
	ldx	#2
	jsr	interactionHandler
	.endm

.send code
