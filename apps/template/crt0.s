			;;	crt0.c
			;;	zx spectrum ram startup code
			;;
			;;	tomaz stih sun may 20 2012
			.module crt0
			.globl _get_heap

			.area _HEADER(ABS)
	
			ld (#store_sp),sp		; store SP
			ld sp,#stack
			call gsinit				; init static vars (sdcc style)

			;; start the os
			call _main			

			ld sp,(#store_sp)		; restore original SP
			ret	

_get_heap::	ld hl,#heap
			ret

			;;	(linker documentation:) where specific ordering is desired - 
			;;	the first linker input file should have the area definitions 
			;;	in the desired order
			.area _HOME
			.area _CODE
	        .area _GSINIT
	        .area _GSFINAL	
			.area _DATA
	        .area _BSS
	        .area _HEAP

			;;	this area contains data initialization code -
			;;	unlike gnu toolchain which generates data, sdcc generates 
			;;	initialization code for every initialized global 
			;;	variable. and it puts this code into _GSINIT area
        	.area _GSINIT
gsinit:	
        	.area _GSFINAL
        	ret

			.area _DATA

			.area _BSS
store_sp:	.word 1

			;; 1024 bytes of operating system stack
			.ds	1024
stack:	
			.area _HEAP
heap: