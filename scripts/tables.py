# *****************************************************************************
# *****************************************************************************
#
#		Name:		tables.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Generate various tables
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import os,re,sys
header= ";\n;\tAutomatically generated\n;\n"							# header used.
genDir = "../source/generated/".replace("/",os.sep)					
#
t= Tokens()
#
#		Output constants. 
#
h = open(genDir+"tokenconst.inc","w")
h.write(header)
h.write("TOK_EOL=${0:x}\n".format(t.getEOLToken()))
h.write("TOK_SHIFT1=${0:x}\n".format(t.getShiftToken(1)))
h.write("TOK_SHIFT2=${0:x}\n".format(t.getShiftToken(2)))
h.write("TOK_SHIFT3=${0:x}\n".format(t.getShiftToken(3)))
h.write("TOK_FPC=${0:x}\n".format(t.getFPMarkerToken()))
h.write("TOK_STR=${0:x}\n".format(t.getStringMarkerToken()))
h.write("TOK_BINARYST=${0:x}\n".format(t.getBinaryStart()))
h.write("TOK_STRUCTST=${0:x}\n".format(t.getStructModStart()))
h.write("TOK_UNARYST=${0:x}\n".format(t.getUnaryStart()))
h.write("TOK_TOKENS=${0:x}\n".format(t.getStandardStart()))
h.write("\n")

allTokens = t.getAllTokens()
keys = [x for x in allTokens.keys()]
keys.sort()
for k in keys:
	s = allTokens[k]["token"]
	if not s.startswith("[["):
		s2 = s.replace("+","PLUS").replace("-","MINUS").replace("*","STAR").replace("/","SLASH")
		s2 = s2.replace("(","LPAREN").replace(")","RPAREN").replace("[","LSQPAREN").replace("]","RSQPAREN")
		s2 = s2.replace(">","GREATER").replace("=","EQUAL").replace("<","LESS").replace("@","AT")
		s2 = s2.replace("!","PLING").replace("?","QMARK").replace("~","WAVY").replace("$","DOLLAR")
		s2 = s2.replace("^","HAT").replace("#","HASH").replace("%","PERCENT").replace("&","AMP")
		s2 = s2.replace(":","COLON").replace(";","SEMICOLON").replace(",","COMMA").replace("'","QUOTE")
		#s2 = s2.replace("","").replace("","").replace("","").replace("","")
		assert re.match("^([A-Z]+)$",s2) is not None,"Fail on "+s2
		h.write("TKW_{0:24} = ${1:02x} ; {2}\n".format(s2,allTokens[k]["id"],s.lower()))
h.close()
#
handlers = {}
#
#		Output the vector tables. Build the lists of tokens as well.
#
tokenText = [ [],[],[],[] ]
for group in range(0,4):
	done = False
	n = t.getBinaryStart() if group > 0 else t.getEOLToken()
	h = open(genDir+"tokenvectors"+str(group)+".inc","w")
	h.write(header)
	h.write("Group{0}Vectors:\n".format(group))
	while not done:
		token = t.getFromID(group,n)
		done = token is None
		if not done:
			tt = token["token"]
			if not tt.startswith("[["):
				tokenText[group].append(tt)
			handler = handlers[tt] if tt in handlers else "Unimplemented"
			h.write("\t.word\t{0:16} ; ${1:02x} {2}\n".format(handler,token["id"],tt.lower()))
		n += 1
#
#		Output the information table for group 0 - gives structure shifts and binary precedence.
#
h = open(genDir+"binarystructinfo.inc","w")
h.write(header)
h.write("BinaryStructTable:\n")
for tid in range(t.getBinaryStart(),t.getUnaryStart()):
	token = t.getFromID(0,tid)
	h.write("\t.byte\t${0:02x}\t\t\t; ${1:02x} {2}\n".format(token["type"],tid,token["token"].lower()))
h.close()
#
#		Output text entry lists.
#
for group in range(0,4):
	h = open(genDir+"tokentext"+str(group)+".inc","w")
	h.write(header)
	h.write("Group{0}Text:\n".format(group))
	n = t.getBinaryStart()
	for token in tokenText[group]:
		t1 = token
		if t1.endswith("$("):
			t1 = t1[:-2] + chr(0x3D)
		elif t1.endswith("("):
			t1 = t1[:-1] + chr(0x3B)
		bList = [ord(c.upper()) & 0x3F for c in t1]
		bList.insert(0,len(bList))
		bList = ",".join(["${0:02x}".format(c) for c in bList])
		h.write("\t.byte {0:32} ; ${1:02x} {2}\n".format(bList,n,token.lower()))
	h.write("\t.byte $00\n\n")