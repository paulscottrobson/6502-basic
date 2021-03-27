# *****************************************************************************
# *****************************************************************************
#
#		Name:		revcheck.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		11th March 2021
#		Purpose:	Scan for review checks.
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

months = { "JAN":1,"FEB":2,"MAR":3,"APR":4,"MAY":5,"JUN":6,"JUL":7,"AUG":8,"SEP":9,"OCT":10,"NOV:":11,"DEC":12 }

def toDate(s):
	m = re.match("^(\\d+)[A-Z]+\\s*(\\w+)\\s*(\\d+)$",s.strip().upper())
	assert m is not None,"Bad date ["+s.strip().upper()+"]"
	mn = months[m.group(2)[:3]]
	date = [int(m.group(1)),mn,int(m.group(3))]
	return date
	
sources = {}

for root,dirs,files in os.walk("../source"):
	for f in [x for x in files if x.endswith(".asm") or x.endswith(".inc")]:
		print(f)
		info = { "create":None,"review":None }
		isAuto = False
		for l in open(root+os.sep+f).readlines():
			if l.startswith(";"):
				if l.find("Automatically generated") >= 0:
					isAuto = True
				if l.find("Created:") >= 0:
					m = re.match("^\\;.*?\\:(.*)$",l)
					info["create"] = toDate(m.group(1))
				if l.find("Reviewed:") >= 0:
					m = re.match("^\\;.*?\\:(.*)$",l)
					info["review"] = toDate(m.group(1))
		if not isAuto:
			sources[root+os.sep+f] = info

for s in sources:
	if sources[s]["review"] is None:
		print(s,sources[s]["create"])

	