mode 1
sprite true:sprite clear
vload "data.vram"

repeat
cls
a = sys(&FF50)
for i = 0 to 5:print i,peek(i+2),clock(i):next i
until 0

x = 200:y = 180

sprite 1 image 2 to 100,40 
sprite 2 image 2 to x,y

print sprite.x(2)
event1 = 0
while hit(1,2) = 0
	if event(event1,2)
		y = y + joy.y():x = x + joy.x()
		sprite 2 to x,y
	endif
wend

a$ = get$()
end




