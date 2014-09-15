		;; crt0.s
		;; yx app startup code
		;;
		;; tomaz stih, sun sep 14 2014
		.module crt0

		.globl	_query_api

		.area	_HEADER (ABS)	
init:		
		;; task switch takes care of:
		;; relocation		
		;; storing regs
		;; setting sp	
		call	gsinit			; init static vars
		call	_main

		;; if we are here call exit (syscall)
cleanup:		
		ld	hl,#yx			; hl is "yx"	
		xor	a
		rst	10			; query api
		inc	hl			; exit function is...
		inc	hl			; ...second entry
		ld	bc,#0x0000
		push	bc			; ret code 0 on stack
		call	hl			; call exit
yx:		.db	'y','x',0

_query_api::
		pop	de			; return address
		pop	hl			; pointer to string
		push	hl			; restore...
		push	de			; ...stack
		push	af			; store a
		xor	a			; a=0, query api call
		rst	10			; will return pointer to api in hl
		pop	af			; resture a
		ret

		;; (linker documentation) where specific ordering is desired - 
		;; the first linker input  file should  have  the area definitions 
		;; in the desired order
		.area	_HOME
		.area	_CODE
	        .area   _GSINIT
	        .area   _GSFINAL	
		.area	_DATA
	        .area   _BSS
	        .area   _HEAP
		.area	_IM2

		;; this area contains data initialization code -
		;; unlike gnu toolchain which generates data, sdcc generates 
		;; initialization code for every initialized global 
		;; variable. and it puts this code into _GSINIT area
        	.area   _GSINIT
gsinit:
        	.area   _GSFINAL
        	ret

		.area	_BSS
