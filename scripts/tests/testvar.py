# *****************************************************************************
# *****************************************************************************
#
#		Name:		testvar.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		1st March 2021
#		Purpose:	Test assignment and variables.
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

class AssignTest(Test):

	def prefixCode(self,h):
		self.current = {}
		for i in range(1,40):
			name = "".join([chr(random.randint(97,117)) for c in range(0,random.randint(1,5))])
			self.current[name] = None
		self.names = [x for x in self.current.keys()]

	def getTest(self,n):
		var = self.names[random.randint(0,len(self.names)-1)]
		value = str(random.randint(0,999))
		if random.randint(0,1) == 0:
			var += "$"
			value = '"'+"".join([chr(random.randint(65,85)) for s in range(0,random.randint(0,7))])+'"'
		self.current[var] = value
		return "{0} = {1}".format(var,value)

	def postfixCode(self,h):
		for n in self.names:
			if self.current[n] is not None:
				h.write("assert {0} = {1}\n".format(n,self.current[n]))

if __name__ == "__main__":		
	t = AssignTest(500)
