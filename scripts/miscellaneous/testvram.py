#
#		Produce test RAM file.
#
def add(data,text,x,y,colour):
	pos = x * 64 + y * 256
	assert (pos & 63) == 0
	pos = pos >> 6
	data.append(pos >> 8) 					# position
	data.append(pos & 0xFF)
	data.append(128+len(text)*2)			# block of len(text)x2 characters/attributes
	for c in text:
		data.append(ord(c))
		data.append(colour)

fileData = [0xAA,0xAA,0,0,0x08]				# dummy, at 0,0, comrpession 0
#add(fileData,"Hemmo world!",1,0,4)
#add(fileData,"Hexxo world!",2,2,5)
#add(fileData,"Heyyo world!",0,3,6)

fileData.append(0xFF)						# 127 bytes of data
print(len(fileData))
for i in range(0,127):
	fileData.append(0x22 if i%8 == 4 else 0x33)


fileData.append(0x80)



h = open("test.vram","wb")
h.write(bytes(fileData))
h.close()
