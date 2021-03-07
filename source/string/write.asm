; ************************************************************************************************
; ************************************************************************************************
;
;		Name:		write.asm
;		Purpose:	String writing
;		Created:	2nd March 2021
;		Author:		Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

		.section storage

srcStrLen:									; length of source string.
		.fill 	1

		.send storage

		.section code		
		
; ************************************************************************************************
;
;								Write string at TOS+1 to TOS. 
;
; ************************************************************************************************
;
;		If target string is concreted already (e.g. the current storage address, the reference
;		value page is >= highMemory), then it should be reused if possible, irrespective of
;		whether it needs concreting or not, it is physically copied into the old.
;
;		If the string is in soft memory it may need 'concreting' before storing.
;
;		(i) 	Soft memory has been allocated this instruction (MSB of softMemAlloc <> 0)
;		(ii) 	Page is >= MSB of softMemAlloc.
;					either : soft Memory, in which case it needs concreting (a$ = str(42))
;							 hard Memory, in which case it needs duplicating (a$ = b$)
;
;		Special Concretion (not yet implemented) where some values are converted to constants.
;
;		(i) 	"" null string is returned as a constant.
;		(ii) 	Single character strings 32-126 returned as a constant.
;
; ************************************************************************************************
;
;		Concreted strings are stored above high memory, with the total size of the structure
;		in that address being kept in the previous byte, as follows.
;
;		[Total] [Current] [Characters ......]
;					^
;				String pointer
;
;		Only one string can be concreted per command. So when collecting parameters reset
;		soft memory before every parameter.
;		
; ************************************************************************************************
;
;		temp0 : address of the string to be written (e.g. points to length byte)
;		temp1 : address of the target (e.g. points to offset 5 in the variable record)
;
; ************************************************************************************************

StringWrite: 	;; <write>		
		tax
		pha
		.pshy
		;
		;		Check if it will overwrite the old string first.
		;
		jsr 	CheckOverwriteCurrent 
		bcs		_SWCopyCurrent
		;
		;		Check if it needs concreting.
		;
		jsr 	RequiresConcretion
		bcc 	_SWWriteReference
		;
		;		Check for special cases
		;
		jsr 	CheckSpecialConcretion
		bcs 	_SWWriteReference
		;
		;		Yes, so allocate hard memory for it (e.g. drop highMemory)
		; 		updating address in TOS for storage.
		;
		jsr 	AllocateHardMemory 
		;
		;		Physically Copy string at TOS+1 into reference stored at TOS		
		;		(do not used temp values)
		;
_SWCopyCurrent:
		jsr 	CopyStringToHardMemory
		jmp 	_SWExit
		;
		;		Store address of string at TOS+1 at reference at TOS.
		;			  (when concretion/copying is not required)
		;
_SWWriteReference
		ldy 	#0
		lda 	temp0
		sta 	(temp1),y
		iny
		lda 	temp0+1
		sta 	(temp1),y
		;
		;		Restore and exit.
		;
_SWExit:
		.puly 	
		pla
		rts		

; ************************************************************************************************
;
;		  Returns CS if string can overwrite the current. Also does some initial setup.
;
; ************************************************************************************************

CheckOverwriteCurrent:
		ldy 	#0 						; get address of string being written to temp0
		lda 	esInt1+1,x
		sta 	temp0+1 
		lda 	esInt0+1,x
		sta 	temp0
		;
		lda 	(temp0),y 				; get length of string being copied.
		sta 	srcStrLen 
		;
		lda 	esInt0,x 				; copy where the final address it being written to temp1.
		sta 	temp1 					; e.g. if it is ax$ then temp1 will point to the ax$
		lda 	esInt1,x 				; data record + 5
		sta 	temp1+1
		;
		ldy 	#1 						; get the MSB of the address of string currently stored there.
		lda 	(temp1),y 				
		cmp 	highMemory+1 			; if < high memory then it cannot be something stored
		bcc 	_COCFail 				; in hard memory.
		;
		; 		Check if it physically fits, if so return TRUE (CS) to copy over.
		;
		ldy 	#0 						; copy target address - 1 into temp2
		lda 	(temp1),y
		sbc 	#1
		sta 	temp2
		iny
		lda 	(temp1),y
		sbc 	#0
		sta 	temp2+1
		;
		ldy 	#0 						; how large is this physical chunk.
		lda 	(temp2),y
		sec  							; maximum character capacity.
		sbc 	#2
		cmp 	srcStrLen 				; if >= the required length
		bcs 	_COCCanReuse
_COCFail:
		clc
		rts
_COCCanReuse:
		sec
		rts

; ************************************************************************************************
;
;			Does it need concreting ? Required if it is soft or hard string memory.
;
; ************************************************************************************************

RequiresConcretion:
		lda 	temp0+1 				; get MSB of address of string to be written
		cmp 	highMemory+1 			; if >= high memory it is concreted
		bcs 	_RCSucceed 				; so it needs concreting again - duplication.
		;
		lda 	softMemAlloc+1 			; have we allocated any soft memory yet ?
		beq 	_RCFail 				; if not, this cannot be soft memory.
		;
		lda 	temp0+1 				; get MSB of address of string to be written
		cmp 	softMemAlloc+1 			; if >= soft mem alloc it is either soft
		bcc 	_RCFail 				; so concreting
_RCSucceed:		
		sec
		rts
_RCFail:		
		clc
		rts

; ************************************************************************************************
;
;				Allocate Hard Memory to the current string, and put it at TOS target.
;
; ************************************************************************************************

AllocateHardMemory:
		.pshy
		lda 	srcStrLen 				; characters in string
		adc 	#1+1+8 					; one for hard memory size, one for string size, extra for expansion
		bcs 	_AHMSetMax 				; max out that amount.
		cmp 	#MaxStringSize+2
		bcc 	_AHMIsOkay
_AHMSetMax:		
		lda 	#MaxStringSize+2
_AHMIsOkay:
		pha	
		eor 	#$FF 					; complement and add to high Memory
		sec  							; and copy result to TOS as target address.
		adc 	highMemory
		sta 	highMemory
		lda 	highMemory+1
		adc 	#$FF
		sta 	highMemory+1
		ldy 	#0 						; Y = 0
		pla 							; get the total size of the storage block
		sta 	(highMemory),y
		;
		clc
		lda		highMemory 				; point the target address to the byte after this.
		adc 	#1
		sta 	(temp1),y
		lda 	highMemory+1
		adc 	#0
		iny 	
		sta 	(temp1),y

		.puly
		rts

; ************************************************************************************************
;
;					Copy string at (temp0) to hard Memory as in variable record.
;
; ************************************************************************************************

CopyStringToHardMemory:
		.pshy
		ldy 	#0 						; copy target address to temp2
		lda 	(temp1),y
		sta 	temp2
		iny
		lda 	(temp1),y
		sta 	temp2+1
		;
		ldy 	srcStrLen 				; copy this + 1 characters, (length too) hence $FF compare
_CSTHMLoop:
		lda 	(temp0),y
		sta 	(temp2),y
		dey
		cpy 	#$FF
		bne 	_CSTHMLoop
		.puly
		rts

; ************************************************************************************************
;
;		Check for special concretion of string at temp0 if true, return CS and non-concrete
;		string in temp0
;
; ************************************************************************************************

CheckSpecialConcretion:
		lda 	srcStrLen 				; check string is null.
		beq 	_CSCNullString
		clc
		rts
		;
		;		If concretable string is null, then return a fixed one.
		;
_CSCNullString:
		lda 	#0
		sta 	NullString		
		set16 	temp0,NullString
		sec
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
