mode 3
sprite true:sprite clear
line ink 4 from 100,0 to 200,100
rect ink 241 from 100,20 to 200,80
frame ink 247 from 100,20 to 200,80
vload "data.vram"
for x = 0 to 255
for y = 180 to 182
plot ink x to x,y
next:next
x = 200:y = 180
sprite 1 image 2 to 100,40 
sprite 2 image 2 to x,y
paint image 2 to 10,10 image 2 to 0,0
sound at 1200 for 10
image 64,255,129,129,129,241,129,129,255
line ink 2 from 0,0 to 100,100 to 150,50
draw ink 1 paper 2 text "@Hello" to 30,30 dim 3 to 50,50 
a$ = get$()