mode 3
x = 160:y = 100:xi = 32:yi = 64

line ink 1 from x,y to x+xi,y+yi
line ink 2 from x,y to x-xi,y-yi
line ink 3 from x,y to x+xi,y-yi
line ink 4 from x,y to x-xi,y+yi
a$ = get$()
