# *****************************************************************************
# *****************************************************************************
#
#		Name:		__main__.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		11th March 2021
#		Purpose:	Main program for zipped makebasic.zip app.
#
# *****************************************************************************
# *****************************************************************************

import os,re,sys
from tokeniser import *
from tokens import *
from makepgm import *

pb = ProgramBuilder()
if len(sys.argv) == 1:
	print("python makebasic.zip <component files>")
else:
	for f in sys.argv[1:]:
		pb.load(f)
	pb.exportBin("_basic.tokenised".replace("/",os.sep))
