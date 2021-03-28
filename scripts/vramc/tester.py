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
from vramfile import *
from PIL import Image

do8Bit = False

target = VRAMFile()

palette = Palette()
palette.setSpritePalette()

target.append([1,0])									# position to 256*64 = 1024*16

target.append([0x3A if do8Bit else 0x2A,0x03]) 			# define sprite 32x32 #1 4/8 bit colour.

image = Image.open("vram/mario.png")
enc = ImageEncoder()
imgData = enc.encode(image,palette,not do8Bit,32,32)

do = DataObject()
do.append(imgData)
target.append(do.render())
target.append(palette.render())
target.append([0X80])
target.write()
print("File Size:",len(target.data)+2)