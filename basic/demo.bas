mode 3
sprite true:sprite clear
vload "data.vram"
x = 200:y = 180
sprite 1 image 2 to 100,40 
sprite 2 image 2 to x,y

sound at 1200 for 10
line ink 2 from 0,0 to 100,100 to 150,50
draw text "Hello" to 30,30 dim 3 to 50,50
a$ = get$()