@echo off
rem
rem 	Soak test
rem
:loop
	make -Bs test TEST=testarr.py
	make -Bs test TEST=testarr2.py
	make -Bs test TEST=testbin.py
	make -Bs test TEST=testcore.py
	make -Bs test TEST=testprec.py
	make -Bs test TEST=teststrbin.py
	make -Bs test TEST=teststr.py
	make -Bs test TEST=testun.py
	make -Bs test TEST=testvar.py
goto loop