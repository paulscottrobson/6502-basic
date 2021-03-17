# *****************************************************************************
# *****************************************************************************
#
#		Name:		builder.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Builds files that glue system together
#					Creates list of files inlcuded for scanning.
#
# *****************************************************************************
# *****************************************************************************
#
#		Sort files so alphabetical, includes first, then header, then other assembler files.
#		then footer.
#
def sortFn(x):
	if x.startswith("header"):
		x = "0"+x
	elif x.startswith("footer"):
		x = "2"+x
	else:
		x = "1"+x
	return ("0" if x.endswith(".inc") else "1")+x

import re,os,sys
#
#		The subdirectories that go to make the program. The asterisk 
#		means that dispatch is handled by the module itself, rather 
#		than routine scanning.
#
groups = """
	header			*
	main 	
	variable		
	assembler 		
	error			*
	extension 		*
	string 			
	device 			
	floatingpoint	- 	
	interaction
	tokeniser
	footer 			*
"""
#
sourceList = []															# list of asm files.
sourceDir = ".."+os.sep+"source"										# where the source is.
#
mainIncludes = [] 														# includes for root assembler file
header = ";\n;\tAutomatically generated\n;\n"							# header used.
#
isEnabled = {}															# modules enabled/not enabled
#
for s in [x.replace("\t"," ").strip() for x in groups.split("\n") if x.strip() != ""]:
	section = s 														# check if dispatched manually.
	createDispatcher = True
	enableCode = True
	if s.endswith("*"):
		section = section[:-1].strip()
		createDispatcher = False
	if s.endswith("-"):
		section = section[:-1].strip()
		enableCode = False
	#
	isEnabled[section] = enableCode										# store if enabled.
	#
	compositeFile = "{0}{1}{0}.asm".format(section,os.sep) 				# the grouping file at this level.	
	mainIncludes.append(compositeFile)									# add in header/include
	mainIncludes.append(compositeFile.replace(".asm",".inc"))
	localDir = sourceDir+os.sep+section 								# where to search
	comFiles = []														# files in this list.
	vectors = {} 														# hash of name => label
	for root,dirs,files in os.walk(localDir):							# scan for files.
		for f in [x for x in files if root.find("unused") < 0]:
			if f.split(".")[0] != section:								# don't include the composite
				fn = root+os.sep+f 										# full file name
				if fn.endswith(".inc"):									# include file.
					mainIncludes.append(fn[len(sourceDir)+1:])			# add to includes, relative to source root
				else:
					comFiles.append(fn[len(localDir)+1:])				# add to includes, relative to group/
					for s in open(fn).readlines():						# scan for ;; <xxxx> markings.
						if s.find(";;") >= 0 and s.find(">") >= 0 and s.strip().endswith(">"):
							m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\<(.*?)\\>\\s*$",s)
							assert m is not None,"Bad line "+s
							vectors[m.group(2).strip()] = m.group(1).strip()
					sourceList.append(fn)								# add to source list.

	comFiles.sort()														# put files into alphabetical order.
	#
	vectorKeys = [x for x in vectors.keys()]							# put routine keys into working order
	vectorKeys.sort()
	#
	h = open(localDir+os.sep+section+".asm","w")						# create the file for this level.
	h.write(header)
	if enableCode:
		for i in comFiles:
			h.write('\t.include "{0}"\n'.format(i.replace(os.sep,"/")))
	h.write("\n.section code\n")
	if createDispatcher:												# dispatcher here ??
		h.write("\n{0}Handler:\n".format(section))
		if enableCode:
			h.write("\tdispatch {0}Vectors\n\n".format(section))
			h.write("{0}Vectors:\n".format(section))
			ix = 0
			for k in vectorKeys:
				h.write("\t.word {0:20} ; index {1}\n".format(vectors[k],ix))
				ix += 2
		else:
			h.write("\t.throw NoModule\n")
	h.write(".send code\n")
	h.close()
	#
	h = open(localDir+os.sep+section+".inc","w")						# create the include file for this level.
	h.write(header)
	h.write(".section code\n")
	if createDispatcher:
		ix = 0
		for k in vectorKeys:
			h.write("{0}_{1} .macro\n".format(section,k))
			h.write("\tldx\t#{0}\n".format(ix))
			h.write("\tjsr\t{0}Handler\n".format(section))
			h.write("\t.endm\n\n")
			ix += 2
	else:
		h.write("{0}_{1} .macro\n".format(section,"execown"))
		h.write("\tjsr\t{0}Handler\n".format(section))
		h.write("\t.endm\n\n")
	h.write(".send code\n")
	h.close()
#
#		Write out installed flags
#
h = open(sourceDir+os.sep+"generated"+os.sep+"installed.inc","w")
h.write(header)
for k in isEnabled.keys():
	h.write("installed_{0} = {1}\n".format(k,1 if isEnabled[k] else 0)) 
h.close()
#
#		Write out main program.
#
mainIncludes.sort(key = lambda x:sortFn(x))
h = open(sourceDir+os.sep+"basic.asm","w")
h.write(header)
for i in mainIncludes:
	if i.endswith(".asm"):
		section = i.split(os.sep)[0]
		h.write("\t.section code\n")
		h.write("section_start_{0}:\n".format(section))
		h.write("\t.send code\n")
	h.write('\t.include "{0}"\n'.format(i.replace(os.sep,"/")))
	if i.endswith(".asm"):
		h.write("\t.section code\n")
		h.write("section_end_{0}:\n".format(section))
		h.write("\t.send code\n")
h.close()
#
#		Write out files
#
h = open(sourceDir+os.sep+"bin"+os.sep+"files.list","w")
h.write(header)
sourceList.sort()
h.write("\n".join(sourceList))
h.close()
