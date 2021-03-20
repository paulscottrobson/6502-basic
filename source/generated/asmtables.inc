;
;	Automatically generated
;
OpcodeTable:
	.byte	$01			; $94 ora
	.byte	$21			; $95 (and)
	.byte	$41			; $96 eor
	.byte	$61			; $97 adc
	.byte	$81			; $98 sta
	.byte	$a1			; $99 lda
	.byte	$c1			; $9a cmp
	.byte	$e1			; $9b sbc
	.byte	$02			; $9c asl
	.byte	$22			; $9d rol
	.byte	$42			; $9e lsr
	.byte	$62			; $9f ror
	.byte	$82			; $a0 stx
	.byte	$a2			; $a1 ldx
	.byte	$c2			; $a2 dec
	.byte	$e2			; $a3 inc
	.byte	$60			; $a4 stz
	.byte	$20			; $a5 bit
	.byte	$80			; $a6 sty
	.byte	$a0			; $a7 ldy
	.byte	$c0			; $a8 cpy
	.byte	$e0			; $a9 cpx
	.byte	$00			; $aa tsb
	.byte	$10			; $ab trb
	.byte	$14			; $ac jsr
	.byte	$40			; $ad jmp
	.byte	$10			; $ae bpl
	.byte	$30			; $af bmi
	.byte	$50			; $b0 bvc
	.byte	$70			; $b1 bvs
	.byte	$90			; $b2 bcc
	.byte	$b0			; $b3 bcs
	.byte	$d0			; $b4 bne
	.byte	$f0			; $b5 beq
	.byte	$80			; $b6 bra
	.byte	$00			; $b7 brk
	.byte	$08			; $b8 php
	.byte	$18			; $b9 clc
	.byte	$28			; $ba plp
	.byte	$38			; $bb sec
	.byte	$40			; $bc rti
	.byte	$48			; $bd pha
	.byte	$58			; $be cli
	.byte	$5a			; $bf phy
	.byte	$60			; $c0 rts
	.byte	$68			; $c1 pla
	.byte	$78			; $c2 sei
	.byte	$7a			; $c3 ply
	.byte	$88			; $c4 dey
	.byte	$8a			; $c5 txa
	.byte	$98			; $c6 tya
	.byte	$9a			; $c7 txs
	.byte	$a8			; $c8 tay
	.byte	$aa			; $c9 tax
	.byte	$b8			; $ca clv
	.byte	$ba			; $cb tsx
	.byte	$c8			; $cc iny
	.byte	$ca			; $cd dex
	.byte	$d8			; $ce cld
	.byte	$da			; $cf phx
	.byte	$e8			; $d0 inx
	.byte	$ea			; $d1 nop
	.byte	$f8			; $d2 sed
	.byte	$fa			; $d3 plx

Group2OpcodeAvailability:
	.byte	$ae			; $9c asl $02
	.byte	$ae			; $9d rol $22
	.byte	$ae			; $9e lsr $42
	.byte	$ae			; $9f ror $62
	.byte	$0a			; $a0 stx $82
	.byte	$0b			; $a1 ldx $a2
	.byte	$aa			; $a2 dec $c2
	.byte	$aa			; $a3 inc $e2
	.byte	$22			; $a4 stz $60
	.byte	$aa			; $a5 bit $20
	.byte	$2a			; $a6 sty $80
	.byte	$ab			; $a7 ldy $a0
	.byte	$2b			; $a8 cpy $c0
	.byte	$0b			; $a9 cpx $e0
	.byte	$0a			; $aa tsb $00
	.byte	$0a			; $ab trb $10
	.byte	$08			; $ac jsr $14
	.byte	$08			; $ad jmp $40

AssemblerSpecialCases:
	.byte	$ad,10,$6c		; jmp (abs)
	.byte	$ad,11,$7c		; jmp (abs,x)
	.byte	$a1,6,$be		; ldx abs,y
	.byte	$a1,9,$b6		; ldx zp,y
	.byte	$a0,9,$96		; stx zp,y
	.byte	$a3,2,$1a		; inc acc
	.byte	$a2,2,$3a		; dec acc
	.byte	$a5,0,$89		; bit #
	.byte	$a4,3,$9c		; stz abs
	.byte	$a4,7,$9e		; stz abs,x
	.byte	0
