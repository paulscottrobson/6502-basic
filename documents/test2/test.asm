
;
;		Macro test.
;


		* = $1000

editor_delete .macro 
	lda 	\1
	ldy 	\2	
	ldx 	#len(\@)
	jsr 	Editor		
	.endm


	editor_delete 	#1,#2
	editor_delete 	$04,$05
;;	editor_delete 	#3

Editor:
	rts

