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

segments = {}
total = 0

if len(sys.argv) == 2:
	for l in open(sys.argv[1]).readlines():
		if l.startswith("section_"):
			m = re.match("^section_([a-z]+)_(.*?)\\s*\\=\\s*\\$([0-9a-f]+)\\s*$",l.lower())
			segment = m.group(2)
			if segment not in segments:
				segments[segment] = {}
			segments[segment][m.group(1).strip()] = int(m.group(3),16)
	keys = [x for x in segments.keys()]
	keys.sort(key = lambda x:segments[x]["start"])
	for k in keys:
		print("Section {0:16} ${1:04x}-${2:04x} ({3} bytes)".format('"'+k+'"',segments[k]["start"],segments[k]["end"],segments[k]["end"]-segments[k]["start"]))		