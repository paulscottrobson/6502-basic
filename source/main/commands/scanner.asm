; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		scanner.asm
;		Purpose:	Proc search/scanner
;		Created:	4th March 2021
;		Reviewed: 	11th March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
procList: 									; address of line pointer hi/low / hash for all procs
		.fill 	2		 					; terminated by name high being zero.

yInLine:									; offset in codePtr. 				
		.fill 	1		

		.send 	storage

		.section code

; ************************************************************************************************
;
;						Find Procedure at (codePtr),y, put line in temp0.
;									and length of procname in A
;
; ************************************************************************************************

FindProcedure:
		sty 	yInLine 					; save current position.
		jsr 	CalculateProcedureHash		; calculate the hash of the procedure.
		sta 	temp1
		;
		lda		procList 					; put procList address in temp2
		sta 	temp2
		lda 	procList+1
		sta 	temp2+1
		ldy 	#0 							; position in this table.
		;
		;		Try next proc table entry.
		;
_FPLoop:									; check the MSB is non zero
		lda 	(temp2),y
		beq 	_FPError 					; if so, we don't know this procedure.
		sta 	temp0+1 					; copy MSB/LSB to temp0 as we go.
		iny
		lda 	(temp2),y
		sta 	temp0
		iny
		 	
		lda 	(temp2),y					; check the procedure hash.
		cmp 	temp1
		bne 	_FPNext 					; hash is different, go to next.
		;
		;		At this point temp0 points to the start of line, the name is at (checkline)+4
		;		so we compare this against code (codePtr)+yInLine-4
		;
		sec
		lda 	yInLine 					; position in line must be at least 4
		sbc 	#4
		clc
		adc 	codePtr
		sta 	temp3
		lda 	codePtr+1
		adc 	#0
		sta 	temp3+1
		;
		;		Now compare the names.
		;
		.pshy
		ldy 	#4
_FPCName:
		lda 	(temp3),y 					; check the same
		cmp 	(temp0),y
		bne 	_FPpulYNext 				; if different go to next one.
		iny
		cmp 	#$3A
		bcc 	_FPCName 					; compare the whole lot....
		;
		;		We have a match.
		;
		pla 								; throw away the saved Y
		tya 								; length of name is Y-4
		sec
		sbc 	#4
		ldy 	yInLine  					; get the original Y back
		rts		
		;
_FPpulYNext:
		.puly
		;
		;		Fail, go to next. To speed up the hash check 
		;
_FPNext:
		iny 								; next procedure record.
		bpl 	_FPLoop 					; if done 128 already ... e.g. Y -ve
		;
		tya 								; subtract 128 from Y
		sec
		sbc 	#128
		tay
		;
		clc 								; add 128 to temp2, so we can have more than
		lda 	temp2 						; 255/3 = 85 procedures
		adc 	#128
		sta 	temp2
		bcc 	_FPLoop
		inc 	temp2+1
		jmp 	_FPLoop

_FPError:
		.throw 	NoProc				

; ************************************************************************************************
;
;						Scan code for DEFPROC 	(Must be start of line)
;
; ************************************************************************************************

ScanProc:
		.pshy		
		lda 	lowMemory 					; copy the start of the procList, at low memory
		sta 	procList
		lda 	lowMemory+1
		sta 	procList+1
		jsr 	ResetCodeAddress 			; back to the start.
		;
		;		Look at next line for DEFPROC
		;
_ScanLoop:
		ldy 	#0 							; check reached program end
		lda 	(codePtr),y
		beq 	_ScanExit
		ldy 	#3							; get first token
		lda 	(codePtr),y 				
		cmp 	#TKW_DEFPROC				; skip to next if not DEFPROC
		bne 	_ScanNext
		;
		;		Found, write into table.
		;
		lda 	codePtr+1 					; write high and low address of this line.
		jsr 	_ScanWrite
		lda 	codePtr
		jsr 	_ScanWrite
		ldy 	#4 							; start of name part
		jsr 	CalculateProcedureHash 		; calculate procedure hash
		jsr 	_ScanWrite					; and write that
		;
		;		Go to next code line.
		;
_ScanNext: 									; go to next line, and loop round.
		clc
		ldy 	#0
		lda 	(codePtr),y
		adc 	codePtr
		sta 	codePtr
		bcc 	_ScanLoop
		inc 	codePtr+1
		jmp 	_ScanLoop		

_ScanExit:
		lda 	#0 							; write ending zero.
		jsr 	_ScanWrite
		.puly
		rts
;
;		Write A into lowMemory, expanding the procedure table.
;
_ScanWrite: 									
		ldy 	#0				
		sta 	(lowMemory),y
		inc 	lowMemory
		bne 	_SWNoCarry
		inc 	lowMemory+1
_SWNoCarry:
		rts				

; ************************************************************************************************
;
;								Calculate hash at (codePtr),y
;
; ************************************************************************************************

CalculateProcedureHash:
		lda 	#0 							; clear hash.
		sta 	temp0
_CPHLoop:
		clc 								; add character and rotate and add carry back in
		lda 	(codePtr),y
		adc 	temp0
		ror 	a
		adc 	#13 						; primes usually good for this sort of thing.
		sta 	temp0 						; (down with this sort of thing)
		lda 	(codePtr),y
		iny 								; advance incase we go round again.
		cmp 	#$3A
		bcc 	_CPHLoop
		lda 	temp0
		rts

		.send 	code

; ************************************************************************************************
;
;									Changes and Updates
;
; ************************************************************************************************
;
;		Date			Notes
;		==== 			=====
;		07-Mar-21 		Pre code read v0.01
;
; ************************************************************************************************
		