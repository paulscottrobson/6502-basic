# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokens.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Token class
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

# *****************************************************************************
#
#				Class encapsulating 4 groups of rokens $80-$FF
#
# *****************************************************************************

class Tokens(object):
	def __init__(self):
		self.tokens = { }													# token long ID -> data
		self.tokenToInfo = { } 												# token text -> data
		self.loadTokens()
		self.appendAssemblerTokens()

	def loadTokens(self):
		tokenID = [ 0x80 ] 													# current token for each group
		groupID = 0x00														# current group
		currentMode = Tokens.SYSTEM 										# what analysing
		#
		for t in "EOL,SH1,SH2,SH3,FPC,STR".split(","):						# add the known specials to group 0
			self.defineToken(groupID,tokenID[0],"[["+t+"]]",currentMode)
			tokenID[0] += 1
		tokenID += [tokenID[0],tokenID[0],tokenID[0]]						# start all at the same.
		#
		toks = [x.strip() for x in self.getSource().upper().split("\n")]	# get the source and split into words
		toks = [s for s in toks if not s.startswith("##")]
		toks = [x.strip() for x in (" ".join(toks)).split() if x.strip() != ""]
		for t in toks:
			if t.startswith("[") and t.endswith("]"):						# [x] is some sort of switch
				if t[1] >= '1' and t[1] <= '9':								# binary 1-9
					currentMode = Tokens.BINARY + int(t[1])
				if t == "[+]" or t == "[-]":								# structure in/out
					if t == "[+]":
						self.firstStructureMod = tokenID[groupID]
					currentMode = Tokens.INCDEPTH if t == "[+]" else Tokens.DECDEPTH
				if t == "[UNARY]":											# unary functions
					self.firstUnary = tokenID[groupID]
					currentMode = Tokens.UNARY
				if t == "[COMMAND]":										# ordinary commands
					self.firstStdToken = tokenID[groupID]
					currentMode = Tokens.STANDARD
				if t.startswith("[GROUP"):									# switch group
					groupID = int(t[-2])
			else:
				self.defineToken(groupID,tokenID[groupID],t,currentMode)
				tokenID[groupID] += 1
		#
		self.firstAsmToken = tokenID[1]										# asm mnemonics start here

	def appendAssemblerTokens(self):
		src = [x for x in self.getAsmSource().split("\n") if x.strip() != ""]
		src = [x.strip().replace(" ","").replace("\t","") for x in src if not x.startswith(":")]
		self.assemblerInfo = {}
		self.specialCases = []
		t = self.firstAsmToken
		for s in src:
			e = s.strip().lower().split(":")
			if e[2] != '5':
				assert e[1] not in self.assemblerInfo,"Duplicate "+s
				m = e[1] if e[1] != "and" else "(and)"
				self.assemblerInfo[m] = e 
				self.defineToken(1,t,m.upper(),Tokens.STANDARD)
				t += 1
			else:
				assert e[1] in self.assemblerInfo,"New code in Group 5 "+s
				self.specialCases.append(e)
	#
	#		Add a new token.
	#
	def defineToken(self,groupID,tokenID,token,typeID):
		l = groupID*1024+tokenID
		assert l not in self.tokens
		self.tokens[l] = { "group":groupID,"token":token,"id":tokenID,"longid":l,"type":typeID }
		assert token not in self.tokenToInfo,token+" duplicate"
		self.tokenToInfo[token] = self.tokens[l]
	#
	#		Getters.
	#
	def getEOLToken(self):
		return 0x80
	def getShiftToken(self,shiftLevel):
		return 0x80+shiftLevel
	def getFPMarkerToken(self):
		return 0x84
	def getStringMarkerToken(self):
		return 0x85
	def getBinaryStart(self):
		return 0x86
	def getStructModStart(self):
		return self.firstStructureMod
	def getUnaryStart(self):
		return self.firstUnary
	def getStandardStart(self):
		return self.firstStdToken
	def getBaseAsmToken(self):
		return self.firstAsmToken
	#
	def getFromToken(self,token):
		token = token.strip().upper()
		return self.tokenToInfo[token] if token in self.tokenToInfo else None
	#
	def getFromID(self,groupID,tokenID):
		n = groupID*1024+tokenID
		return self.tokens[n] if n in self.tokens else None
	def getAllTokens(self):
		return self.tokens
	#
	def getAsmInfo(self,m):
		m = m.strip().lower()
		return self.assemblerInfo[m] if m in self.assemblerInfo else None
	#
	def getAsmSpecialCases(self):
		return self.specialCases
	#
	#		Tokens Source. Currently done by hand.
	#
	def getSource(self):
		return """
		##
		##		Binary operators, must be first.
		##
		[1] and or xor
		[2] >= <= > < = <>
		[3] + -
		[4] >> << * / mod
		[5] ^
		[6] ! ?
		##
		##		Operators that effect the structure depth follow.
		[+] 
			repeat 	while 	for 	if 		defproc
		[-] 
			until 	wend 	next 	then 	endif 	endproc
		##
		##
		##		Then unary functions follow (not floating point ones.)
		##
		[unary]
			(
			len( 	sgn( 	abs( 	random(	page	
			true	false	min( 	max( 	sys(
			timer(	event(	get( 	inkey(	alloc( 	
			chr$(	left$(	mid$(	right$(	str$(
			val(	peek( 	deek(	leek( 	asc(
			int(	float( 	isval(	upper$(	lower$(
			@		~ 		&		get$(	inkey$(
			mem
		##
		##		Then command and syntax and so on.
		##
		[command]
			) 		: 		, 		; 		'
			to 		step 	proc 	local	dim		
			rem 	let 	input	else	vdu 	
			print	data	image 	at 		flip
			assert 	poke 	doke 	loke 	ink
			paper 	cls 	locate 	.		from
			# 		clear 	
		##
		##		Put these in group 1.
		##
		[group1]
			load	save 	list 	new 	break	
			run 	read 	restore	end 	stop
			xemu 	goto 	gosub 	return
		##
		##		System specific commands in group 2
		##
		[group2]
			vpoke	vdoke	vload	mode 	palette
			sprite	clg		rect 	frame 	draw
			text
		##
		##		Floating point functions and system unary functions in group 3.
		##
		[group3]
			vpeek( 	vdeek(	sprite.x(	sprite.y(	
			hit(	joy.x(	joy.y(		joy.b(
			clock(
"""		
	#
	#		CSV export of assembler.ods using colon
	#
	def getAsmSource(self):
		return """
:::0:1:2:3:4:5:6:7:8:::::
:::(ZP,X):ZP:#:ABS:(ZP,Y):ZP,X:ABS,Y:ABS,X:(ZP):::::
:::0:4:8:C:10:14:10:1C:11:::::
1:ora:1::::::::::::::
21:and:1::::::::::::::
41:eor:1::::::::::::::
61:adc:1::::::::::::::
81:sta :1:::No !:::::::::::
a1 :lda:1::::::::::::::
c1 :cmp:1::::::::::::::
e1 :sbc:1::::::::::::::
:::0:1:2:3:4:5:6:7:8:9:10:11:12:13
:::#:ZP:ACC:ABS:(ZP,Y):ZP,X:ABS,Y:ABS,X:(ZP):ZP,Y:(ABS):(ABS,X):REL:(ZP,X)
:::0:4:8:C:10:14:10:1C:11:-:-:-:-:-
02 :asl:2::X:X:X::X::X::::::
22 :rol:2::X:X:X::X::X::::::
42 :lsr :2::X:X:X::X::X::::::
62 :ror :2::X:X:X::X::X::::::
82 :stx :2::X::X::::::::::
a2 :ldx:2:X:X::X::::::::::
c2 :dec:2::X::X::X::X::::::
e2 :inc:2::X::X::X::X::::::
60:stz :2::X:: ::X::::::::
20 :bit:2::X::X::X::X::::::
80 :sty:2::X::X::X::::::::
a0:ldy :2:X:X::X::X::X::::::
c0 :cpy:2:X:X::X::X::::::::
e0 :cpx:2:X:X::X::::::::::
00:tsb:2::X::X::::::::::
10:trb:2::X::X::::::::::
14:jsr :2::::X::::::::::
40 :jmp:2::::X::::::::::
::::::::::::::::
10:bpl:3:: ::::::::::::
30:bmi:3::::::::::::::
50:bvc:3::::::::::::::
70:bvs:3::::::::::::::
90:bcc:3::::::::::::::
b0:bcs :3::::::::::::::
d0:bne:3:::::Group 1:Main Instructions::::::::
f0:beq:3:::::Group 2:Common but patterned::::::::
80 :bra:3:::::Group 3:Relative addressng::::::::
:::::::Group 4:Implied::::::::
0 :brk:4:::::Group 5:Special cases::::::::
08 :php:4::::::::::::::
18 :clc:4::::::::::::::
28 :plp:4::::::::::::::
38:sec:4::::::::::::::
40 :rti:4::::::::::::::
48 :pha:4::::::::::::::
58 :cli:4::::::::::::::
5a :phy :4::::::::::::::
60:rts:4::::::::::::::
68 :pla:4::::::::::::::
78 :sei:4::::::::::::::
7a :ply :4::::::::::::::
88 :dey:4::::::::::::::
8A:txa:4::::::::::::::
98 :tya:4::::::::::::::
9A:txs:4::::::::::::::
a8 :tay:4::::::::::::::
AA :tax :4::::::::::::::
b8 :clv:4::::::::::::::
BA :tsx:4::::::::::::::
c8 :iny:4::::::::::::::
CA :dex:4::::::::::::::
d8 :cld:4::::::::::::::
da :phx :4::::::::::::::
e8 :inx:4::::::::::::::
EA :nop:4::::::::::::::
f8 :sed:4::::::::::::::
fa :plx:4::::::::::::::
::::::::::::::::
6c :jmp:5:10:(abs)::::::::::::
7C :jmp :5:11:(abs,x)::::::::::::
BE:ldx:5:6:abs,y::::::::::::
B6:ldx:5:9:zp,y::::::::::::
96:stx :5:9:zp,y::::::::::::
1a:inc:5:2:acc::::::::::::
3a:dec:5:2:acc::::::::::::
89:bit:5:0:#::::::::::::
9c:stz :5:3:abs::::::::::::
9e:stz :5:7:abs,x::::::::::::

"""

Tokens.SYSTEM =   0x40								# shifts, eol etc.
Tokens.BINARY =   0x00 								# binary operator 00-0F
Tokens.UNARY =    0x10 								# unary function
Tokens.INCDEPTH = 0x82 								# structure level adjusters
Tokens.DECDEPTH = 0x80
Tokens.STANDARD = 0x20 								# ordinary token.

if __name__ == "__main__":
	t = Tokens()			
	print(t.tokens)
	print("EOL 	{0:x}".format(t.getEOLToken()))
	print("SH1 	{0:x}".format(t.getShiftToken(1)))
	print("FPM 	{0:x}".format(t.getFPMarkerToken()))
	print("STR 	{0:x}".format(t.getStringMarkerToken()))
	print("@BIN	{0:x}".format(t.getBinaryStart()))
	print("@STR	{0:x}".format(t.getStructModStart()))
	print("@UNA	{0:x}".format(t.getUnaryStart()))
	print("@STD	{0:x}".format(t.getStandardStart()))

	keys = [x for x in t.tokens.keys()]
	keys.sort()
	for t1 in keys:
		print(t1,t.tokens[t1])

	print(t.getBaseAsmToken())