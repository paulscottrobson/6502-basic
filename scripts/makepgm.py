# *****************************************************************************
# *****************************************************************************
#
#		Name:		makepgm.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		26th February 2021
#		Purpose:	Tokenises complete program.
#
# *****************************************************************************
# *****************************************************************************

import os,re,sys
from tokeniser import *
from tokens import *

# *****************************************************************************
#
#							Build a complete program
#
# *****************************************************************************

class ProgramBuilder(object):
	def __init__(self):
		self.tokens = Tokens()									
		self.tokeniser = Tokeniser()
		self.code = [] 											
		self.nextLineNumber = 1
	#
	#		Convert line number + line text to byte sequence.
	#
	def makeLine(self,lineNumber,lineText):
		code = self.tokeniser.tokenise(lineText)
		code = [ lineNumber & 0xFF,lineNumber >> 8] + code + [ self.tokens.getEOLToken() ]
		code.insert(0,len(code)+1)
		return code
	#
	#		Append line number/program code. Line number optional
	#
	def add(self,lineNumber,lineText = None):
		if lineText is None:
			lineText = lineNumber 											# take advantage of typing :)
			lineNumber = self.nextLineNumber
		else:
			assert lineNumber >= self.nextLineNumber,"Line number sequence"
		self.nextLineNumber = lineNumber+1
		#print(lineNumber,lineText)
		self.code += self.makeLine(lineNumber,lineText)
	#
	#		Load source file.
	#
	def load(self,srcFile):
		for l in open(srcFile).readlines():
			if not l.startswith(";"):
				m = re.match("^(\\d+)(.*)$",l)
				if m is not None:
					self.add(int(m.group(1)),m.group(2).strip())
				else:
					if l.strip() != "":
						self.add(l.strip())
	#
	#		Export as assembly include file
	#
	def exportAsm(self,tgtFile):
		h = open(tgtFile,"w")
		header= ";\n;\tAutomatically generated\n;\n"	
		h.write(header)
		h.write("\t.byte {0}\n\n".format(",".join([str(x) for x in self.code+[0]])))
		h.close()
	#
	#		Export binary dump
	#
	def exportBin(self,tgtFile):
		h = open(tgtFile,"wb")
		h.write(bytes(self.code+[0]))
		h.close()

if __name__ == "__main__":
	for f in sys.argv[1:]:
		pb = ProgramBuilder()
		pb.load(f)
		pb.exportAsm("../source/generated/testcode.inc".replace("/",os.sep))
		pb.exportBin("../source/generated/testcode.bin".replace("/",os.sep))
