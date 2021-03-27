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
	#		Render
	#
	def render(self):
		if self.currentCompression == 0:
			return self.renderCompression0()
		assert False
		
if __name__ == "__main__":
	d = DataObject()
	d.append([32,45,99,116])	
	print(d.render())