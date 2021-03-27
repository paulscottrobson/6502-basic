# *****************************************************************************
# *****************************************************************************
#
#		Name:		builder.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		27th March 2021
#		Purpose:	Builds files that glue system together (restructured)
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys

# *****************************************************************************
#
#				Worker class which processes the group files
#
# *****************************************************************************

class Builder(object):
	def __init__(self,groups):
		#
		self.sourceList = []													# list of asm files.
		self.sourceDir = ".."+os.sep+"source"									# where the source is.
		#
		self.mainIncludes = [] 													# includes for root assembler file
		self.header = ";\n;\tAutomatically generated\n;\n"						# header used.
		#
		self.isEnabled = {}														# modules enabled/not enabled
		self.isDispatched = {} 													# does it have std disaptcher
#
		for s in [x.replace("\t"," ").strip() for x in groups.split("\n") if x.strip() != ""]:
			self.processGroup(s.strip())

		self.writeInstallCheckFile()											# constant for each installed
		self.createInitialiseAllFile()											# calls initialise for every module
		self.createMainProgram()												# main linking progrm
		self.createFileList()													# list of files for scanners
	#
	#		Process group S.
	#
	def processGroup(self,s):
		section = s 															# check if dispatched manually.
		createDispatcher = True 												# do we create auto dispatch
		enableCode = True 														# do we generate code.
		if s.endswith("*"): 													# check for * (no dispatch)
			section = section[:-1].strip()
			createDispatcher = False
		if s.endswith("-"):														# check for - (no code)
			section = section[:-1].strip()
			enableCode = False
		#
		self.isEnabled[section] = enableCode									# store if enabled.
		self.isDispatched[section] = createDispatcher
		#
		compositeFile = "{0}{1}{0}.asm".format(section,os.sep) 					# the grouping file at this level.	
		self.mainIncludes.append(compositeFile)									# add in header/include
		self.mainIncludes.append(compositeFile.replace(".asm",".inc"))
		self.scanFiles(section)
	#
	#		Scan files in section for files to use.
	#
	def scanFiles(self,section):
		self.localDir = self.sourceDir+os.sep+section 							# where to search
		comFiles = []															# files in this list.
		self.vectors = {} 														# hash of name => label
		for root,dirs,files in os.walk(self.localDir):							# scan for files.
			for f in [x for x in files if root.find("unused") < 0]:				# that aren't marked unused
				if f.split(".")[0] != section:									# don't include the composite
					fn = root+os.sep+f 											# full file name
					if fn.endswith(".inc"):										# include file.
						self.mainIncludes.append(fn[len(self.sourceDir)+1:])	# add to includes, relative to source root
					else:
						comFiles.append(fn[len(self.localDir)+1:])				# add to includes, relative to group/
						self.scanForVectors(fn)
					self.sourceList.append(fn)									# add to source list.
		comFiles.sort()															# put files into alphabetical order.
		#
		vectorKeys = [x for x in self.vectors.keys()]							# put routine keys into working order
		vectorKeys.sort()
		if "controlhandler" in vectorKeys: 										# Process control handler.
			vectorKeys = [x for x in vectorKeys if x != "controlhandler"]		# Delete if exists
		else:
			self.vectors["controlhandler"] = "_DummyControlHandler"				# Dummy if doesn't exist
		vectorKeys.insert(0,"controlhandler")									# make it first vector.
		self.createLevelFile(section,comFiles,vectorKeys)						# create this section.
		self.createIncludeFile(section,vectorKeys)
	#
	#		Scan file for vector markers e.g. label: ;; <name>
	#
	def scanForVectors(self,fn):
		for s in open(fn).readlines():											# scan for ;; <xxxx> markings.
			if s.find(";;") >= 0 and s.find(">") >= 0 and s.strip().endswith(">"):
				m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\<(.*?)\\>\\s*$",s)
				assert m is not None,"Bad line "+s
				self.vectors[m.group(2).strip()] = m.group(1).strip()

	#
	#		Create the main file with all the included source code and dispatcher if enabled.
	#
	def createLevelFile(self,section,comFiles,vectorKeys):
		h = open(self.localDir+os.sep+section+".asm","w")						# create the file for this level.
		#
		#		First write all the includes that go to make the code.
		#
		h.write(self.header)
		if self.isEnabled[section]:
			for i in comFiles:
				h.write('\t.include "{0}"\n'.format(i.replace(os.sep,"/")))
		h.write("\n.section code\n")
		#
		#		Then create the dispatcher.
		#
		if self.isDispatched[section]:											# dispatcher here ??
			h.write("\n{0}Handler:\n".format(section))							# dispatcher label
			if self.isEnabled[section]:
				h.write("\tdispatch {0}Vectors\n\n".format(section))			# if enabled dispatch macro
				h.write("{0}Vectors:\n".format(section))						# create vector table
				ix = 0
				for k in vectorKeys:
					h.write("\t.word {0:20} ; index {1}\n".format(self.vectors[k],ix))
					ix += 2
				h.write("_DummyControlHandler:\n\trts\n")
			else:
				h.write("\t.throw NoModule\n")									# not enabled throw error
		h.write(".send code\n")
		h.close()
	#
	#		Create the include file with all the Macro Shortcuts
	#
	def createIncludeFile(self,section,vectorKeys):
		h = open(self.localDir+os.sep+section+".inc","w")						# create the include file for this level.
		h.write(self.header)
		h.write(".section code\n")
		if self.isDispatched[section]:
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
	#		Write out the flag include showing whether modules are installed or not.
	#
	def writeInstallCheckFile(self):
		h = open(self.sourceDir+os.sep+"generated"+os.sep+"installed.inc","w")
		h.write(self.header)
		for k in self.isEnabled.keys():
			h.write("installed_{0} = {1}\n".format(k,1 if self.isEnabled[k] else 0)) 
		h.close()
	#
	#		Write out initialise all code.
	#
	def createInitialiseAllFile(self):
		h = open(self.sourceDir+os.sep+"generated"+os.sep+"initialiseall.asm","w")
		h.write("InitialiseAll:\n")
		dk = [x for x in self.isDispatched.keys()]
		dk.sort()
		for k in dk:
			if self.isDispatched[k] and self.isEnabled[k]:
				h.write("\tlda #0\n\t.{0}_controlhandler\n".format(k))
		h.write("\trts\n")
		h.close()
	#
	#		Write out main program.
	#
	def createMainProgram(self):
		self.mainIncludes.sort(key = lambda x:Builder.sorter(x))
		h = open(self.sourceDir+os.sep+"basic.asm","w")
		h.write(self.header)
		for i in self.mainIncludes:
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
	#		Sort files so alphabetical, includes first, then header, then other assembler files.
	#		then footer.
	#
	@staticmethod
	def sorter(x):
		if x.startswith("header"):
			x = "0"+x
		elif x.startswith("footer"):
			x = "2"+x
		else:
			x = "1"+x
		return ("0" if x.endswith(".inc") else "1")+x	#
	#		Write out files
	#
	def createFileList(self):
		h = open(self.sourceDir+os.sep+"bin"+os.sep+"files.list","w")
		h.write(self.header)
		self.sourceList.sort()
		h.write("\n".join(self.sourceList))
		h.close()


#
#		The subdirectories that go to make the program. The asterisk 
#		means that dispatch is handled by the module itself, rather 
#		than routine scanning.
#
#		* means no automatic dispatcher is built
#		- means the module is disabled.
#
if __name__ == "__main__":
	Builder("""
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
	""")
