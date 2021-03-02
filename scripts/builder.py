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
#		Sort files so alphabetical, includes first, them main, then other assembler files.
#
def sortFn(x):
	x = ("0" if x.startswith("main") else "1")+x
	return ("0" if x.endswith(".inc") else "1")+x

import re,os,sys
#
#		The subdirectories that go to make the program. The asterisk 
#		means that dispatch is handled by the module itself, rather 
#		than routine scanning.
#
groups = """
	main 	
	variable		
	assembler 		
	error			*
	string 			
	device 			
	floatingpoint	- 	
	interaction
	tokeniser
"""
#
sourceList = []															# list of asm files.
sourceDir = ".."+os.sep+"source"										# where the source is.
#
mainIncludes = [] 														# includes for root assembler file
header = ";\n;\tAutomatically generated\n;\n"							# header used.
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
	compositeFile = "{0}{1}{0}.asm".format(section,os.sep) 				# the grouping file at this level.	
	mainIncludes.append(compositeFile)									# add in header/include
	mainIncludes.append(compositeFile.replace(".asm",".inc"))
	localDir = sourceDir+os.sep+section 								# where to search
	comFiles = []														# files in this list.
	vectors = {} 														# hash of name => label
	for root,dirs,files in os.walk(localDir):							# scan for files.
		for f in files:
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
	if createDispatcher:												# dispatcher here ??
		h.write("\n.section code\n")
		h.write("\n{0}Handler:\n".format(section))
		if enableCode:
			h.write("\tdispatch {0}Vectors\n\n".format(section))
			h.write("{0}Vectors:\n".format(section))
			ix = 0
			for k in vectorKeys:
				h.write("\t.word {0:20} ; index {1}\n".format(vectors[k],ix))
				ix += 2
		else:
			h.write("\terror NoModule\n")
		h.write(".send code\n")
	h.close()
	#
	h = open(localDir+os.sep+section+".inc","w")						# create the include file for this level.
	h.write(header)
	if createDispatcher:
		h.write(".section code\n")
		ix = 0
		for k in vectorKeys:
			h.write("{0}_{1} .macro\n".format(section,k))
			h.write("\tldx\t#{0}\n".format(ix))
			h.write("\tjsr\t{0}Handler\n".format(section))
			h.write("\t.endm\n\n")
			ix += 2
		h.write(".send code\n")
	h.close()
#
#		Write out main program.
#
mainIncludes.sort(key = lambda x:sortFn(x))
h = open(sourceDir+os.sep+"basic.asm","w")
h.write(header)
for i in mainIncludes:
	h.write('\t.include "{0}"\n'.format(i.replace(os.sep,"/")))
h.close()
#
#		Write out files
#
h = open(sourceDir+os.sep+"bin"+os.sep+"files.list","w")
h.write(header)
sourceList.sort()
h.write("\n".join(sourceList))
h.close()
