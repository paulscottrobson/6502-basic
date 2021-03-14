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
h.write("TOK_EOL=${0:x}\n".format(t.getEOLToken())) 					# firstly all the positional ones
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

allTokens = t.getAllTokens() 											# get all tokens and keys in order
keys = [x for x in allTokens.keys()]
keys.sort()
for k in keys:
	s = allTokens[k]["token"]											# for every non special token
	if not s.startswith("[["):											# convert puncuation to words
		s2 = s.replace("+","PLUS").replace("-","MINUS").replace("*","STAR").replace("/","SLASH")
		s2 = s2.replace("(","LPAREN").replace(")","RPAREN").replace("[","LSQPAREN").replace("]","RSQPAREN")
		s2 = s2.replace(">","GREATER").replace("=","EQUAL").replace("<","LESS").replace("@","AT")
		s2 = s2.replace("!","PLING").replace("?","QMARK").replace("~","WAVY").replace("$","DOLLAR")
		s2 = s2.replace("^","HAT").replace("#","HASH").replace("%","PERCENT").replace("&","AMP")
		s2 = s2.replace(":","COLON").replace(";","SEMICOLON").replace(",","COMMA").replace("'","QUOTE")
		#s2 = s2.replace("","").replace("","").replace("","").replace("","")
		assert re.match("^([A-Z]+)$",s2) is not None,"Fail on "+s2 		# check it's just words.
		h.write("TKW_{0:24} = ${1:02x} ; {2}\n".format(s2,allTokens[k]["id"],s.lower()))
h.close()
#
#		Scan the sources in files.list for keyword markers.
#
handlers = {}
fileList = open(".."+os.sep+"source"+os.sep+"bin"+os.sep+"files.list").readlines()	# read in file list.
fileList = [x.strip() for x in fileList if not x.startswith(";")]		# remove comments
for f in [x for x in fileList if x != ""]:								# read through each file
	for s in open(f).readlines():
		if s.find(";;") > 0 and s.find("[") > 0:						# quick check.
			m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\[(.*)\\]\\s*$",s)	# rip parts out
			assert m is not None," Can't process "+s 					# check format and duplicate
			token = m.group(2).upper()
			assert token not in handlers,"Duplicate "+token
			handlers[token] = m.group(1).strip()
#
#		Output the vector tables. Build the lists of tokens as well.
#
tokenText = [ [],[],[],[] ] 											# text list goes in here.
undefined = []
for group in range(0,4):
	done = False
	n = t.getBinaryStart() if group > 0 else t.getEOLToken() 			# start at different places
	h = open(genDir+"tokenvectors"+str(group)+".inc","w")				# write to file
	h.write(header)
	h.write("Group{0}Vectors:\n".format(group))
	while not done:														# while not finished
		token = t.getFromID(group,n)									# get next token
		done = token is None											# fail if no token
		if not done:													# token found.
			tt = token["token"].upper()
			if not tt.startswith("[["):									# add to name list if not special
				tokenText[group].append(tt)
			if tt in handlers: 
				handler = handlers[tt] 									# what to run, then output table.
			else:
				handler = "Unimplemented"
				if group != 1 or n < t.getBaseAsmToken():				# no assembler undefined.
					undefined.append(tt.lower())				
			if group != 1 or n < t.getBaseAsmToken():					# no assembler vectors.
				h.write("\t.word\t{0:24} ; ${1:02x} {2}\n".format(handler,token["id"],tt.lower()))
		n += 1
	h.close()
#
#		Output the information table for group 0 - gives structure shifts and binary precedence.
#		(this has no label)
#
h = open(genDir+"binarystructinfo.inc","w")
h.write(header)
for tid in range(t.getBinaryStart(),t.getUnaryStart()):					# Just Binary and Structure +/-
	token = t.getFromID(0,tid)
	h.write("\t.byte\t${0:02x}\t\t\t; ${1:02x} {2}\n".format(token["type"],tid,token["token"].lower()))
h.close()
#
#		Output text entry lists.
#
for group in range(0,4):												# for each group
	h = open(genDir+"tokentext"+str(group)+".inc","w")
	h.write(header)
	h.write("Group{0}Text:\n".format(group))
	n = t.getBinaryStart()												# so we can track the number
	for token in tokenText[group]:										# for each token
		t1 = token 														# we tokenise to identifier 
		bList = [ord(c.upper()) for c in t1]							# convert to 6 bit format
		bList[-1] = bList[-1] | 0x80 									# set bit 7 of last.
		bList.insert(0,len(bList))										# length up front
		bList = ",".join(["${0:02x}".format(c) for c in bList])			# reformat and write out.
		h.write("\t.byte {0:32} ; ${1:02x} {2}\n".format(bList,n,token.lower()))
		n += 1
	h.write("\t.byte $00\n\n")											# marks end of list.
#
#		List undefined keywords
#
undefined.sort()
if len(undefined) > 0:
	print("Undefined keywords:{0} ".format(len(undefined))+" ".join(undefined))