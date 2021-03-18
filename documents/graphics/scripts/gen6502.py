# *******************************************************************************************
# *******************************************************************************************
#
#       File:           asm6502.py
#       Date:           13th November 2020
#       Purpose:        Creates class with 6502 mnemonic values
#       Author:         Paul Robson (paul@robson.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,re,os

opcodes = """
00 _ BRK
01 ix ORA (oper,X)
05 z ORA oper
06 z ASL oper
08 _ PHP
09 im ORA #oper
0A ! ASL A
0D a ORA oper
0E a ASL oper
10 rel BPL oper
11 iy ORA (oper),Y
15 zx ORA oper,X
16 zx ASL oper,X
18 _ CLC
19 ay ORA oper,Y
1D ax ORA oper,X
1E ax ASL oper,X
20 a JSR oper
21 ix AND (oper,X)
24 z BIT oper
25 z AND oper
26 z ROL oper
28 _ PLP
29 im AND #oper
2A ! ROL A
2C a BIT oper
2D a AND oper
2E a ROL oper
30 rel BMI oper
31 iy AND (oper),Y
35 zx AND oper,X
36 zx ROL oper,X
38 _ SEC
39 ay AND oper,Y
3D ax AND oper,X
3E ax ROL oper,X
40 _ RTI
41 ix EOR (oper,X)
45 z EOR oper
46 z LSR oper
48 _ PHA
49 im EOR #oper
4A ! LSR A
4C a JMP oper
4D a EOR oper
4E a LSR oper
50 rel BVC oper
51 iy EOR (oper),Y
55 zx EOR oper,X
56 zx LSR oper,X
58 _ CLI
59 ay EOR oper,Y
5D ax EOR oper,X
5E ax LSR oper,X
60 _ RTS
61 ix ADC (oper,X)
65 z ADC oper
66 z ROR oper
68 _ PLA
69 im ADC #oper
6A ! ROR A
6C ind JMP (oper)
6D a ADC oper
6E a ROR oper
70 rel BVC oper
71 iy ADC (oper),Y
75 zx ADC oper,X
76 zx ROR oper,X
78 _ SEI
79 ay ADC oper,Y
7D ax ADC oper,X
7E ax ROR oper,X
81 ix STA (oper,X)
84 z STY oper
85 z STA oper
86 z STX oper
88 _ DEY
8A _ TXA
8C a STY oper
8D a STA oper
8E a STX oper
90 rel BCC oper
91 iy STA (oper),Y
94 zx STY oper,X
95 zx STA oper,X
96 zy STX oper,Y
98 _ TYA
99 ay STA oper,Y
9A _ TXS
9D ax STA oper,X
A0 im LDY #oper
A1 ix LDA (oper,X)
A2 im LDX #oper
A4 z LDY oper
A5 z LDA oper
A6 z LDX oper
A8 _ TAY
A9 im LDA #oper
AA _ TAX
AC a LDY oper
AD a LDA oper
AE a LDX oper
B0 rel BCS oper
B1 iy LDA (oper),Y
B4 zx LDY oper,X
B5 zx LDA oper,X
B6 zy LDX oper,Y
B8 _ CLV
B9 ay LDA oper,Y
BA _ TSX
BC ax LDY oper,X
BD ax LDA oper,X
BE ay LDX oper,Y
C0 im CPY #oper
C1 ix CMP (oper,X)
C4 z CPY oper
C5 z CMP oper
C6 z DEC oper
C8 _ INY
C9 im CMP #oper
CA _ DEX
CC a CPY oper
CD a CMP oper
CE a DEC oper
D0 rel BNE oper
D1 iy CMP (oper),Y
D5 zx CMP oper,X
D6 zx DEC oper,X
D8 _ CLD
D9 ay CMP oper,Y
DD ax CMP oper,X
DE ax DEC oper,X
E0 im CPX #oper
E1 ix SBC (oper,X)
E4 z CPX oper
E5 z SBC oper
E6 z INC oper
E8 _ INX
E9 im SBC #oper
EA _ NOP
EC a CPX oper
ED a SBC oper
EE a INC oper
F0 rel BEQ oper
F1 iy SBC (oper),Y
F5 zx SBC oper,X
F6 zx INC oper,X
F8 _ SED
F9 ay SBC oper,Y
FD ax SBC oper,X
FE ax INC oper,X
""".lower().split("\n")

h = sys.stdout
h = open(".."+os.sep+"compiler"+os.sep+"asm6502.py","w")
h.write("#\n#\tAutomatically generated\n#\n")
h.write("class Asm6502(object):\n\tpass\n\n")
for c in opcodes:
    if c != "":
        m = re.match("^([a-f0-9]+)\\s+(.*?)\\s+([a-z]+)",c)        
        assert m is not None,c+" fails match"
        aMode = m.group(2).replace("!","").replace("_","").replace("rel","")
        aMode = "_"+aMode if aMode != "" else aMode
        h.write("Asm6502.{0}{1:7} = 0x{2:02X}\n".format(m.group(3).upper(),aMode.upper(),int(m.group(1),16)))
h.close()		

        