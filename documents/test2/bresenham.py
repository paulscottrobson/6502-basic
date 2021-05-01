# *****************************************************************************
# *****************************************************************************
#
#		Name:		bresenham.py
#		Purpose:	Bresenham type Line Algorithm test
#		Created:	1st April 2021
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# *****************************************************************************
# *****************************************************************************

import random

# *****************************************************************************
#
#								A simple display class
#
# *****************************************************************************

class Display(object):
	def __init__(self,width=48,height=32):
		self.width = width
		self.height = height
		self.display = []
		for i in range(0,self.height):
			self.display.append(["."] * self.width)
	#
	def plot(self,x,y,c):
		self.display[y][x] = c[0]
	#
	def show(self):
		s = "\n".join(["".join(self.display[x]) for x in range(0,self.height)])
		print(s)
	#
	def draw(self,x1,y1,x2,y2,c = "*"):
		assert x1 <= x2 and y1 <= y2 			# only down and left. Sort on Y ; if x1 > x2 then subtract 1.
		dx = x2-x1
		dy = y1-y2
		err = dx + dy
		while x1 != x2 or y1 != y2:
			self.plot(x1,y1,c)
			e2 = 2 * err
			if e2 >= dy:
				err += dy
				x1 += 1
			if dx >= e2:
				err += dx
				y1 += 1
		self.plot(x1,y1,c)	

d = Display()
d.draw(2,2,46,12,"A")
d.draw(2,2,16,30,"B")
d.draw(2,2,46,2,"C")
d.draw(2,2,2,30,"D")
d.plot(2,2,"*")
d.show()			

