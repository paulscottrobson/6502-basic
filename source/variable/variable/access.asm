; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		access.asm
;		Purpose:	Access a variable.
;		Created:	22nd February 2021
;		Reviewed: 	9th March 2021
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
		iny									; look at second character
		lda 	(codePtr),y
		dey
		cmp 	#TYPE_INT 					; is it the integer marker ($3A)
		bne 	_AVLong 					; no, always use the hash tables.
		;
		;		Integer variable A-Z which are much quicker access.
		;
		lda 	(codePtr),y 				; this is the 6 bit ASCII of A-Z 1-26
		sec 	 							; make it 0-25
		sbc 	#1
		asl 	a 							; x 4 as 4 bytes / variable.
		asl 	a
		sta 	esInt0,x
		lda 	#SingleLetterVar >> 8 		; make it an address
		sta 	esInt1,x
		lda 	#$80 						; type is an integer reference.
		sta 	esType,x
		iny 								; skip over the variable reference in the code.
		iny  								; (1 letter, 1 type)
		txa 								; stack in A to return.
		rts
		;
		;		The second character isn't integer variable, so it can't be a default integer
		;
_AVLong:
		.pshx 								; save X on the stack.
		jsr 	AccessSetup 				; set up the basic information we need for later 
		jsr 	FindVariable 				; does the variable exist already ?
		bcs 	_AVFound 					; yes, then its found
		lda 	varType 					; otherwise, is the variable type an array
		lsr 	a 						
		bcc 	_AVCanCreate 				; if not, we can autocreate 
		.throw 	noauto 						; but we do not autocreate arrays.
		;
_AVCanCreate:		
		jsr 	CreateVariable 				; variable does not exist, create it.
_AVFound:		
		.pulx 								; restore stack pos.
		;
		clc 								; copy temp0 (variable record address)
		lda 	temp0 						; +5 (to point to the data)
		adc 	#5 							; (first 5 bytes are link, name, hash)
		sta 	esInt0,x
		lda 	temp0+1
		adc 	#0
		sta 	esInt1,x
		lda 	#0
		sta 	esInt2,x
		sta 	esInt3,x
		;
		ldy 	varType 					; get the type ID from the type.
		lda 	_AVTypeTable-$3A,y 			; e.g. a reference to int/float/string.
		sta 	esType,x
		;
		ldy 	varEnd 						; restore Y

		lda 	VarType 					; get variable type, put LSB into C
		lsr 	a
		bcc 	_AVNotArray 				; if carry set,it is an array variable.
		jsr 	AccessArray 				; array lookup. if LSB was set.
_AVNotArray:		
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
		.pshy 								; save Y position.

_ASLoop:lda 	(codePtr),y					; get next identifier character
		cmp 	#$3A 						; is it 3A-3F which end all identifiers ?
		bcs 	_ASComplete
		clc 								; add to the hash. Might improve this.
		adc 	varHash

		;lda 	#0 							; this puts all variables in same hash table testing only
		
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
		and 	#(hashTableSize-1)			; force into range (for 8,0..7)
		asl  	a 							; x 2 (for word) and clear carry
		adc 	temp0 						; now offset from the start of the hash table.
		;
		adc 	#hashTables & $FF 			; add to hash table base address
		sta 	hashList 					; making hashLists point to the head of the link list.
		lda 	#hashTables >> 8
		adc 	#0
		sta 	hashList+1

		.puly
		rts

		.send code		
		
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
		