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

PRGFILE = test.prg

.PHONY : all

all : $(PRGFILE)

run : $(PRGFILE)
	..$(S)bin$(S)x16emu -debug -prg $(PRGFILE) -scale 2 -run

gif : $(PRGFILE)
	..$(S)bin$(S)x16emu -debug -prg $(PRGFILE) -scale 2 -run -gif demo.gif

palette.amo : palette.py
	python palette.py 
	
$(PRGFILE) : sprite.data.amo test.amo 
	$(CMAKE) -C ..$(S)runtime
	$(CCOPY) ..$(S)bin$(S)runtime.prg . $(CCOPYQ)
	python ..$(S)bin$(S)amoral.zip -o $@ -s $^