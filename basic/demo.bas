mode &60006000
vload "test.vram"
sprite clear
sprite 1 image 3:sprite 2 image 2
for i = 1 to 200
	sprite 1 to 40+i*2,i+20
	sprite 2 to 0,i+20
	t1 = timer()
	repeat until timer() > t1
next i
end




