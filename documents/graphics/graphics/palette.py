# *******************************************************************************************
# *******************************************************************************************
#
#       File:           palette.py
#       Date:           20th November 2020
#       Purpose:        Standard 16 colour palette not designed for NTSC televisions
#       Author:         Paul Robson (paul@robson.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re
#
#       Convert a palette value into 4 bit.
#
def pv(n):
    return int((n+7.5)*15/255.0)
#
#       Convert RGB: n,n,n into 4 bit tuple.
#
def process(p):
    m = re.match("^RGB\\:\\s*(\\d+)\\,\\s*(\\d+)\\,\\s*(\\d+)\\s*$",p)
    assert m is not None,p
    return [int(x) for x in m.groups()]
#
#       Raw RGB colour data for my palette.
#
rawData = """
Black/Transparent.
   RGB: 0, 0, 0 
Red
    RGB: 255,0,0
Green
    RGB: 0,255,0
Yellow
    RGB: 255, 255,0
Blue
    RGB: 0,0,255
Purple
    RGB: 255,0,255
Cyan
    RGB: 0,255,255
White
    RGB: 255, 255, 255 

Black
   RGB: 0, 0, 0 
Dk. Gray
    RGB: 87, 87, 87 
Lt. Gray
    RGB: 160, 160, 160 
Orange
    RGB: 255, 128, 0
Brown
    RGB: 150, 70, 20
Lt. Green
    RGB: 128, 255, 0
Lt. Blue
    RGB: 0,128,255
Pink
    RGB: 255, 205, 243 
"""

p = [x.strip() for x in rawData.split("\n") if x.find("RGB") >= 0]
assert len(p) == 16
p = [process(x) for x in p]
#
#       Python format.
#
h = open("palette.txt","w")
h.write("#\n#\tPython format\n#\t\n{0}\n\n".format(str(p)))
h.close()
#
#       Four bit format.
#
p = [ [pv(x[0]),pv(x[1]),pv(x[2])] for x in p]
p = [ x[1]*4096+x[2]*256+x[0] for x in p]
p = ["{0:04x}".format(x) for x in p]
h = open("palette.amo","w")
h.write("code proc default.palette() {\n")
h.write("\t[[\"{0}\"]]\n}}\n".format(" ".join(p)))
h.close()

