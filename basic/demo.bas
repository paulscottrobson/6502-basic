a1 = -99
x = -1
c1$ = "SAVEME"
print "START",a1,c1$,x
proc demo(42,&12345678)
print "END",a1,c1$,x
repeat:until False

defproc demo(a1,x)
print "RUNNING DEMO",a1,c1$,"$";str$(x,16)
repeat:until false
endproc

defproc xo2()
print "XO2"
endproc