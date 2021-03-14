# *****************************************************************************
# *****************************************************************************
#
#		Name:		asmtables.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		13th March 2021
#		Purpose:	Generate various tables (assembler specific)
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import os,re,sys

header= ";\n;\tAutomatically generated\n;\n"							# header used.
genDir = "../source/generated/".replace("/",os.sep)					
#
#		Create the constants table.
#
h = open(genDir+"asmconst.inc","w")
h.write(header)
h.close()
#
#		Create the text table to extend the tokens for Group 1.
#
h = open(genDir+"asmtext.inc","w")
h.write(header)
h.close()
