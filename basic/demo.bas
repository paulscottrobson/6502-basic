mode 3
plot ink 1 to 100,100
rect ink 2 from 10,20 to 90,140
frame ink 3 from 20,30 to 80,130
line from 0,0 to 319,199
t1 = timer()
for i = 1 to 1000
	line ink random(256) from random(320),random(200) to random(320),random(200)
next i:print timer()-t1
