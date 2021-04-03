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
from asmdata import *
from tokendata import *

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
		toks = [x.strip() for x in TokenData().getSource().upper().split("\n")]	# get the source and split into words
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
		src = [x for x in AssemblerData().getAsmSource().split("\n") if x.strip() != ""]
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