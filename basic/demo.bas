mode &60006000
vload "test.vram"
s = &1FC00
vdoke s,3
vdoke s+4,100
vdoke s+2,240
vpoke s+6,12
vpoke s+7,&50
a$ = get$()
end




