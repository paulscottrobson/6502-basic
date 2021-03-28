mode &25006000
sprite true:sprite clear
vload "data.vram"

s = 16
sprite 1 image s
sprite 2 image s

for i = 16 to 48:
	sprite i image i to i mod 8 * 32+16,i/8*32
next i

for i = 1 to 200
	sprite 1 to 40+i*2,i+20
	sprite 2 to 40,40
	t1 = timer()
	repeat until timer() > t1
next i
a$ = get$()
end




