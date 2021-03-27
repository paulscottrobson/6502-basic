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
		h.write("\n--- Variable group {0} ---\n".format(self.tails[t]))
		for te in range(0,self.tableSize):
			tLink = te * 2 + hashBase
			ptr = self.deek(tLink)
			if ptr != 0:
				h.write("\tHashtable {0:2} link ptr at ${1:04x} (first ${2:04x})\n".format(te,tLink,ptr))
				while ptr != 0:
					self.dumpVar(h,ptr,t)
					ptr = self.deek(ptr)
	#
	def dumpVar(self,h,p,t):
		s = self.getName(self.deek(p+2))+self.tails[t]
		v = "."
		if (t % 2) == 1:
			s = s + ")"
			v = "@${0:04x}".format(self.deek(p+5))
		else:
			v = self.getSimpleValue(p+5,t)
		h.write("\t\tRecord @${0:04x} : [${3:02x}] {1:10} = {2}\n".format(p,s,v,self.peek(p+4)))
		if t % 2 == 1:
			l = self.renderArray(self.deek(p+5),t)
			h.write("\t\t\t{0}\n".format(l))
	#
	def getName(self,a):
		s = ""
		while self.peek(a) < 0x3A:
			c = self.peek(a)
			s = s + (chr(c) if c >= 0x20 else chr(c+96))
			a = a + 1
		return s.replace("-","_")
	#
	def getString(self,a):
		return '"'+("".join([chr(self.peek(a+i+1)) for i in range(0,self.peek(a))]))+'"'
	#
	def getSimpleValue(self,p,t,aShow = False):
		if t == 0:
			n = self.leek(p)
			v = str(n if n <= 0x7FFFFFFF else n-0x100000000)
		if t == 2:
			a = self.deek(p)
			v = self.getString(a)
			if not aShow:
				v += " (${0:04x})".format(a)
		return v
	#
	def renderArray(self,p,t):
		array = []
		sz = 2
		if t == 1:
			sz = 4
		if t == 5:
			sz = 6
		for i in range(0,(self.deek(p) & 0x7FFF)+1):
			if (self.deek(p) & 0x8000) == 0:
				p2 = p + 2 + i * sz
				array.append(self.getSimpleValue(p2,t-1,True))
			else:
				p2 = p + 2 + i * 2
				array.append(self.renderArray(self.deek(p2),t))
#				array.append("{0:x}".format(self.deek(p2)))
		return "("+",".join(array)+")"

Dumper().dump(sys.stdout)	

