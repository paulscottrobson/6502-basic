for i = &9f25 to &9f3A
print str$(i,16),str$(peek(i),16)
next i
mode &20006000
a$ = get$()
end




