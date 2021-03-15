# *****************************************************************************
# *****************************************************************************
#
#		Name:		asmtables.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		13th March 2021
#		Purpose:	Generate various tables (assembler specific)
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import os,re,sys

t = Tokens()
header= ";\n;\tAutomatically generated\n;\n"							# header used.
genDir = "../source/generated/".replace("/",os.sep)	
#
groupStart = [ 0 ] * 6
n = t.getBaseAsmToken()
while t.getFromID(1,n) is not None:
	info = t.getAsmInfo(t.getFromID(1,n)["token"])
	lvl = int(info[2])
	if groupStart[lvl] == 0:
		groupStart[lvl] = n
	n = n + 1				
groupStart[5] = n
#
#		Create the constants table.
#
h = open(genDir+"asmconst.inc","w")
h.write(header)
for i in range(1,5):
	h.write("TKA_GROUP{0} = ${1:02x}\n".format(i,groupStart[i]))
h.write("TKA_END4 = ${0:02x}\n\n".format(groupStart[5]	))
h.close()
#
#		Create the data tables for assembler.
#
h = open(genDir+"asmtables.inc","w")
h.write(header)
#
#		Token ID to Opcode
#
h.write("OpcodeTable:\n")
for i in range(groupStart[1],groupStart[5]):
	m = t.getFromID(1,i)
	opcode = int(t.getAsmInfo(m["token"])[0],16)
	h.write("\t.byte\t${0:02x}\t\t\t; ${1:02x} {2}\n".format(opcode,i,m["token"].lower()))
h.write("\n")
#
#		Group 2 Usage
#
h.write("Group2OpcodeAvailability:\n")
for i in range(groupStart[2],groupStart[3]):
	m = t.getFromID(1,i)
	info = t.getAsmInfo(m["token"])
	opcode = int(info[0],16)
	bitMask = 0
	for b in range(0,8):
		if info[b+3] != "":
			bitMask += (1 << b)
	h.write("\t.byte\t${0:02x}\t\t\t; ${1:02x} {2} ${3:02x}\n".format(bitMask,i,m["token"].lower(),opcode))
h.write("\n")
#
#		Special cases (token,mode,opcode), ends with token 0
#
h.write("AssemblerSpecialCases:\n")
for c in t.getAsmSpecialCases():
	token = t.getFromToken(c[1])
	h.write("\t.byte\t${1:02x},{2},${0:02x}\t\t; {3} {4}\n".format(int(c[0],16),token["id"],c[3],c[1],c[4]))
h.write("\t.byte\t0\n")
h.close()
