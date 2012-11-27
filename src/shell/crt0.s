		;; crt0.s
		;; zx spectrum rom startup code
		;;
		;; tomaz stih, sun may 20 2012

		.module crt0

		.globl	_ei
		.globl	_di
		.globl	_get_heap
		.globl	_set_vector

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
		ld	sp,#osstack		; now sp to OS stack (on bss)		
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

		;; disable interrupts with ref counting
_di::		di
		ld	hl,#dicount
		inc	(hl)
		ret

		;; enable interrupts with ref counting
_ei::		ld	a,(#dicount)
		or	a
		jr	nz,dont_ei
		ei
		ret
dont_ei:	dec	a
		ld	(#dicount),a
		ret
		
_set_vector::	ld	iy,#0x0000
		add	iy,sp			; sp to iy
		ld	e,2(iy)			; vector num to ...
		ld	d,#0			; ... hl
		ld	hl,#vec_tbl
		add	hl,de			; hl=hl + 3 * de + 1
		add	hl,de
		add	hl,de
		inc	hl
		;; hl now points to vector address in RAM		
		;; so set it to value
		ld	a,3(iy)
		ld	(hl),a
		inc	hl
		ld	a,4(iy)
		ld	(hl),a
		;; and now call init function if provided
		ld	l,5(iy)
		ld	a,6(iy)
		or	l			; do we have an init function?
		jr	z,no_init_fn
		ld	h,a			; address to hl
		push	hl			; make it return address on stack
		ret				; and jump to it
no_init_fn:
		ret

_get_heap::	ld	hl,#osheap
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
		
		xor	a			; a=0
		ld	(#dicount),a		; write to dicount

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

		;; enable/disable interrupt
dicount:	.ds	1

		.area	_BSS
		;; 256 bytes of operating system stack
		.ds	256
osstack:	
		.area	_HEAP
osheap:	
