# *******************************************************************************************
# *******************************************************************************************
#
#       File:           rasm.py
#       Date:           13th November 2020
#       Purpose:        Tiny assembler for Runtime.
#       Author:         Paul Robson (paul@robson.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,re,os

# *******************************************************************************************
#
#			One pass assembler class. Offloads the work onto 64tass mostly :)
#
#		   Yes, this is lazy bodge code, but it's not part of the final system.
#
# *******************************************************************************************

class Assembler(object):
	def __init__(self):
		#
		#		These are hardcoded. Bad practice, but this is just a testing assembler.
		#
		commands = "ldr,and,orr,xor,add,sub,mlt,div,mod,dec,str,bra,beq,bne,bmi,bpl".split(",")
		unary = "inc,dec,shl,shr,clr,ret".split(",")
		#
		self.commands = {}
		for i in range(0,len(commands)):
			self.commands[commands[i]] = 0x80+i
		for i in range(0,len(unary)):
			self.commands[unary[i]] = 0xF0+i
		#
		self.commands["halt"] = 0xFF
	#
	def assemble(self,srcCode,stream):
		stream.write(";\n;\tAutomatically generated\n;\n")
		srcCode = [x if x.find(";") < 0 else x[:x.find(";")] for x in srcCode]
		srcCode = [x.replace("\t"," ").strip().lower() for x in srcCode if x.strip() != ""]
		for c in srcCode:
			if c.startswith("."):
				stream.write("TEST_{0}:\n".format(c[1:]))
			else:
				m = re.match("^([a-z]+)\\s*(.*)$",c)
				assert m is not None,"Syntax error "+c
				opcode = m.group(1)
				operand = m.group(2).strip()
				self.assembleInstruction(stream,opcode,operand)
	#
	def assembleInstruction(self,stream,opcode,operand):
		assert opcode in self.commands,"Unknown "+opcode
		nop = self.commands[opcode]
		assert (nop < 0xF0) if operand != "" else (nop >= 0xF0),"Operand mismatch "+opcode+" "+operand
		if operand == "":
			asmCode = "${0:02x}".format(nop)
		else:
			asmCode = self.createCode(nop,operand,nop >= 0x8B)
		stream.write("\t.byte {0:40} ; {1} {2}\n".format(asmCode,opcode,operand))
	#
	def createCode(self,baseOpcode,operand,forceBranch):
		if not forceBranch:
			m = re.match("^\\#(\\d+)$",operand)
			if m is not None:
				operand = int(m.group(1))
				code = [baseOpcode + (0x10 if operand >= 256 else 0x00),operand & 0xFF]
				if operand >= 256:
					code.append(operand >> 8)
				code = ",".join(["${0:02x}".format(c) for c in code])
				return code
			m = re.match("^\\[(\\d+)\\]$",operand)
			if m is not None:
				operand = int(m.group(1))
				code = [baseOpcode + (0x30 if operand >= 256 else 0x20),operand & 0xFF]
				if operand >= 256:
					code.append(operand >> 8)
				code = ",".join(["${0:02x}".format(c) for c in code])
				return code
			m = re.match("^\\$(\\d+)",operand)		
			assert m is not None,"Bad operand "+opcode+" "+operand
			operand = int(m.group(1))
			code = [baseOpcode+0x40,operand & 0xFF,operand >> 8]
			code = ",".join(["${0:02x}".format(c) for c in code])
			return code
		#
		label = "TEST_"+operand
		return "${0:02x},{1} & $FF,{1} >> 8".format(baseOpcode+0x40,label)

asm = Assembler()
src = """
;
;		comment
;
	ldr 	#32766
	ret
	
""".split("\n")
asm.assemble(src,open(".."+os.sep+"runtime"+os.sep+"generated"+os.sep+"testasm.inc","w"))
