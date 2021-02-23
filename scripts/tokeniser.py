# *****************************************************************************
# *****************************************************************************
#
#		Name:		tokeniser.py
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		21st February 2021
#		Purpose:	Tokeniser worker.
#
# *****************************************************************************
# *****************************************************************************

from tokens import *
import os,re,sys

# *****************************************************************************
#
#								Tokeniser worker
#
# *****************************************************************************

class Tokeniser(object):
	def __init__(self):
		self.tokens = Tokens()											# token info object.
	#
	#	 	Tokenise one line.
	#
	def tokenise(self,s):
		self.code = []													# tokens go in here.
		s = s.strip()
		while s != "":													# do one at a time.
			s = self.tokeniseOne(s).strip()
		return self.code
	#
	#		Simple tester.
	#
	def test(self,s):
		print("--> '"+s+"'")
		data = " ".join(["{0:02x}".format(c) for c in self.tokenise(s)])
		print("\t",data)
	#
	#		Tokenise one element.
	#
	def tokeniseOne(self,s):
		#
		#		Constant. These can be 4223 $A75 formats.
		#
		m = re.match("^(\\d+)(.*)$",s)
		if m is not None:
			self.tokeniseInteger(int(m.group(1)))
			return m.group(2)
		m = re.match("^\\$([0-9a-fA-F]+)(.*)$",s)
		if m is not None:
			self.appendToken("&")
			self.tokeniseInteger(int(m.group(1),16))
			return m.group(2)
		#
		#		String constant "Hello, world !"
		#
		m = re.match('^\\"(.*?)\\"(.*)$',s)
		if m is not None:
			string = [ord(c) for c in m.group(1)]
			string.insert(0,len(string))
			string.insert(0,self.tokens.getStringMarkerToken())
			self.code += string
			return m.group(2)
		#
		#		Alphanumeric identifier, may also be a token.
		#
		m = re.match("^([A-Za-z][A-Za-z0-9\\.]*)([\\#\\$\\%]?)(\\(?)(.*)$",s)
		if m is not None:
			fullToken = m.group(1)+m.group(2)+m.group(3) 					# full text version
			checkToken = self.tokens.getFromToken(fullToken)				# is it a token ?
			if checkToken is not None:
				self.appendToken(fullToken)									# then use that.
			else:
				iType = m.group(2) if m.group(2) != "" else "%"				# default to % integer.
				nType = 0x3A + 2 * "%$#".find(iType) 						# base type number.
				if m.group(3) == "(":										# adjustment if array.
					nType += 1
				ident = m.group(1).upper()+chr(nType)						# the full identifier
				self.code += [ord(c) & 0x3F for c in ident]					# add it on.			
			return m.group(4)
		#
		#		Punctuation. Check first two, then first one. Doesn't begin with A-Z.
		#
		checkToken = None
		if len(s) > 1: 														# try last 2
			checkToken = self.tokens.getFromToken(s[:2])
		if checkToken is None:												# try last 1
			checkToken = self.tokens.getFromToken(s[:1])
		#
		assert checkToken is not None,"Cannot tokenise '"+s+"'" 			# give up !
		#
		self.appendToken(checkToken["token"])								# write out token.
		return s[len(checkToken["token"]):]									# return the rest.
	#
	#		Tokenise an integer.
	#
	def tokeniseInteger(self,n):
		n = n & 0xFFFFFFFF
		if n > 63:
			self.tokeniseInteger(n >> 6)
		self.code.append((n & 0x3F)+0x40)
	#
	#		Add a token.
	#
	def appendToken(self,token):
		t = self.tokens.getFromToken(token)
		assert t is not None,"Do not recognise '"+token+"'"
		if t["group"] != 0:
			self.code.append(self.getShiftToken(t["group"]))
		self.code.append(t["id"])

if __name__ == "__main__":
	tw = Tokeniser()
	if False:
		tw.test("42 67 $2A $43")		
		tw.test('"" "Hello"')
		tw.test("a a% a%( a$ a$( a# a#(")
		tw.test("az.09$ input inputd len( left$(")
		tw.test("=<=< > >=")
	else:
		code = tw.tokenise('5 > 6')+[0x80]
		header= ";\n;\tAutomatically generated\n;\n"							# header used.
		genDir = "../source/generated/".replace("/",os.sep)			
		h = open(genDir+"testcode.inc","w")
		h.write(header)
		h.write("TestCode:\n")
		h.write("\t.byte {0}\n\n".format(",".join([str(x) for x in code])))
		h.close()

	