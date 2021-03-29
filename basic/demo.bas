mode &25006000
sprite true:sprite clear:cls
vload "data.vram"

s = 16
sprite 1 image s
sprite 2 image 4 to -5,40 flip 1
print sprite.x(2),sprite.y(2)

for i = 16 to 47
	sprite i image i to i mod 8 * 32+16,i/8*32
next i

for i = 1 to 200
	sprite 1 to 40+i*2,i+20
	t1 = timer()
	repeat until timer() > t1
next i
a$ = get$()
end




