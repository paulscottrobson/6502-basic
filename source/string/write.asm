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
;		(ii) 	Page is >= MSB of softMemAlloc
;		(iii) 	Page is < highMemory 
;
;		Concretion is limited :
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

StringWrite: 	;; <write>
		debug





		.send 	code
