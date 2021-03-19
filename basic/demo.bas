
for y = 0 to 15
palette y,random()
for x = 0 to 24
	p = x * 2 + y * 256
	vpoke p,42:vpoke p+1,y
next:next:locate 0,20
end




