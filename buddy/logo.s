		;;	logo.s
		;;	logo for yx and buddy
		;;
		;;	notes: see glyph.h
		;;
		;;	tomaz stih sun jan 5 2014
		.module logo		 
		
		.globl	_logo
		
		.area	_CODE
_logo::		ld	hl,#logo
		ret

logo:
		;; glyph header
		.db	1			;; bytes per glyph line 
		.db	5			;; glyph lines 

		;; logo glyph 
		.db	0b10100000
		.db	0b01000000
		.db	0b10010100
		.db	0b00001000
		.db	0b00010100
		.db	6
		
		;; T-T-T-That's all folks!
