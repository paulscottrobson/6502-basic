# ************************************************************************************************
# ************************************************************************************************
#
#		Name:		Makefile
#		Purpose:	.... the make file ?
#		Created:	21st February 2021
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# ************************************************************************************************
# ************************************************************************************************

ifeq ($(OS),Windows_NT)
include ..\documents\general.make
else
include ../documents/general.make
endif

OBJDIR = $(SOURCEDIR)bin$(S)
ASMOPTS = -Walias -Wmacro-prefix -Wall -q -c -L $(OBJDIR)basic.lst -l $(OBJDIR)basic.lbl -Wall
APPNAME = $(OBJDIR)basic.prg

.PHONY: all run analyse dump

all : $(APPNAME)

run : $(APPNAME)
	$(CDEL) dump.bin $(CDELQ)
	$(EMULATOR) $<

analyse: $(APPNAME)
	python ..$(S)scripts$(S)analyse.py $(OBJDIR)basic.lbl

dump : $(APPNAME)
	python ..$(S)scripts$(S)dumpvar.py 

$(APPNAME) : basic.asm 
	$(CDEL) generated$(S)*.inc $(CDELQ)
#	python ..$(S)scripts$(S)tests$(S)testvar.py >$(BASICDIR)test.bas
	python ..$(S)scripts$(S)tests$(S)testtok.py x
	python ..$(S)scripts$(S)makepgm.py $(BASICDIR)demo.bas
	python ..$(S)scripts$(S)errorgen.py
	python ..$(S)scripts$(S)builder.py
	python ..$(S)scripts$(S)tables.py
	$(ASM) -D autorun=0 -D coldstartnew=0 $(ASMOPTS) -o $@ $^

