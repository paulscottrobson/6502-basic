mode &60006000
vload "test.vram"
s = &1FC08
sprite clear
vdoke s,0
vdoke s+4,100
vdoke s+2,240
vpoke s+6,12
vpoke s+7,&50
print vpeek(s+6),vdeek(s+6)
for i = 1 to 100
	t1 = timer()+30
	repeat until timer() > t1
	if i mod 2 = 0: sprite 1 true:else:sprite 1 false:endif
next i
end




