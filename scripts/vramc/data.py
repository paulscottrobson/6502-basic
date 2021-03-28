# *****************************************************************************
# *****************************************************************************
#
#		Name:		data.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th March 2021
#		Purpose:	Rendering data with possible compression.
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys
from palette import *

# *****************************************************************************
#
#									Data Object
#
# *****************************************************************************

class DataObject(VRAMBase):
	def __init__(self,compression = 0):
		self.currentCompression = compression
		self.data = []
	#
	#		Append data 
	#
	def append(self,data):
		self.data += data
	#
	#		Render data (compression 0)
	#
	def renderCompression0(self):
		r = [0x08 + self.currentCompression]
		p = 0
		while p < len(self.data):
			size = min(127,len(self.data)-p)
			r += [0x80 + size]
			r += self.data[p:p+size]
			p = p + size
		return r
	#
	#		Render data (compression 1)
	#
	def renderCompression1(self):
		r = [0x08 + self.currentCompression]
		p = 0
		while p < len(self.data):
			p2 = self.findNextGroup(self.data,p)
			if p2 == p:
				while p2 < len(self.data) and p2-p < 63 and self.data[p] == self.data[p2]:
					p2 += 1
				r += [0xC0 + p2-p, self.data[p]]
				p = p2
			else:
				size = min(63,p2-p)
				r += [0x80 + size]
				r += self.data[p:p+size]
				p = p + size
		return r
	#
	#		Find next group, returns end if none.
	#
	def findNextGroup(self,data,p):
		while p < len(data)-2 and not self.isGroup(data,p):
			if p >= len(data)-2:
				return len(data)
			p += 1
		return p
	#
	#		Group at offset p
	#
	def isGroup(self,data,p):
		return (data[p] == data[p+1]) and (data[p+1] == data[p+2])
	#
	#		Render
	#
	def render(self):
		if self.currentCompression == 0:
			return self.renderCompression0()
		if self.currentCompression == 1:
			return self.renderCompression1()
		assert False
		
if __name__ == "__main__":
	d = DataObject()
	d.append([32,45,99,116])	
	print(d.render())