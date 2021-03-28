mode &25006000
sprite true:sprite clear
vload "data.vram"

sprite 1 image 1
sprite 2 image 1 flip 1

for i = 1 to 200
	sprite 1 to 40+i*2,i+20
	sprite 2 to 40,i+20
	t1 = timer()
	repeat until timer() > t1
next i
end




