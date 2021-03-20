# *****************************************************************************
# *****************************************************************************
#
#		Name:		testarr2.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		7th March 2021
#		Purpose:	Test arrays(multi dimension)
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *

class ArrayTest(Test):

	def prefixCode(self,h):
		self.current = {}
		self.firstDim = {}
		self.access = {}
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
				self.firstDim[name] = random.randint(1,4)
				self.access[name] = random.randint(0,self.firstDim[name])
				h.write("dim {0}{2},{1})\n".format(name,size,self.firstDim[name]))
		self.names = [x for x in self.current.keys()]

	def getTest(self,n):
		var = self.names[random.randint(0,len(self.names)-1)]		
		index = random.randint(0,len(self.current[var])-1)
		value = str(random.randint(0,999))
		if var.find("$") >= 0:
			value = '"'+"".join([chr(random.randint(65,85)) for s in range(0,random.randint(0,7))])+'"'
		self.current[var][index] = value
		return "{0}{3},{2}) = {1}".format(var,value,index,self.access[var])

	def postfixCode(self,h):
		for n in self.names:
			for i in range(0,len(self.current[n])):
				if self.current[n][i] is not None:
					h.write("assert {0}{3},{2}) = {1}\n".format(n,self.current[n][i],i,self.access[n]))

if __name__ == "__main__":		
	t = ArrayTest(5)
