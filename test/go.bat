@echo off
rem 	*** Haven't actually tested this yet :( ***
rem
rem 	This python program tokenises the text files following it.
rem
python makebasic.zip test.bas
rem
rem		It is then attached to the stub of the BASIC program.
rem
copy /y /b stub.prg  + _basic.tokenised basic.prg
rem
rem		And run in the emulator
rem
..\bin\x16emu -keymap en-gb -debug -run -scale 2 -prg basic.prg