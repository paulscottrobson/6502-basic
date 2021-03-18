dim test(2,3),test$(2,3),a(400),triple(2,2,2)
a(399) = 444:a(0) = -1
test(2,3) = 12:test(1,1) = 11:test(1,3) = 100
test$(0,0)="00"
test$(2,1)="21"
triple(0,1,2) = 42
print "(";triple(0,1,2);")"
print a(399)
end
