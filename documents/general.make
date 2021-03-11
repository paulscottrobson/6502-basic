# ************************************************************************************************
# ************************************************************************************************
#
#		Name:		general.make
#		Purpose:	Common Makefile includes.
#		Created:	21st February 2021
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# ************************************************************************************************
# ************************************************************************************************

ifeq ($(OS),Windows_NT)
CCOPY = copy
CMAKE = make
CDEL = del /Q
CDELQ = >NUL
APPSTEM = .exe
S = \\
else
CCOPY = cp
CDEL = rm -f
CDELQ = 
CMAKE = make
APPSTEM =
S = /
endif
#
#		Root directory
#
ROOTDIR = ..$(S)
#
#		Script to run emulator, expecting parameter to follow
#
EMULATOR = $(ROOTDIR)bin$(S)x16emu -keymap en-gb -dump R -debug  -run -scale 2 -prg
#
#		Current assembler
# 
ASM = 64tass
#
#		Source directory
#
SOURCEDIR = $(ROOTDIR)source$(S)
#
#		BASIC program directory
#
BASICDIR = $(ROOTDIR)basic$(S)