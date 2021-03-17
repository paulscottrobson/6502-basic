;
;	Automatically generated
;
	.include "header/01common.inc"
	.include "header/02macros.inc"
	.include "header/03data.inc"
	.include "header/header.inc"
	.include "assembler/asmconst.inc"
	.include "assembler/assembler.inc"
	.include "device/device.inc"
	.include "error/error.inc"
	.include "error/errorhandler.inc"
	.include "extension/extension.inc"
	.include "floatingpoint/float.inc"
	.include "floatingpoint/floatingpoint.inc"
	.include "interaction/interaction.inc"
	.include "main/main.inc"
	.include "string/functions/memory.inc"
	.include "string/string.inc"
	.include "tokeniser/detokenise/colouring.inc"
	.include "tokeniser/tokeniser.inc"
	.include "variable/variable.inc"
	.include "footer/footer.inc"
	.section code
section_start_header:
	.send code
	.include "header/header.asm"
	.section code
section_end_header:
	.send code
	.section code
section_start_assembler:
	.send code
	.include "assembler/assembler.asm"
	.section code
section_end_assembler:
	.send code
	.section code
section_start_device:
	.send code
	.include "device/device.asm"
	.section code
section_end_device:
	.send code
	.section code
section_start_error:
	.send code
	.include "error/error.asm"
	.section code
section_end_error:
	.send code
	.section code
section_start_extension:
	.send code
	.include "extension/extension.asm"
	.section code
section_end_extension:
	.send code
	.section code
section_start_floatingpoint:
	.send code
	.include "floatingpoint/floatingpoint.asm"
	.section code
section_end_floatingpoint:
	.send code
	.section code
section_start_interaction:
	.send code
	.include "interaction/interaction.asm"
	.section code
section_end_interaction:
	.send code
	.section code
section_start_main:
	.send code
	.include "main/main.asm"
	.section code
section_end_main:
	.send code
	.section code
section_start_string:
	.send code
	.include "string/string.asm"
	.section code
section_end_string:
	.send code
	.section code
section_start_tokeniser:
	.send code
	.include "tokeniser/tokeniser.asm"
	.section code
section_end_tokeniser:
	.send code
	.section code
section_start_variable:
	.send code
	.include "variable/variable.asm"
	.section code
section_end_variable:
	.send code
	.section code
section_start_footer:
	.send code
	.include "footer/footer.asm"
	.section code
section_end_footer:
	.send code
