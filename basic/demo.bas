mode 3
for i = 1 to 10
	x = random(320):y = random(200):xi = random(60)+1:yi = random(60)+1
	line ink 1 from x,y to x+xi,y+yi
	line ink 2 from x,y to x-xi,y-yi
	line ink 3 from x,y to x+xi,y-yi
	line ink 4 from x,y to x-xi,y+yi
next i
a$ = get$()
