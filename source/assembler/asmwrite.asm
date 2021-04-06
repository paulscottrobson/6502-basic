; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		asmwrite.asm
;		Purpose:	Decode operand
;		Created:	15th March 2021
;		Reviewed: 	6th April 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage
finalOpcode:
		.fill 	1
		.send 	 storage		

		.section code	

; ************************************************************************************************
;
;				Write instruction. A is opcode, X the number of parameters.
;
; ************************************************************************************************

AsmWriteInstruction:
		sta 	finalOpcode					; save opcode.
		.pshy 								; save Y
		lda 	SingleLetterVar+("O"-"A")*4	; check O (e.g. what do we display/check.)
		and 	#2
		beq 	_ASMWNoEcho 				; if bit 2 zero then don't echo.
		;
		;		Echo hexadecimal code to console.
		;
		lda 	SingleLetterVar+("P"-"A")*4+1 ; write address in P
		jsr 	AWIWriteHex
		lda 	SingleLetterVar+("P"-"A")*4 
		jsr 	AWIWriteHex
		lda 	finalOpcode 				; write opcode
		jsr 	AWIWriteHexSpace
		cpx 	#0
		beq 	_ASMWEchoExit
		lda 	esInt0
		jsr 	AWIWriteHexSpace
		cpx 	#1
		beq 	_ASMWEchoExit
		lda 	esInt1
		jsr 	AWIWriteHexSpace
_ASMWEchoExit:
		.pshx
		.device_crlf
		.pulx#
		;
		;		Now just output the actual values to memory.
		;
_ASMWNoEcho:
		lda 	finalOpcode 				; opcode
		jsr 	AsmWriteByte
		cpx 	#0	 						; exit if no operands
		beq 	_ASMWExit
		lda 	esInt0	 					; low byte
		jsr 	AsmWriteByte
		cpx 	#1
		beq 	_ASMWExit
		lda 	esInt1 						; high byte
		jsr 	AsmWriteByte
_ASMWExit:
		.puly
		rts

; ************************************************************************************************
;
;						Write out byte A to wherever P variable is pointing.
;
;	 				 (Could be upgraded to write to banked RAM for P >= $10000 ?)
;
; ************************************************************************************************

AsmWriteByte:		
		ldy 	#0
		pha
		lda 	SingleLetterVar+("P"-"A")*4 ; copy address to temp0
		sta 	temp0
		lda 	SingleLetterVar+("P"-"A")*4+1
		sta 	temp0+1
		pla 								; write out the byte.
		sta 	(temp0),y

		inc 	SingleLetterVar+("P"-"A")*4	; increment P
		bne 	_AWBNoCarry
		inc 	SingleLetterVar+("P"-"A")*4+1
_AWBNoCarry:
		rts

; ************************************************************************************************
;
;								Simple Hex -> Console routines
;
; ************************************************************************************************

AWIWriteHexSpace:
		pha
		lda 	#" "
		jsr 	AWIPrintChar
		pla
AWIWriteHex:
		pha
		lsr 	a		
		lsr 	a		
		lsr 	a		
		lsr 	a		
		jsr 	AWIPrintNibble
		pla
AWIPrintNibble:
		and 	#15
		cmp 	#10
		bcc 	_AWIPNDigit
		adc 	#6 
_AWIPNDigit:
		adc 	#48
AWIPrintChar:		
		sta 	tempShort
		.pshx
		lda 	tempShort
		.device_printascii
		.pulx
		rts		

		.send 	code		

