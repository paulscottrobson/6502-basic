# *****************************************************************************
# *****************************************************************************
#
#		Name:		testprec.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th February 2021
#		Purpose:	Precedence test classes.
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

# *****************************************************************************
#
#		Precedence test
#
# *****************************************************************************

class PrecedenceTest(Test):
	def getTest(self,n):
		expr = self.term(3)
		return "assert ({0}) = {1}".format(expr,eval(expr))		
	#
	def term(self,n):
		if n == 0 or random.randint(0,4) == 0:
			return str(random.randint(2,5))
		t = "+".join([self.term(n-1) for s in range (0,random.randint(1,3))])
		t = [x for x in t]
		for i in range(0,len(t)):
			if t[i] == "+":
				t[i] = "+-*"[random.randint(0,2)]
		t = "".join(t)
		return t if random.randint(0,1) == 0 else "("+t+")"
#
if __name__ == "__main__":		
	t = PrecedenceTest(100)
