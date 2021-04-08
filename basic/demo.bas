sound at 1181 for 10 type 0
sound at 1181/2 for 10 type 0
repeat
cls:for i = 0 to 15:print playing(i):next i
print playing()
until inkey$ <> ""
end
psg = &1F9C0
vdoke psg,1181
vpoke psg+2,&C0+63
vpoke psg+3,&00+63
a$ = get$():vpoke psg+2,0+63:end

;volume nnn
;sound channel,pitch,duration[,type]