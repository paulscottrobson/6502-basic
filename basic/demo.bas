mode 3:sprite true:sprite clear:clg paper 0
vload "data.vram"
f = 1
sprite 2 image 2 flip f to 40,40 
sprite 3 image 3 flip 0 to 60,40 
for i = 0 to 3
paint image 2 dim 3 flip i to i*60+10,20
next i
a$  = get$():end

plot ink 1 to 100,100
rect ink 2 from 10,20 to 90,140
frame ink 3 from 20,30 to 80,130
line from 0,0 to 319,199
t1 = timer()
for i = 1 to 10
	line ink random(256) from random(320),random(200) to random(320),random(200)
next i:print timer()-t1:a$ = get$()
