# ************************************************************************************************
# ************************************************************************************************
#
#		Name:		Makefile
#		Purpose:	BASIC Program Makefile
#		Created:	28th April 2021
#		Author:		Paul Robson (paul@robsons.org.uk)
#
# ************************************************************************************************
# ************************************************************************************************

ifeq ($(OS),Windows_NT)
include ..\..\documents\general.make
MAKEPRG = copy /y /b $(BINDIR)stub.prg + _basic.tokenised $(APPNAME).prg
else
include ../../documents/general.make
MAKEPRG = cat $(BINDIR)stub.prg _basic.tokenised >$(APPNAME).prg
endif

ROOTDIR = ..$(S)..$(S)
BINDIR = $(ROOTDIR)bin$(S)
APPNAME = grabber

.PHONY: all vram app run

all : vram app

vram : data.vram 

data.vram : vram$(S)vram.txt
	python $(BINDIR)vramc.zip

app : $(APPNAME).prg

$(APPNAME).prg : $(APPNAME).bas	
	python $(BINDIR)makebasic.zip $(APPNAME).bas
	$(MAKEPRG)

run : app vram
	$(EMULATOR) $(APPNAME).prg
