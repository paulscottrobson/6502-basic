# *****************************************************************************
# *****************************************************************************
#
#		Name:		errorgen.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Generates error list and includes.
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

languageFile = "english.txt"

errorDef = open("../scripts/languages/"+languageFile).readlines()		# Load error file
errorDef = [x.strip() for x in errorDef if x.strip() != ""]
errorDef = [x.replace("\t"," ") for x in errorDef if not x.startswith(";")]

genDir = "../source/generated/".replace("/",os.sep)					
header = ";\n;\tAutomatically generated\n;\n"							# header used.

errors = []
errID = 1

for s in errorDef:
	s = s.split(":")
	s = s if len(s) == 2 else s + s
	errors.append({ "ID":errID,"Label":s[0],"Text":s[1] })
	errID += 1

#
#	Create list of error IDs.
#
h = open(genDir+"errorid.inc","w")
h.write(header)
for e in errors:
	h.write("ErrorID_{1} = {0} ; {2}\n".format(e["ID"],e["Label"],e["Text"]))
h.close()
#
#	Create list of length-prefix error texts.
#
h = open(genDir+"errortext.inc","w")
h.write(header)
h.write("ErrorTextList:\n")
for e in errors:
	h.write('\t.text {1},"{0}"\n'.format(e["Text"],len(e["Text"])))
h.write("\t.byte 0\n\n")
h.close()
