'
'	"A Pong game based on the AY-3-8500"
'
mode 3
boardWidth = 50:rem "Size of boards back of football "
gameType = 1: rem "0 tennis,1 soccer, 2 squash, 3 practice"
proc Setup()
proc DrawFrame(gameType)
a$ = get$()
end
'
'		"Draw the initial layout for the game dependent on type"
'
defproc DrawFrame(t)
	local w = 1,x,i
	paper 0:cls:sprite clear:sprite true
	for x = 0 to 319 step 8
		rect from x,0 to x+5,w:rect from x,199-w to x+5,199
	next x
	if gameType < 2 then rect from 160-w/2,0 to 160-w/2+w,199
	if gameType >= 2 then rect from 0,0 to w,199
	if gameType = 1 
		for i = 0 to 1
			x = (319-w)*i
			rect from x,0 to x+w,boardWidth
			rect from x,199 to x+w,199-boardWidth
		next i
	endif
endproc
'
'		"Draw a score 0-15"
'
defproc DrawScore(x,s)
	local y = 10
	local n = -1:if s >= 10 then n = 10
	proc DrawDigit(x,y,n)
	proc DrawDigit(x+8,y,s mod 10)
endproc
'
'		"Draw a digit"
'
defproc DrawDigit(x,y,n)
	local sx = 12,sy = 10,w = 3,bits
	rect ink 0 from x,y to x+sx,y+sy*2 ink 1
	if n >= 0
		bits = patterns(n)
		if (bits and &1) then rect x,y to x+w,y+sy
		if (bits and &2) then rect x,y to x+sx,y+w
		if (bits and &4) then rect x+sx-w,y to x+sx,y+sy
		if (bits and &8) then rect x+sx-w,y+sy to x+sx,y+sy*2
		if (bits and &10) then rect x,y+sy*2 to x+sx,y+sy*2-w
		if (bits and &20) then rect x,y+sy to x+w,y+sy*2
		if (bits and &40) then rect x,y+sy-w/2 to x+sx,y+sy+w-w/2
	endif
endproc
'
'		"Set up"
'
defproc Setup()
	dim patterns(10),score(2),py(2),sx(2)
	patterns(0) = &3F
	patterns(1) = &0C
	patterns(2) = &76
	patterns(3) = &5E
	patterns(4) = &4D
	patterns(5) = &5B
	patterns(6) = &7B
	patterns(7) = &0E
	patterns(8) = &FF
	patterns(9) = &5F
	patterns(10) = &21
	score(1) = 3:score(2) = 15
	sx(1) = 134:sx(2) = 167
	proc DrawScore(sx(1),score(1))
	proc DrawScore(sx(2),score(2))
endproc