# *****************************************************************************
# *****************************************************************************
#
#		Name:		tester.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th March 2021
#		Purpose:	Tester for vramc units
#
# *****************************************************************************
# *****************************************************************************

from palette import *
from data import *
from encoder import *
from PIL import Image

do8Bit = False

palette = Palette()
palette.setSpritePalette()

result = [1,0]									# position to 256*64 = 1024*16

result += [0x3F if do8Bit else 0x2F,0x01] 		# define sprite 32x32 #1 4/8 bit colour.

image = Image.open("vram/mario.png")
enc = ImageEncoder()
imgData = enc.encode(image,palette,not do8Bit,64,64)

do = DataObject()
do.append(imgData)
oData = do.render()
result += oData
result += palette.render()
result += [0X80]

h = open("test.vram","wb")
h.write(bytes([0xFF,0xFF]))
h.write(bytes(result))
h.close()

print("File Size ",len(result)+2)