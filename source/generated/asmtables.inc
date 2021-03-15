;
;	Automatically generated
;
OpcodeTable:
	.byte	$01			; $91 ora
	.byte	$21			; $92 (and)
	.byte	$41			; $93 eor
	.byte	$61			; $94 adc
	.byte	$81			; $95 sta
	.byte	$a1			; $96 lda
	.byte	$c1			; $97 cmp
	.byte	$e1			; $98 sbc
	.byte	$02			; $99 asl
	.byte	$22			; $9a rol
	.byte	$42			; $9b lsr
	.byte	$62			; $9c ror
	.byte	$82			; $9d stx
	.byte	$a2			; $9e ldx
	.byte	$c2			; $9f dec
	.byte	$e2			; $a0 inc
	.byte	$60			; $a1 stz
	.byte	$20			; $a2 bit
	.byte	$80			; $a3 sty
	.byte	$a0			; $a4 ldy
	.byte	$c0			; $a5 cpy
	.byte	$e0			; $a6 cpx
	.byte	$00			; $a7 tsb
	.byte	$10			; $a8 trb
	.byte	$14			; $a9 jsr
	.byte	$40			; $aa jmp
	.byte	$10			; $ab bpl
	.byte	$30			; $ac bmi
	.byte	$50			; $ad bvc
	.byte	$70			; $ae bvs
	.byte	$90			; $af bcc
	.byte	$b0			; $b0 bcs
	.byte	$d0			; $b1 bne
	.byte	$f0			; $b2 beq
	.byte	$80			; $b3 bra
	.byte	$00			; $b4 brk
	.byte	$08			; $b5 php
	.byte	$18			; $b6 clc
	.byte	$28			; $b7 plp
	.byte	$38			; $b8 sec
	.byte	$40			; $b9 rti
	.byte	$48			; $ba pha
	.byte	$58			; $bb cli
	.byte	$5a			; $bc phy
	.byte	$60			; $bd rts
	.byte	$68			; $be pla
	.byte	$78			; $bf sei
	.byte	$7a			; $c0 ply
	.byte	$88			; $c1 dey
	.byte	$8a			; $c2 txa
	.byte	$98			; $c3 tya
	.byte	$9a			; $c4 txs
	.byte	$a8			; $c5 tay
	.byte	$aa			; $c6 tax
	.byte	$b8			; $c7 clv
	.byte	$ba			; $c8 tsx
	.byte	$c8			; $c9 iny
	.byte	$ca			; $ca dex
	.byte	$d8			; $cb cld
	.byte	$da			; $cc phx
	.byte	$e8			; $cd inx
	.byte	$ea			; $ce nop
	.byte	$f8			; $cf sed
	.byte	$fa			; $d0 plx

Group2OpcodeAvailability:
	.byte	$ae			; $99 asl $02
	.byte	$ae			; $9a rol $22
	.byte	$ae			; $9b lsr $42
	.byte	$ae			; $9c ror $62
	.byte	$0a			; $9d stx $82
	.byte	$0b			; $9e ldx $a2
	.byte	$aa			; $9f dec $c2
	.byte	$aa			; $a0 inc $e2
	.byte	$22			; $a1 stz $60
	.byte	$aa			; $a2 bit $20
	.byte	$0a			; $a3 sty $80
	.byte	$ab			; $a4 ldy $a0
	.byte	$2b			; $a5 cpy $c0
	.byte	$0b			; $a6 cpx $e0
	.byte	$0a			; $a7 tsb $00
	.byte	$0a			; $a8 trb $10
	.byte	$08			; $a9 jsr $14
	.byte	$08			; $aa jmp $40

AssemblerSpecialCases:
	.byte	$aa,10,$6c		; jmp (abs)
	.byte	$aa,11,$7c		; jmp (abs,x)
	.byte	$9e,6,$be		; ldx abs,y
	.byte	$9e,9,$b6		; ldx zp,y
	.byte	$9d,9,$96		; stx zp,y
	.byte	$a0,2,$1a		; inc acc
	.byte	$9f,2,$3a		; dec acc
	.byte	$a2,0,$89		; bit #
	.byte	$a1,3,$9c		; stz abs
	.byte	$a1,7,$9e		; stz abs,x
	.byte	0
