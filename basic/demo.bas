mode 3:sprite true:sprite clear:clg paper 0
vload "data.vram"
for i = 1 to 7
draw text "test" ink 240+i paper 0 dim 7 at 12+i,13+i
next i
a$  = get$():end

