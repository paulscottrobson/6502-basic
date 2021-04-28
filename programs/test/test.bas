'
'	"A PET Game I remember from 40 years ago. The idea is to collect"
'	"the numbers on the grid over 60 seconds"
'
cls
xSize = 32:ySize = 24
proc frame()
dim xc(9),yc(9)
for i = 1 to 9:proc setup(i):next i
xPlayer = xSize/2:yPlayer = ySize/2
proc draw(xPlayer,yPlayer,"*",7)
score = 0:proc draw.score(s+10)
clock = 0:clockEvent = 0:proc draw.clock(clock)
while clock < 60
	if event(clockEvent,60)
		clock = clock+1:proc draw.clock(clock)
	endif
	c$ = upper$(chr$(inkey()))
	if c$ = "Z" and xPlayer > 0 then proc move(-1,0)
	if c$ = "X" and xPlayer < xSize-1 then proc move(1,0)
	if c$ = "K" and yPlayer > 0 then proc move(0,-1)
	if c$ = "M" and yPlayer < ySize-1 then proc move(0,1)
wend
list ,1400
end
'
defproc setup(n)
	xc(n) = random(xSize)
	yc(n) = random(ySize)
	proc draw(xc(n),yc(n),chr$(n+48),n mod 6+1)
endproc
'
defproc draw(x,y,c$,c)
	locate x+1,y+2:ink c:print c$;
endproc
'
defproc frame()
local x,y,a$:ink 6:a$ = "#"
for x = 0 to xSize+1
	locate x,1:print a$;
	locate x,ySize+2:print a$;
next x
for y = 1 to ySize+2
	locate 0,y:print a$;
	locate xSize+1,y:print a$;
next 
endproc
'
defproc draw.score(s)
locate 2,0:ink 7:print right$("0000"+str$(s),5)
endproc
'
defproc draw.clock(c)
local a$:a$ = str$(c)
locate xSize-len(a$),0:ink 7:print a$
endproc
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
	endif
next i
endproc
