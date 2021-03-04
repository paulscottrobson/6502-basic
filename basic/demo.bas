a1 = -99
x = -2
c1$ = "SAVEME"
print "START",a1,c1$,x
proc demo(42,&12345678,"INDEMO!!")
print "END",a1,c1$,x
repeat:until False

defproc demo(a1,x,c1$)
c1$ = c1$ + "!!!!"
print "DEMO",a1,ca1$,"$";str$(x,16),"$"str$(@c1$,16)
repeat:until false
endproc

defproc xo2()
print "XO2"
endproc

; check that c1$ when returned has used @c1$