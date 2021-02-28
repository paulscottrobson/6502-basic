# *****************************************************************************
# *****************************************************************************
#
#		Name:		testun.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th February 2021
#		Purpose:	Unary test classes.
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

# *****************************************************************************
#
#	Unary operator test
#
#	len sgn abs min max asc chr$(
#
# *****************************************************************************

class UnaryOpTest(Test):
	def getTest(self,n):
		s = random.randint(0,6)
		#
		n = random.randint(-10000,10000)
		if random.randint(0,10) == 0:
			n = random.randint(-10,10)
		#
		if s == 0:
			return "abs({0}) = {1}".format(n,abs(n))
		#
		if s == 1:			
			sg = -1 if n < 0 else 1
			sg = 0 if n == 0 else sg
			return "sgn({0}) = {1}".format(n,sg)
		#
		if s == 2:			
			n = random.randint(0,9)
			st = "".join([chr(random.randint(97,107)) for x in range(0,n)])
			return "len(\"{0}\") = {1}".format(st,len(st))
		#
		if s == 3 or s == 4:
			s = [random.randint(-1000,1000) for n in range(0,random.randint(1,5))]
			st = ",".join([str(n) for n in s])
			return "{0}({1}) = {2}".format("max" if s == 3 else "min",st,max(s) if s == 3 else min(s))
		#
		if s == 5:
			n = random.randint(35,126)
			return 'asc("{1}") = {0}'.format(n,chr(n))
		#
		if s == 6:
			n = random.randint(35,126)
			return 'chr$({0}) = "{1}"'.format(n,chr(n))
		#
		assert False,str(s)

if __name__ == "__main__":		
	t = UnaryOpTest(50)
