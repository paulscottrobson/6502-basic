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
CTRLDIR = $(ROOTDIR)control$(S)

ASSEMBLESRC = 	$(ASM) $(ASMOPTS) -o $(OBJDIR)stub.prg basic.asm

.PHONY: all run analyse dump test

all : $(TESTDIR)makebasic.zip $(TESTDIR)vramc.zip $(APPNAME) 

run : $(APPNAME)
	$(CDEL) dump.bin $(CDELQ)
	$(EMULATOR) $<

analyse: $(APPNAME)
	python $(SCRIPTDIR)miscellaneous$(S)analyse.py $(OBJDIR)basic.lbl

dump : $(APPNAME)
	python $(SCRIPTDIR)miscellaneous$(S)dumpvar.py 

$(TESTDIR)makebasic.zip : $(SCRIPTDIR)build$(S)tokens.py $(SCRIPTDIR)build$(S)tokeniser.py  $(SCRIPTDIR)build$(S)tokendata.py $(SCRIPTDIR)build$(S)asmdata.py $(SCRIPTDIR)build$(S)makepgm.py $(SCRIPTDIR)build$(S)__main__.py
	zip -q -j $@ $^

$(TESTDIR)vramc.zip : $(SCRIPTDIR)vramc$(S)data.py  $(SCRIPTDIR)vramc$(S)encoder.py  $(SCRIPTDIR)vramc$(S)palette.py  $(SCRIPTDIR)vramc$(S)vramc.py  $(SCRIPTDIR)vramc$(S)vramfile.py  $(SCRIPTDIR)vramc$(S)__main__.py
	zip -q -j $@ $^

$(APPNAME) : basic.asm $(TESTDIR)makebasic.zip
	$(CDEL) generated$(S)*.inc $(CDELQ)
	python $(SCRIPTDIR)tests$(S)testtok.py disabled
	python $(SCRIPTDIR)build$(S)makepgm.py $(BASICDIR)demo.bas
	python $(SCRIPTDIR)build$(S)errorgen.py
	python $(SCRIPTDIR)build$(S)builder.py $(CTRLDIR)build.info
	python $(SCRIPTDIR)build$(S)asmtables.py
	python $(SCRIPTDIR)build$(S)tables.py
	$(CCOPY) $(OBJDIR)stub.prg $(TESTDIR)
	$(ASSEMBLESRC) 
	$(MAKEPRG)

test: 
	python $(SCRIPTDIR)tests$(S)$(TEST) >$(BASICDIR)test.bas
	python $(SCRIPTDIR)build$(S)makepgm.py $(BASICDIR)test.bas
	python $(SCRIPTDIR)build$(S)errorgen.py
	python $(SCRIPTDIR)build$(S)builder.py $(CTRLDIR)build.info
	python $(SCRIPTDIR)build$(S)asmtables.py
	python $(SCRIPTDIR)build$(S)tables.py
	$(ASSEMBLESRC) 
	$(MAKEPRG)
	$(CDEL) dump.bin $(CDELQ)
	$(EMULATOR) $(APPNAME)
