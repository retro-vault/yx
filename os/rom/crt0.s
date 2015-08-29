		;; crt0.s
		;; zx spectrum rom startup code
		;;
		;; tomaz stih, sun may 20 2012
		.module crt0

		.globl	_sys_vec_tbl
		.globl	_sys_stack
		.globl	_sys_heap
		.globl	_sys_tarpit

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
		ld	sp,#_sys_stack		; now sp to OS stack (on bss)		
		call	gsinit			; init static vars

		;; start the os
		call	_main			

		;; start the scheduler
		im	1			; im 1, 50Hz interrupt on ZX Spectrum
		ei				; enable interrupts

_sys_tarpit::
		halt				; halt
		jr	_sys_tarpit

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
		.area 	_INITIALIZER
		.area 	_INITFINAL
	        .area   _GSINIT
	        .area   _GSFINAL	
		.area	_DATA
		.area 	_INITIALIZED
	        .area   _BSS
	        .area   _HEAP

		;; static initialization
		.area	_INITIALIZER
init_rom_start:
		.area	_INITFINAL
init_rom_end:

		;; this area contains data initialization code -
		;; unlike gnu toolchain which generates data, sdcc generates 
		;; initialization code for initialized global 
		;; variables. and it puts this code into _GSINIT area
        	.area   _GSINIT
gsinit:
		;; move vector table to RAM
		ld	hl,#start_vectors
		ld	de,#_sys_vec_tbl
		ld	bc,#end_vectors - #start_vectors
		ldir

		;; init static vars
		ld	hl,#init_rom_end
		ld	de,#init_rom_start
		sbc	hl,de			; hl=hl-de
		ld	a,h
		or	l
		jr	z,no_statics		; no static vars!
		push 	hl
		pop	bc			; bc=hl
		ex	de,hl			; hl=init_rom_start
		ld	de,#init_ram_start
		ldir
no_statics:
        	.area   _GSFINAL
        	ret

		.area	_DATA
		;; vector jump table in ram
_sys_vec_tbl::
rst8:		.ds	3
rst10:		.ds	3
rst18:		.ds	3
rst20:		.ds	3
rst28:		.ds	3
rst30:		.ds	3
rst38:		.ds	3
nmi:		.ds	3

		.area	_INITIALIZED
init_ram_start:

		.area	_BSS
		;; 512 bytes of operating system stack
		.ds	512
_sys_stack::	
		.area	_HEAP
_sys_heap::	
