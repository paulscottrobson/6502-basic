# *****************************************************************************
# *****************************************************************************
#
#		Name:		callcheck.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		9th March 2021
#		Purpose:	Checks all calls are internal, i.e. the code doesn't
#					jmp or jsr to a routine in another module.
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

sections = {}

for root,dirs,files in os.walk("../source"):
	section = root.split("/")
	if len(section) > 2:
		section = section[2]
		if section not in sections:
			sections[section] = { "targets":{},"labels":{} }
		for f in [x for x in files if x.endswith(".asm")]:
			for l in open(root+os.sep+f).readlines():
				if l.find(":") > 0:
					m = re.match("^([0-9A-Za-z\\_]+)\\:",l)
					if m is not None:
						sections[section]["labels"][m.group(1).lower().strip()] = True
				if l.find("jsr") >= 0 or l.find ("jmp") >= 0:
					m = re.search("jsr\\s+([0-9A-Za-z\\_]+)",l)
					if m is None:
						m = re.search("jmp\\s+([0-9A-Za-z\\_]+)",l)
					if m is not None:
						sections[section]["targets"][m.group(1).lower().strip()] = True

secKeys = [x for x in sections.keys()]							
secKeys.sort()
for k in secKeys:
	for t in sections[k]["targets"].keys():
		if t not in sections[k]["labels"] and t != "initialiseall":
			print("Bad : "+t+" accessed in "+k)
