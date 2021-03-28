# *****************************************************************************
# *****************************************************************************
#
#		Name:		vramfile.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		28th March 2021
#		Purpose:	Build VRAM file allowing for chunking if required
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#								VRAMFile class
#
# *****************************************************************************

class VRAMFile(object):
	def __init__(self):
		self.data = [ ]
	#
	def append(self,byteData):
		self.data += byteData
	#
	def chunk(self):
		pass
	#
	def write(self,fileName = None):
		fileName = "data.vram" if fileName is None else fileName
		h = open(fileName,"wb")
		h.write(bytes([0xFF,0xFF]))
		h.write(bytes(self.data))
		h.close()

