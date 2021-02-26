# *****************************************************************************
# *****************************************************************************
#
#		Name:		testbin.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		26th February 2021
#		Purpose:	Binary test classes.
#
# *****************************************************************************
# *****************************************************************************

import random,sys
from testcore import *
# *****************************************************************************
#
#		Binary operator test
#
# *****************************************************************************

class BinopTest(Test):
	def getTest(self,n):
		ok = False
		while not ok:
			op = "+ - * / % & | ^ < = > <= >= <>".split(" ")
			op = op[random.randint(0,len(op)-1)]
			opn = op
			n1 = random.randint(-10000000,10000000)
			n2 = random.randint(-10000000,10000000)
			if "%".find(op) >= 0:
				n1 = abs(n1)
				n2 = abs(n2)
			if op == "+":
				n3 = n1 + n2
			if op == "-":
				n3 = n1 - n2
			if op == "*":
				n3 = n1 * n2
			if op == "/":
				n3 = abs(n1) // abs(n2)
				if n1 * n2 < 0:
					n3 = -n3
			if op == "%":
				opn = "mod"
				n3 = n1 % n2
			if op == "&":
				opn = "and"
				n3 = n1 & n2
			if op == "|":
				opn = "or"
				n3 = n1 | n2
			if op == "^":
				opn = "xor"
				n3 = n1 ^ n2
			if op == ">":
				n3 = -1 if n1 > n2 else 0
			if op == "<":
				n3 = -1 if n1 < n2 else 0
			if op == "=":
				n3 = -1 if n1 == n2 else 0
			if op == ">=":
				n3 = -1 if n1 >= n2 else 0
			if op == "<=":
				n3 = -1 if n1 <= n2 else 0
			if op == "<>":
				n3 = -1 if n1 != n2 else 0

			ok = n3 >= -0x80000000 and n3 < 0x7FFFFFFF
		return "({0} {1} {2}) = {3}".format(n1,opn,n2,n3)

if __name__ == "__main__":		
	t = BinopTest(500)
