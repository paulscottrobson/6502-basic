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

APPNAME = basic.prg
ASMOPTS = -q -c -L basic.lst -l basic.lbl -Wall
.PHONY: all run

all : $(APPNAME)

run : $(APPNAME)
	$(EMULATOR) $<

$(APPNAME) : $(SOURCEDIR)basic.asm 
	$(CDEL) generated$(S)*.inc $(CDELQ)
	python ..$(S)/scripts$(S)errorgen.py
	python ..$(S)/scripts$(S)builder.py
	python ..$(S)/scripts$(S)tables.py
	$(ASM) $(ASMOPTS) -o $@ $^

