mode &60006000
vload "test.vram"
s = &1FC00
sprite clear
vdoke s,3
vdoke s+4,100
vdoke s+2,240
vpoke s+6,12
vpoke s+7,&50
print vpeek(s+6),vdeek(s+6)
a$ = get$()

end




