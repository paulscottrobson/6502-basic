# *****************************************************************************
# *****************************************************************************
#
#		Name:		dumpvar.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		1st March 2021
#		Purpose:	Dump the variable table.
#
# *****************************************************************************
# *****************************************************************************

import sys

# *****************************************************************************
#
#					Variable hashlist dumper class
#
# *****************************************************************************

class Dumper(object):
	def __init__(self,binFile = "dump.bin",hashBase = 0xA68,tableSize = 8):
		self.hashBase = hashBase
		self.tableSize = tableSize
		self.binary = [x for x in open(binFile,"rb").read(-1)]
		self.tails = [ "%","%(","$","$(","#","#(" ]
	#
	def peek(self,a):
		return self.binary[a]
	def deek(self,a):
		return self.binary[a] + (self.binary[a+1] << 8)
	def leek(self,a):
		return self.binary[a] + (self.binary[a+1] << 8) + (self.binary[a+2] << 16) + (self.binary[a+3] << 24)
	#
	def dump(self,h):
		for t in range(0,5):
			self.dumpType(h,t)
	#
	def dumpType(self,h,t):
		hashBase = self.hashBase + self.tableSize * 2 * t
		h.write("\nVariable group {0}\n".format(self.tails[t]))
		for te in range(0,self.tableSize):
			tLink = te * 2 + hashBase
			ptr = self.deek(tLink)
			if ptr != 0:
				h.write("\tHashtable {0:2} link ptr at ${1:04x} first ${2:04x}\n".format(te,tLink,ptr))
				while ptr != 0:
					self.dumpVar(h,ptr,t)
					ptr = self.deek(ptr)
	#
	def dumpVar(self,h,p,t):
		s = self.getName(self.deek(p+2))+self.tails[t]
		v = "."
		if t == 0:
			n = self.leek(p+4)
			v = str(n if n <= 0x7FFFFFFF else n-0x100000000)

		h.write("\t\tRecord @${0:04x} : {1:8} = {2}\n".format(p,s,v))
	#
	def getName(self,a):
		s = ""
		while self.peek(a) < 0x3A:
			c = self.peek(a)
			s = s + (chr(c) if c >= 0x20 else chr(c+96))
			a = a + 1
		return s
Dumper().dump(sys.stdout)

