		;; crt0.s
		;; yx ram startup code
		;;
		;; tomaz stih, tue apr 9 2013
		.module crt0

		.globl	vectbl
		.globl	sysstack
		.globl	sysheap
		.globl	tarpit

		.area	_HEADER (ABS)
		di				; disable interrupts	
init:		
		ld	sp,#sysstack		; now sp to OS stack (on bss)		
		call	gsinit			; init static vars

		;; start the os
		call	_main		

		;; install IM2 handler
		ld	a,#0x39			; im2 trick
		ld	i,a
		ld	hl,#0xffff
		ld	(hl),#0x18		; jr upcode

		;; start the scheduler
		im	2			; im 2, 50Hz interrupt on ZX Spectrum
		ei				; enable interrupts

tarpit:
		halt				; halt
		jr	tarpit			

		;; TODO: rewire temporary handlers
syscall:
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
		;; 256 bytes of operating system stack
		.ds	256
sysstack::	
		.area	_HEAP
sysheap::	

		.area	_IM2
		;; vector jump table at 0xfff0
vectbl::
		jp	syscall			; fff0
		.db	0
		jp	_scheduler		; fff4 
		.db	0
