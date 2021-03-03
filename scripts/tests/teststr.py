# *****************************************************************************
# *****************************************************************************
#
#		Name:		teststr.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		3rd March 2021
#		Purpose:	String manipulation tests
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

class StringTest(Test):

	def prefixCode(self,h):
		self.current = {}
		for i in range(0,30):
			name = "".join([chr(random.randint(97,117)) for c in range(0,random.randint(1,5))])
			name = name + "$"
			self.current[name] = self.getValue(0,4)
			self.current[name] = ""
			h.write("{0} = \"{1}\"+\"\"\n".format(name,self.current[name]))
		self.names = [x for x in self.current.keys()]

	def getTest(self,n):
		v1 = self.names[random.randint(0,len(self.names)-1)]
		v2 = self.names[random.randint(0,len(self.names)-1)]
		#		
		n = random.randint(0,4)
		if n == 0:
			self.current[v1] = ""
			return v1+' = ""'

		if n == 1:
			self.current[v1] = self.getValue(1,5)
			return '{0} = "{1}"'.format(v1,self.current[v1])

		if n == 2:
			av = self.getValue(1,5)
			if len(self.current[v1])+len(av) < 240:
				self.current[v1] += av
				return '{0} = {0} + "{1}"'.format(v1,av)

		if n == 3:
			if len(self.current[v1])+len(self.current[v2]) < 240:
				self.current[v1] += self.current[v2]
				return '{0} = {0} + {1}'.format(v1,v2)

		if n == 4:
			self.current[v1] = self.current[v2]
			return '{0} = {1}'.format(v1,v2)

		return "rem"

	def postfixCode(self,h):
		for n in self.names:
			h.write("assert {0} = \"{1}\"\n".format(n,self.current[n]))

	def getValue(self,l1,l2):
		return "".join([chr(random.randint(65,85)) for c in range(0,random.randint(l1,l2))])

if __name__ == "__main__":		
	t = StringTest(800)
