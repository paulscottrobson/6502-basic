# *****************************************************************************
# *****************************************************************************
#
#		Name:		testarr.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		7th March 2021
#		Purpose:	Test assignment and variables.
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

class AssignTest(Test):

	def prefixCode(self,h):
		self.current = {}
		for i in range(1,20):
			name = "".join([chr(random.randint(97,117)) for c in range(0,random.randint(1,5))])
			if len(name) > 1:
				name = name[0]+"0"+name[1:]
			if i % 2 == 0:
				name = name + "$"
			name += "("
			size = random.randint(1,9)			
			if name not in self.current:
				self.current[name] = [ None ] * size
				h.write("dim {0}{1})\n".format(name,size))
		self.names = [x for x in self.current.keys()]

	def getTest(self,n):
		var = self.names[random.randint(0,len(self.names)-1)]		
		index = random.randint(0,len(self.current[var])-1)
		value = str(random.randint(0,999))
		if var.find("$") >= 0:
			value = '"'+"".join([chr(random.randint(65,85)) for s in range(0,random.randint(0,7))])+'"'
		self.current[var][index] = value
		return "{0}{2}) = {1}".format(var,value,index)

	def postfixCode(self,h):
		for n in self.names:
			for i in range(0,len(self.current[n])):
				if self.current[n][i] is not None:
					h.write("assert {0}{2}) = {1}\n".format(n,self.current[n][i],i))

if __name__ == "__main__":		
	t = AssignTest(500)
