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

APPNAME = action.prg
ASMOPTS = -q -c -L action.lst -l action.lbl -Wall
.PHONY: all run

all : $(APPNAME)

run : $(APPNAME)
	$(EMULATOR) $<

$(APPNAME) : $(SOURCEDIR)action.asm 
	$(ASM) $(ASMOPTS) -o $@ $^
	$(CCOPY) $(APPNAME) ..$(S)bin
	$(CCOPY) action.lbl ..$(S)bin

