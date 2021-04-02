mode 3:t1 = timer()
for i = 1 to 1000
	line ink random(256) from random(320),random(200) to random(320),random(200)
next i:print timer()-t1
