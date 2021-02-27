# *****************************************************************************
# *****************************************************************************
#
#		Name:		usage.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th February 2021
#		Purpose:	Analyse usage of program.
#
# *****************************************************************************
# *****************************************************************************

import os,re,sys

currentPC = 0x0000

segments = {}
current = None

if len(sys.argv) == 2:
	for l in open(sys.argv[1]).readlines():
		if l.startswith(";"):
			m = re.match("^\\;.*Processing file\\:\\s+\\.\\.\\/source\\/(.*?)\\/.*\\.asm",l)
			if m is not None:
				current = m.group(1).strip().lower()
				if current not in segments:
					segments[current] = { "name":current,"start":None,"end":currentPC }


		if l.startswith(".") and current is not None:
			m = re.match("^\\.([0-9a-fA-F]+)\\s+([0-9a-fA-F]+)",l)
			if m is not None:
				newPC = int(m.group(1),16)
				currentPC = newPC				
				if segments[current]["start"] is None:
					segments[current]["start"] = newPC
				segments[current]["end"] = newPC

	keys = [x for x in segments.keys()]
	keys.sort(key = lambda x:segments[x]["start"])
	for k in keys:
		print("Section {0:16} ${1:04x}-${2:04x} ({3} bytes)".format('"'+k+'"',segments[k]["start"],segments[k]["end"],segments[k]["end"]-segments[k]["start"]))