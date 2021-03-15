
For O = 0 to 3 step 3
	P = &200
	ldx #0
	.loop
		dex : bne loop2
	rts
	.loop2
Next O