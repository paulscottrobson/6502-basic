# *****************************************************************************
# *****************************************************************************
#
#		Name:		builder.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Builds files that glue system together
#
# *****************************************************************************
# *****************************************************************************

import re,os,sys
#
#		The subdirectories that go to make the program. The asterisk 
#		means that dispatch is handled by the module itself, rather 
#		than routine scanning.
#
groups = """
	main 			
	assembler 		
	error			*
	generated 		
	string 			
	device.x16 			
	floatingpoint 	
	interaction
	tokeniser
"""
#
sourceDir = ".."+os.sep+"source"					# where the source is.
#
mainIncludes = [] 									# includes for root assembler file
header = ";\n;\tAutomatically generated\n;\n"		# header used.
