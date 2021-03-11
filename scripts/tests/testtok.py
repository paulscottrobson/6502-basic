# *****************************************************************************
# *****************************************************************************
#
#		Name:		testtok.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		9th March 2021
#		Purpose:	String mani.pulation tests
#
# *****************************************************************************
# *****************************************************************************

import random,sys
sys.path.append("..")
sys.path.append("../scripts")
from tokeniser import *
from tokens import *

class TokeniserTest(object):

	def __init__(self,count,tgtFile,enableTest):
		random.seed()
		self.seed = random.randint(10000,99999)
		self.enable = enableTest
		#self.seed = 89671
		random.seed(self.seed)
		self.tokeniser = Tokeniser()
		self.tokens = Tokens().getAllTokens()
		self.tokenKeys = [x for x in self.tokens.keys()]
		h = open(tgtFile,"w")
		header= ";\n;\tAutomatically generated\n;\n"							# header used.
		h.write(header)
		h.write(";\n;\tBuilt using seed {0}\n;\n".format(self.seed))
		self.output(h,self.createLine(),"1")
		h.close()
		#
	def output(self,h,line,stem = ""):
		h.write("TokenText{0}:\n".format(stem))
		bline = ",".join(["${0:02x}".format(x) for x in [ord(x) for x in line]])
		if self.enable:
			h.write("\t.byte\t{0},{1},$FF\n".format(len(line),bline))
		result = self.tokeniser.tokenise(line)+[0x80]
		h.write("TokenBytes{0}:\n".format(stem))
		if self.enable:
			h.write('\t.byte\t{0}\n'.format(",".join(["${0:02x}".format(c) for c in result])))
		#
	def createLine(self):
		t = self.getElement()
		while len(t) < 100:
			nt = self.getElement()
			if self.isid(nt[0]) and self.isid(t[-1]):
				t = t + " "
			t = t + nt
		return t
		#
	def getElement(self):
		n = random.randint(0,4)
		if n == 0:
			return self.randomToken()
		if n == 1:
			return str(random.randint(0,1000))
		if n == 2:
			return "&{0:x}".format(random.randint(0,1000))
		if n == 3 or n == 4:
			s = "".join([chr(random.randint(97,117)) for x in range(0,random.randint(1,6))])
			if n == 4:
				return '"'+s+'"'
			return  s+["","(","$","$(","#","#("][random.randint(0,5)]
		return False
		#
	def randomToken(self):
		k = self.tokenKeys[random.randint(0,len(self.tokenKeys)-1)]
		k = self.tokens[k]["token"]
		if k.startswith("[") or k == "&":
			k = self.randomToken()
		return k
		#
	def isid(self,c):
		return "abcdefghijklmnopqrstuvwxyz0123456789_.".find(c.lower()) >= 0
		#
	def randomLine(self):
		s = """
			' "This is a comment"
			a = sys(&1028)
			list
			a_1 = -99
			x = -2
			c1$ = "SAVEME"+"test"
			print "START",a_1,c1$,x
			proc show()
			proc demo(42,&12345678,"INDEMO!!")
			proc show()
			print "END",a_1,c1$,x
			proc show()
			c1$ = "xxxxxxxxxxxxxAAAAAA"+"!"
			print c1$,len(c1$)
			proc show()
			repeat:until False

			defproc demo(a_1,x,c1$)
			proc show()
			c1$ = c1$ + "!!!!"
			proc show()
			proc xo2("*")
			print "DEMO",a_1,ca_1$,"$";str$(x,16),"$"str$(@c1$,16)
			endproc

			defproc xo2(c1$)
			print "XO2";c1$
			endproc

			defproc show()
			a = @c1$
			print "$";str$(deek(a),16),peek(deek(a)-1)
			endproc

			xx xx(4) xx$ xx$(4) xx# xx#(4)	
		""".split("\n")
		s = [x for x in s if x.strip() != ""]
		return s[random.randint(0,len(s)-1)]

if __name__ == "__main__":		
	t = TokeniserTest(1,"../source/generated/toktest.inc",len(sys.argv) == 1)
