# *****************************************************************************
# *****************************************************************************
#
#		Name:		encoder.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th March 2021
#		Purpose:	Encode graphics
#
# *****************************************************************************
# *****************************************************************************

from palette import *
from PIL import Image

# *****************************************************************************
#
#					Encode graphics object worker
#
# *****************************************************************************

class ImageEncoder(object):
	def __init__(self):
		pass
	#
	#		Encode one image.
	#
	def encode(self,image,palette,is4Bit,reqWidth,reqHeight):
		image = image.convert("RGBA")
		#
		#		Does it need resizing ?
		#
		if image.width != reqWidth or image.height != reqHeight:
			image = self.resizeImage(image,reqWidth,reqHeight)
		#
		#		Scan & find nearest.
		#			
		data = []
		for y in range(0,reqHeight):
			for x in range(0,reqWidth):
				pixel = image.getpixel((x,y))
				if pixel[3] > 64:
					data.append(self.findBest(palette,is4Bit,pixel))
				else:
					data.append(0xF0 if is4Bit else 0x00)
		#
		#		Display (optional)
		#
		if False:
			for y in range(0,reqHeight):
				p = y * reqWidth
				print("".join(["${0:02x}".format(c) for c in data[p:p+reqWidth]]))
		#
		#		Crunch if 4 bit
		#
		if is4Bit:
			data = self.crunch(data)
		return data
	#
	#		Crunch 8 bit to 4 bit.
	#
	def crunch(self,inp):
		output = []
		while len(inp) != 0:
			assert inp[0] >= 0xF0 and inp[0] <= 0xFF
			assert inp[1] >= 0xF0 and inp[1] <= 0xFF
			output.append(((inp[0] & 0xF) << 4) + (inp[1] & 0xF))
			inp = inp[2:]
		return output
	#
	#		Find best pixel for given rgb value (0-255 range)
	#
	def findBest(self,palette,is4Bit,pixel):
		r = palette.byteToNibble(pixel[0])
		g = palette.byteToNibble(pixel[1])
		b = palette.byteToNibble(pixel[2])
		bestScore = None
		bestPixel = None
		for pix in range(241 if is4Bit else 1,256):
			test = palette.get(pix)
			rt = (test >> 8) & 0xF
			gt = (test >> 4) & 0xF
			bt = (test >> 0) & 0xF
			diff = (r-rt)*(r-rt)+(b-bt)*(b-bt)+(g-gt)*(g-gt)
			if bestScore is None or diff < bestScore:
				bestScore = diff
				bestPixel = pix
		assert bestPixel is not None
		return bestPixel
	#
	#		Resize image maintaining aspect ratio
	#
	def resizeImage(self,img,w,h):
		ws = w / img.width 									# Scales to fit in space
		hs = h / img.height 
		scale = min(ws,hs) 									# Scale to use is the smaller.
		xScaled = int(img.width*scale+0.5)					# Work out scaled size.
		yScaled = int(img.height*scale+0.5)		
		img = img.resize((xScaled,yScaled),resample = Image.BILINEAR)					# Resize. Now fits in at least one axis
		if img.width != w or img.height != h:
			newImage = Image.new("RGBA",(w,h),0)			# Centre on new image.
			newImage.paste(img,(int(w/2-img.width/2),int(h/2-img.height/2)))
			img = newImage
		return img

if __name__ == "__main__":
	palette = Palette()
	palette.setSpritePalette()
	#
	image = Image.open("mario.png")
	#
	encoder = ImageEncoder()
	enc = encoder.encode(image,palette,False,32,32)

