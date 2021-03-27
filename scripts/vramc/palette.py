# *****************************************************************************
# *****************************************************************************
#
#		Name:		palette.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th March 2021
#		Purpose:	Palette/General classes
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

# *****************************************************************************
#
#								Base class
#
# *****************************************************************************

class VRAMBase:
	def render(self):
		assert False

# *****************************************************************************
#
#								Palette class
#
# *****************************************************************************

class Palette(VRAMBase):
	def __init__(self):
		#
		#		Initialise to default X16-Palette (copied from Vera documentation)
		#
		defPalette = """
			000,fff,800,afe,c4c,0c5,00a,ee7,d85,640,f77,333,777,af6,08f,bbb
			000,111,222,333,444,555,666,777,888,999,aaa,bbb,ccc,ddd,eee,fff
			211,433,644,866,a88,c99,fbb,211,422,633,844,a55,c66,f77,200,411
			611,822,a22,c33,f33,200,400,600,800,a00,c00,f00,221,443,664,886
			aa8,cc9,feb,211,432,653,874,a95,cb6,fd7,210,431,651,862,a82,ca3
			fc3,210,430,640,860,a80,c90,fb0,121,343,564,786,9a8,bc9,dfb,121
			342,463,684,8a5,9c6,bf7,120,241,461,582,6a2,8c3,9f3,120,240,360
			480,5a0,6c0,7f0,121,343,465,686,8a8,9ca,bfc,121,242,364,485,5a6
			6c8,7f9,020,141,162,283,2a4,3c5,3f6,020,041,061,082,0a2,0c3,0f3
			122,344,466,688,8aa,9cc,bff,122,244,366,488,5aa,6cc,7ff,022,144
			166,288,2aa,3cc,3ff,022,044,066,088,0aa,0cc,0ff,112,334,456,668
			88a,9ac,bcf,112,224,346,458,56a,68c,79f,002,114,126,238,24a,35c
			36f,002,014,016,028,02a,03c,03f,112,334,546,768,98a,b9c,dbf,112
			324,436,648,85a,96c,b7f,102,214,416,528,62a,83c,93f,102,204,306
			408,50a,60c,70f,212,434,646,868,a8a,c9c,fbe,211,423,635,847,a59
			c6b,f7d,201,413,615,826,a28,c3a,f3c,201,403,604,806,a08,c09,f0b
"""
		defPalette = ",".join(defPalette.split("\n"))
		self.palette = [int(x.strip(),16) for x in defPalette.strip().split(",") if x.strip() != ""]
		assert len(self.palette) == 256
		self.changed = [ False ] * 256
	#
	#		Load the standard colour palette into 240-255. This is changeable as you like as
	#		it is loaded as part of VRAM.
	#
	def setSpritePalette(self):
		sprPal = [[0, 0, 0], [255, 0, 0], [0, 255, 0], [255, 255, 0], [0, 0, 255], [255, 0, 255], 
				  [0, 255, 255], [255, 255, 255], [0, 0, 0], [87, 87, 87], [160, 160, 160], [255, 128, 0], 
				  [150, 70, 20], [128, 255, 0], [0, 128, 255], [255, 205, 243]]
		assert len(sprPal) == 16	
		for i in range(0,16):
			cvCol = [self.byteToNibble(n) for n in sprPal[i]]
			self.set(i+0xF0,(cvCol[2] << 8)+(cvCol[1] << 4)+cvCol[0])
	#
	#		Byte colour to palette colour
	#
	def byteToNibble(self,c):
		return c >> 4
	#
	#		Get palette value.
	#
	def get(self,colour):
		return self.palette[colour]
	#
	#		Change palette entry
	#
	def set(self,colour,rgb):
		self.palette[colour] = rgb
		self.changed[colour] = True
	#
	#		Render changes as byte array.
	#
	def render(self):
		code = []
		for i in range(0,256):
			if self.changed[i]:
				code += [ 0xF,i,self.palette[i] & 0xFF,self.palette[i] >> 8 ]
		return code

if __name__ == "__main__":
	p = Palette()
	p.setSpritePalette()
	print(p.render())		

