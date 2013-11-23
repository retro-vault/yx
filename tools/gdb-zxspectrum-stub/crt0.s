	;; gdb monitor crt0.s for a Z80
        .module crt0
       	.globl	_main
        .globl  _sr

	.area	_HEADER (ABS)
	;; Reset vector
	.org 	0x0000
	di
	jp	init
	.db	0,0,0,0	
	
	;; RST 08
        push    hl               
        ld      hl,#0x08         
        jp      _sr    
	.db	0          

	;; rst 10
        push    hl
        ld      hl,#0x10
        jp      _sr
	.db	0 

	;; rst 18
        push    hl
        ld      hl,#0x18	;; RST 18, used for breakpoints
        jp      _sr		;; 18 means a breakpoint was hit, pass it to sr routine
	.db	0 

	;; rst 20
        push    hl
        ld      hl,#0x20
        jp      _sr
	.db	0 	

	;; rst 28
        push    hl
        ld      hl,#0x28
        jp      _sr
	.db	0 	

	;; rst 30
        push    hl
        ld      hl,#0x30
        jp      _sr	
	.db	0 

	;; rst 38
        reti
	.dw	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	
	;; NMI
        push    hl
        ld      hl,#0x66
        jp      _sr 

init:
	;; Stack at the top of memory.
	ld	sp, #0x6000

        ;; Initialise global variables
        call    gsinit
	call	_main
	
	ei			; enable interrupts.
	jp	_exit

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
        .area   _GSINIT
        .area   _GSFINAL

	.area	_DATA
        .area   _BSS
        .area   _HEAP


        .area   _CODE
__clock::
	ld	a,#2
        rst     0x18
	ret

_exit::
	;; Exit - special code to the emulator
	ld	a,#0
        rst     0x18
1$:
	halt
	jr	1$

        .area   _GSINIT
gsinit::
	
        .area   _GSFINAL
        ret
        
