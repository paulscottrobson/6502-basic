ifeq ($(OS),Windows_NT)
CCOPY = copy
CCOPYQ = >NUL
CMAKE = mingw32-make
S = \\
else
CCOPY = cp
CCOPYQ = 
CMAKE = make
S = /
endif

PRGFILE = galaxians.prg
SOURCE = sprite.data.amo graphics.amo enemy.amo missile.amo galaxians.amo

.PHONY : all

all : $(PRGFILE)

run : $(PRGFILE)
	..$(S)bin$(S)x16emu -debug -prg $(PRGFILE) -scale 2 -run

gif : $(PRGFILE)
	..$(S)bin$(S)x16emu -debug -prg $(PRGFILE) -scale 2 -run -gif demo.gif

sprite.data.amo : sprites$(S)/sprites.def	
	python ..$(S)/scripts/$(S)/cvsprite.py

$(PRGFILE) : $(SOURCE)
	$(CMAKE) -C ..$(S)runtime
	$(CCOPY) ..$(S)bin$(S)runtime.prg . $(CCOPYQ)
	python ..$(S)bin$(S)amoral.zip -n -o $@ -s $(SOURCE)