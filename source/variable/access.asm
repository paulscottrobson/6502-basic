; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		access.asm
;		Purpose:	Access a variable.
;		Created:	22nd February 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

varHash:									; hash total
		.fill	1
varType: 									; type byte
		.fill 	1
varEnd:										; Y value of byte after identifier.
		.fill 	1

		.send 	storage

		.section zeropage

hashList: 									; address of start of hash table list.
		.fill 	2

		.send 	 zeropage

		.section code		
		
; ************************************************************************************************
;
;					Put a reference on the stack at A, returns stack level in A.
;
; ************************************************************************************************

AccessVariable:	;; <access>
		tax 								; stack in X
		iny							
		lda 	(codePtr),y
		dey
		cmp 	#TYPE_INT 					; is it one of the end markers ?
		bne 	_AVLong
		;
		;		Integer variable A-Z which are much quicker.
		;
		lda 	(codePtr),y 				; this is the 6 bit ASCII of A-Z 1-26
		sec 	 							; make it 0-25
		sbc 	#1
		asl 	a 							; x 4 is LSB of address
		asl 	a
		sta 	esInt0,x
		lda 	#SingleLetterVar >> 8 		; make it an address
		sta 	esInt1,x
		lda 	#$80 						; type is integer reference.
		sta 	esType,x
		iny 								; skip over the variable reference in the code.
		iny 
		txa 								; stack in A to return.
		rts
		;
		;		The second character isn't integer variable, so it can't be a default integer
		;
_AVLong:pshx 								; save X on the stack.
		jsr 	AccessSetup 				; set up the basic stuff.
		jsr 	FindVariable 				; does the variable exist already
		bcs 	_AVFound
		lda 	varType 					; is the variable type an array
		lsr 	a
		bcc 	_AVCanCreate
		error 	noauto 						; we do not autocreate arrays.
		;
_AVCanCreate:		
		jsr 	CreateVariable 				; no, create it.
_AVFound:		
		pulx
		;
		clc 								; copy temp0 (variable record address)
		lda 	temp0 						; +5 (to point to the data)
		adc 	#5
		sta 	esInt0,x
		lda 	temp0+1
		adc 	#0
		sta 	esInt1,x
		lda 	#0
		sta 	esInt2,x
		sta 	esInt3,x
		;
		ldy 	varType 					; get the type ID from the type.
		lda 	_AVTypeTable-$3A,y
		sta 	esType,x
		;
		ldy 	varEnd 						; restore Y
		;
		; TODO: Array stuff.
		;
		txa 								; return stack in A and return
		rts

_AVTypeTable:
		.byte 	$80,$80						; integer
		.byte 	$C0,$C0 					; string
		.byte 	$81,$81 					; float

; ************************************************************************************************
;
;		Setup : hashList 	to point to the head of the relevant hash table.
;				varHash 	contains the current hash for this variable.
;				varType		contains the type of the variable ($3A-$3F)
;				varEnd 		contains the Y value after the variable identifier
;
; ************************************************************************************************

AccessSetup:
		lda 	#0 							; zero the hash byte.
		sta 	varHash
		pshy 								; save Y position.

_ASLoop:lda 	(codePtr),y					; get next identifier character
		cmp 	#$3A 						; is it 3A-3F which end all identifiers ?
		bcs 	_ASComplete
		clc 								; add to the hash. Might improve this.
		adc 	varHash

		;lda 	#0
		
		sta 	varHash
		iny 								; next character
		jmp 	_ASLoop

_ASComplete:
		sta 	varType 					; save variable type byte
		iny
		sty 	varEnd 						; save the ending position.
		;
		sec 								; convert type byte from $3A-$3F to 0..5
		sbc 	#$3A
		;
		asl 	a 							; multiply by hashTableSize (8 in this case)
		asl 	a
		asl 	a
		;
		asl 	a 							; 2 bytes/word
		sta 	temp0 						; this is the offset to the start of the table.
		;
		lda 	varHash 					; get hash
		and 	#(hashTableSize-1)			; force into range
		asl  	a 							; x 2 (for word) and CC
		adc 	temp0 						; now offset from the start of the hash table.
		;
		adc 	#hashTables & $FF 			; add to hash table base address
		sta 	hashList
		lda 	#hashTables >> 8
		adc 	#0
		sta 	hashList+1

		puly
		rts

		.send code		
		