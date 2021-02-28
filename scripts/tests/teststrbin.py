# *****************************************************************************
# *****************************************************************************
#
#		Name:		teststrbin.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		28th February 2021
#		Purpose:	Binary test classes (strings)
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

# *****************************************************************************
#
#				Binary string operations (concat and compare)
#
# *****************************************************************************

class StrBinOpTest(Test):
	def getTest(self,n):
		s1 = self.getString()
		s2 = self.getString()
		if random.randint(0,1) == 0:
			return '("{0}"+"{1}") = "{2}"'.format(s1,s2,s1+s2)
		else:
			op = ["=",">","<",">=","<=","<>"][random.randint(0,5)]
			if op == "=":
				r = s1 == s2
			if op == ">":
				r = s1 > s2
			if op == "<":
				r = s1 < s2
			if op == "<>":
				r = s1 != s2
			if op == ">=":
				r = s1 >= s2
			if op == "<=":
				r = s1 <= s2
			return '("{0}" {1} "{2}") = {3}'.format(s1,op,s2,-1 if r != 0 else 0)

	def getString(self):
		return "".join([chr(random.randint(97,100)) for x in range(0,random.randint(0,4))])

if __name__ == "__main__":		
	t = StrBinOpTest(500)
