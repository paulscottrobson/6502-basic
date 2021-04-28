'
'	"A PET Game I remember from 40 years ago. The idea is to collect"
'	"the numbers on the grid over 60 seconds, planning a route to "
'	"maximise the total."
'
'	"This was written as the first test a month ago and has been slightly"
'	"upgraded, adding joystick control, mode 1 and redefining the character "
'	"set and adding a simple sound effect."
'
'	"Obviously you wouldn't do it this way .... unless you hadn't implemented"
'	"Sprite functionality etc. at the time :)"
'
mode 1:cls
xSize = 38:ySize = 27
proc frame()
dim xc(9),yc(9)
for i = 1 to 9:proc setup(i):next i
xPlayer = xSize/2:yPlayer = ySize/2
image 42,60,66,129,129+36,129,129+60,66,60
proc draw(xPlayer,yPlayer,"*",7)
score = 0:proc draw.score(s+10)
clock = 0:clockEvent = 0:proc draw.clock(clock)
moveEvent = 0
while clock < 60
	if event(clockEvent,60)
		clock = clock+1:proc draw.clock(clock)
	endif
	if event(moveEvent,8)
		if joy.x() < 0 and xPlayer > 0 then proc move(-1,0)
		if joy.x() > 0 and xPlayer < xSize-1 then proc move(1,0)
		if joy.y() < 0 and yPlayer > 0 then proc move(0,-1)
		if joy.y() > 0 and yPlayer < ySize-1 then proc move(0,1)
	endif
wend
end
'
'	"Set up number n"
'
defproc setup(n)
	xc(n) = random(xSize)
	yc(n) = random(ySize)
	proc draw(xc(n),yc(n),chr$(n+48),n mod 6+1)
endproc
'
'	"Draw character. In Mode2 could use PAINT for this."
'
defproc draw(x,y,c$,c)
	locate x+1,y+2:ink c:print c$;
endproc
'
'	"Draw surrounding frame"
'
defproc frame()
local x,y,a$:ink 3:paper 1:a$ = chr$(127)
image 127,255,64,64,64,255,4,4,4
for x = 0 to xSize+1
	locate x,1:print a$;
	locate x,ySize+2:print a$;
next x
for y = 1 to ySize+2
	locate 0,y:print a$;
	locate xSize+1,y:print a$;
next:paper 0
endproc
'
'	"Update the score"
'
defproc draw.score(s)
locate 2,0:ink 7:print right$("0000"+str$(s),5)
endproc
'
'	"Update the clock"
'
defproc draw.clock(c)
local a$:a$ = str$(c)
locate xSize-len(a$),0:ink 7:print a$
endproc
'
'	"Move the player"
'
defproc move(xi,yi)
local i
proc draw(xPlayer,yPlayer," ",7)
xPlayer = xPlayer+xi:yPlayer = yPlayer+yi
proc draw(xPlayer,yPlayer,"*",7)
for i = 1 to 9
	if xPlayer = xc(i) and yPlayer = yc(i)
		score = score + i
		proc draw.score(score)
		proc setup(i)
		sound to 0 at 1000 time 2
		sound to 0 at 2000 time 2
		sound to 0 at 4000 time 2
	endif
next i
endproc
