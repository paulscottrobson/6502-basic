# *****************************************************************************
# *****************************************************************************
#
#		Name:		vramc.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		28th March 2021
#		Purpose:	VRamCompiler
#
# *****************************************************************************
# *****************************************************************************

from palette import *
from data import *
from encoder import *
from vramfile import *
from PIL import Image

# *****************************************************************************
#
#							Specialist assertion
#
# *****************************************************************************

class VRAMAssertion(Exception):
	pass

# *****************************************************************************
#
#							VRAM Compiler worker
#
# *****************************************************************************

class VRamCompiler(object):
	def __init__(self):
		self.target = VRAMFile()
		self.palette = Palette()
		self.encoder = ImageEncoder()
		#
		self.spriteID = 0
		self.width = 16
		self.height = 16
		self.bits = 4
		self.sheet = None
		#
		self.legalSizes = { 8:0,16:1,32:2,64:3 }
	#
	#		Load one file
	#
	def load(self,dir):
		src = open(dir+os.sep+"vram.txt").readlines()
		src = [x.strip().lower().replace("\t"," ") for x in src if x.strip() != "" and not x.startswith(";")]
		for s in src:
			s = s.replace("color","colour")
			#
			if s.startswith("move"):
				addr = self.evaluate(s[4:])
				if addr % 64 != 0:
					raise VRAMAssertion("Move addresses must be multiples of 64")
				addr = addr >> 6
				self.target.append([addr >> 8,addr & 0xFF])
			#
			elif s.startswith("colour"):
				if s.endswith("sprite"):
					self.palette.setSpritePalette()
				else:
					m = re.match("^colour\\s+(.*)\\,(.*)$",s)
					if m is None:
						raise VRAMAssertion("Colour syntax error")
					self.palette.set(self.evaluate(m.group(1)),self.evaluate(m.group(2)))
			#
			elif s.startswith("bits"):
				n = self.evaluate(s[4:])
				if n != 1 and n != 2 and n != 4 and n != 8:
					raise VRAMAssertion("Bad bit depth")
				self.bits = n
			#
			elif s.startswith("sprite"):
				m = re.match("^sprite\\s+(.*)\\,(.*)\\,(.*)$",s)
				if m is None:
					raise VRAMAssertion("Sprite syntax error")
				self.spriteID = self.evaluate(m.group(1))
				self.width = self.evaluate(m.group(2))
				self.height = self.evaluate(m.group(3))
				if self.width not in self.legalSizes or self.height not in self.legalSizes:
					raise VRAMAssertion("Bad sprite size")
			#
			elif s.startswith("image"):
				self.markSpritePosition()
				image = Image.open(dir+os.sep+s[5:].strip())
				self.addImage(image)
			#
			elif s.startswith("sheet"):
				self.sheet = s[5:].strip().split(",")
				if len(self.sheet) != 7:
					raise VRAMAssertion("Bad sheet")
				self.sheet[0] = Image.open(dir+os.sep+self.sheet[0])
				for i in range(1,7):
					self.sheet[i] = self.evaluate(self.sheet[i])
			#
			elif s.startswith("import"):
				grid = s[6:].strip().split(",")
				if len(grid) != 4:
					raise VRAMAssertion("Bad sheet")
				for i in range(0,4):
					grid[i] = self.evaluate(grid[i])
				if self.sheet is None:
					raise "No sheet selected to import"
				for y in range(0,grid[3]):
					for x in range(0,grid[2]):
						xs = self.sheet[1] + self.sheet[3]*x
						ys = self.sheet[2] + self.sheet[4]*y
						image = self.sheet[0].crop((xs,ys,xs+self.sheet[5],ys+self.sheet[6]))
						self.markSpritePosition()
						self.addImage(image)						
			#
			else:
				raise VRAMAssertion("Unknown command "+s)
	#
	#		Mark sprite position
	#
	def markSpritePosition(self):
		ctrl = 0x30 if self.bits == 8 else 0x20
		ctrl += self.legalSizes[self.height] * 4
		ctrl += self.legalSizes[self.width] 
		self.target.append([ctrl,self.spriteID])
		self.spriteID += 1
	#
	#		Add image
	#
	def addImage(self,image):
		imgData = self.encoder.encode(image,self.palette,self.bits == 4,self.width,self.height)
		do = DataObject()
		do.append(imgData)
		self.target.append(do.render())
	#
	#		Write file out.
	#
	def write(self,targetFile = None):
		self.target.append(self.palette.render())
		self.target.append([0X80])
		self.target.write(targetFile)
	#
	#		Evaluation
	#
	def evaluate(self,e):
		e = e.strip().lower()
		if re.match("^\\$[(0-9a-f)]+$",e) is not None:
			return int(e[1:],16)
		if re.match("^\\d+$",e) is not None:
			return int(e)
		raise VRAMAssertion("Bad constant")

if __name__ == "__main__":
	vc = VRamCompiler()
	vc.load("vram")
	vc.write()
	