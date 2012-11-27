		;; crt0.s
		;; zx spectrum rom startup code
		;;
		;; tomaz stih, sat jun 16 2012

		.module crt0

		.area	_HEADER (ABS)
		.org	0x0000
		di				; disable interrupts
		jp	init			; init
		.db	0,0,0,0			

		;; rst 0x08
		jp	rst8
rst8ret:	reti
		.db	0,0,0

		;; rst 0x10
		jp	rst10
rst10ret:	reti
		.db	0,0,0

		;; rst 0x18
		jp	rst18
rst18ret: 	reti
		.db	0,0,0

		;; rst 0x20
		jp	rst20
rst20ret:	reti
		.db	0,0,0

		;; rst 0x28 
		jp	rst28
rst28ret:	reti
		.db	0,0,0

		;; rst 0x30
		jp	rst30
rst30ret:	reti
		.db	0,0,0

		;; rst 0x38 - im 1
		jp	rst38
rst38ret:	reti
		.dw	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
		.db	0
	
		;; nmi interrupt 0x66
		jp	nmi
nmiret:		retn
		
init:		
		ld	sp,#osstack		
		call	gsinit			; init static vars

		;; start the os
		call	_main			

		;; start the scheduler
		im	1			; im 1, 50Hz interrupt on ZX Spectrum
		ei				; enable interrupts

halt:
		halt				; halt
		jr	halt			

start_vectors:
		jp	rst8ret
		jp	rst10ret
		jp	rst18ret
		jp	rst20ret
		jp	rst28ret
		jp	rst30ret
		jp	rst38ret
		jp	nmiret
end_vectors:

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

		;; this area contains data initialization code -
		;; unlike gnu toolchain which generates data, sdcc generates 
		;; initialization code for every initialized global 
		;; varibale. and it puts this code into _GSINIT area
        	.area   _GSINIT
gsinit:
		;; move vector table to RAM
		ld	hl,#start_vectors
		ld	de,#vec_tbl
		ld	bc,#end_vectors - #start_vectors
		ldir
		
        	.area   _GSFINAL
        	ret

		.area	_DATA
		;; vector jump table in ram
vec_tbl:
rst8:		.ds	3
rst10:		.ds	3
rst18:		.ds	3
rst20:		.ds	3
rst28:		.ds	3
rst30:		.ds	3
rst38:		.ds	3
nmi:		.ds	3

		.area	_BSS
		;; 1024 bytes of operating system stack
		.ds	1024
osstack:	
		.area	_HEAP
osheap:	
