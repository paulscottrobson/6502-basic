mode &35006007 
rect ink 2 from 10,10 to 100,100
a$ = get$():end

psg = &1F9C0
vdoke psg,1181
vpoke psg+2,&C0+63
vpoke psg+3,&00+63
a$ = get$():vpoke psg+2,0+63:end

;volume nnn
;sound channel,pitch,duration[,type]