mode 1
sprite true:sprite clear
vload "data.vram"

x = 200:y = 180

sprite 1 image 2 to 100,40 
sprite 2 image 2 to x,y

print sprite.x(2)
event1 = 0
while hit(1,2) = 0
	y = y - 1:x = x - 1
	sprite 2 to x,y
wend

a$ = get$()
end




