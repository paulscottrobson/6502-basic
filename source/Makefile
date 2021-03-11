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
MAKEPRG = copy /y /b $(OBJDIR)stub.prg + $(SOURCEDIR)generated$(S)testcode.bin $(OBJDIR)basic.prg
else
include ../documents/general.make
MAKEPRG = cat $(OBJDIR)stub.prg $(SOURCEDIR)generated$(S)testcode.bin >$(OBJDIR)basic.prg
endif

OBJDIR = $(SOURCEDIR)bin$(S)
ASMOPTS = -Walias -Wmacro-prefix -Wall -q -c -L $(OBJDIR)basic.lst -l $(OBJDIR)basic.lbl -Wall
APPNAME = $(OBJDIR)basic.prg
TESTDIR = $(ROOTDIR)test$(S)
SCRIPTDIR = $(ROOTDIR)scripts$(S)

.PHONY: all run analyse dump

all : $(APPNAME) $(TESTDIR)makebasic.zip

run : $(APPNAME)
	$(CDEL) dump.bin $(CDELQ)
	$(EMULATOR) $<

analyse: $(APPNAME)
	python $(SCRIPTDIR)analyse.py $(OBJDIR)basic.lbl

dump : $(APPNAME)
	python $(SCRIPTDIR)dumpvar.py 

$(TESTDIR)makebasic.zip : $(SCRIPTDIR)tokens.py $(SCRIPTDIR)tokeniser.py $(SCRIPTDIR)makepgm.py $(SCRIPTDIR)__main__.py
	zip -q -j $@ $^

$(APPNAME) : basic.asm $(TESTDIR)makebasic.zip
	$(CDEL) generated$(S)*.inc $(CDELQ)
#	python $(SCRIPTDIR)tests$(S)testvar.py >$(BASICDIR)test.bas
	python $(SCRIPTDIR)tests$(S)testtok.py disabled
	python $(SCRIPTDIR)makepgm.py $(BASICDIR)demo.bas
	python $(SCRIPTDIR)errorgen.py
	python $(SCRIPTDIR)builder.py
	python $(SCRIPTDIR)tables.py
	$(ASM) -D autorun=1 -D coldstartnew=0 $(ASMOPTS) -o $(OBJDIR)stub.prg $<
	$(CCOPY) $(OBJDIR)stub.prg $(TESTDIR)
	$(MAKEPRG)

