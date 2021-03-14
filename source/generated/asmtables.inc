;
;	Automatically generated
;
OpcodeTable:
	.byte	$01			; $93 ora
	.byte	$21			; $94 (and)
	.byte	$41			; $95 eor
	.byte	$61			; $96 adc
	.byte	$81			; $97 sta
	.byte	$a1			; $98 lda
	.byte	$c1			; $99 cmp
	.byte	$e1			; $9a sbc
	.byte	$02			; $9b asl
	.byte	$22			; $9c rol
	.byte	$42			; $9d lsr
	.byte	$62			; $9e ror
	.byte	$82			; $9f stx
	.byte	$a2			; $a0 ldx
	.byte	$c2			; $a1 dec
	.byte	$e2			; $a2 inc
	.byte	$60			; $a3 stz
	.byte	$20			; $a4 bit
	.byte	$80			; $a5 sty
	.byte	$a0			; $a6 ldy
	.byte	$c0			; $a7 cpy
	.byte	$e0			; $a8 cpx
	.byte	$00			; $a9 tsb
	.byte	$10			; $aa trb
	.byte	$14			; $ab jsr
	.byte	$40			; $ac jmp
	.byte	$10			; $ad bpl
	.byte	$30			; $ae bmi
	.byte	$50			; $af bvc
	.byte	$70			; $b0 bvs
	.byte	$90			; $b1 bcc
	.byte	$b0			; $b2 bcs
	.byte	$d0			; $b3 bne
	.byte	$f0			; $b4 beq
	.byte	$80			; $b5 bra
	.byte	$00			; $b6 brk
	.byte	$08			; $b7 php
	.byte	$18			; $b8 clc
	.byte	$28			; $b9 plp
	.byte	$38			; $ba sec
	.byte	$40			; $bb rti
	.byte	$48			; $bc pha
	.byte	$58			; $bd cli
	.byte	$5a			; $be phy
	.byte	$60			; $bf rts
	.byte	$68			; $c0 pla
	.byte	$78			; $c1 sei
	.byte	$7a			; $c2 ply
	.byte	$88			; $c3 dey
	.byte	$8a			; $c4 txa
	.byte	$98			; $c5 tya
	.byte	$9a			; $c6 txs
	.byte	$a8			; $c7 tay
	.byte	$aa			; $c8 tax
	.byte	$b8			; $c9 clv
	.byte	$ba			; $ca tsx
	.byte	$c8			; $cb iny
	.byte	$ca			; $cc dex
	.byte	$d8			; $cd cld
	.byte	$da			; $ce phx
	.byte	$e8			; $cf inx
	.byte	$ea			; $d0 nop
	.byte	$f8			; $d1 sed
	.byte	$fa			; $d2 plx

Group2OpcodeAvailability:
	.byte	$57			; $9b asl $02
	.byte	$57			; $9c rol $22
	.byte	$57			; $9d lsr $42
	.byte	$57			; $9e ror $62
	.byte	$05			; $9f stx $82
	.byte	$05			; $a0 ldx $a2
	.byte	$55			; $a1 dec $c2
	.byte	$55			; $a2 inc $e2
	.byte	$11			; $a3 stz $60
	.byte	$55			; $a4 bit $20
	.byte	$05			; $a5 sty $80
	.byte	$55			; $a6 ldy $a0
	.byte	$15			; $a7 cpy $c0
	.byte	$05			; $a8 cpx $e0
	.byte	$05			; $a9 tsb $00
	.byte	$05			; $aa trb $10
	.byte	$04			; $ab jsr $14
	.byte	$04			; $ac jmp $40

AssemblerSpecialCases:
	.byte	$ac,10,$6c		; jmp (abs)
	.byte	$ac,11,$7c		; jmp (abs,x)
	.byte	$a0,6,$be		; ldx abs,y
	.byte	$a0,9,$b6		; ldx zp,y
	.byte	$9f,9,$96		; stx zp,y
	.byte	$a2,2,$1a		; inc acc
	.byte	$a1,2,$3a		; dec acc
	.byte	$a4,0,$89		; bit #
	.byte	$a3,3,$9c		; stz abs
	.byte	$a3,7,$9e		; stz abs,x
	.byte	0
