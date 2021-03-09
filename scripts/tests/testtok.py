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

class TokeniserTest(object):

	def __init__(self,count,tgtFile):
		random.seed()
		self.seed = random.randint(10000,99999)
		#self.seed = 35538
		random.seed(self.seed)
		self.tokeniser = Tokeniser()
		h = open(tgtFile,"w")
		h.write(";\n;\tBuilt using seed {0}\n;\n".format(self.seed))
		self.output(h,self.randomLine(),"1")
		h.close()
		#
	def output(self,h,line,stem = ""):
		#print(line)
		h.write("TokenText{0}:\n".format(stem))
		bline = ",".join(["${0:02x}".format(x) for x in [ord(x) for x in line]])
		h.write("\t.byte\t{0},{1},$FF\n".format(len(line),bline))
		result = self.tokeniser.tokenise(line)+[0x80]
		h.write("TokenBytes{0}:\n".format(stem))
		h.write('\t.byte\t{0}\n'.format(",".join(["${0:02x}".format(c) for c in result])))
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
	t = TokeniserTest(1,"../source/generated/toktest.inc")
