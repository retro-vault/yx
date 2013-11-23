		;; vector.s
		;; zx spectrum vectors
		;;
		;; note: _setvect is NOT guarded by ei/di!
		;;
		;; tomaz stih, sun may 20 2012
		.module vector

		.globl	_setvect
		.globl	_ei
		.globl	_di
	
		.area	_CODE
		;; disable interrupts with ref counting
_di::		di
		ld	hl,#dicount
		inc	(hl)
		ret

		;; enable interrupts with ref counting
_ei::		ld	a,(#dicount)
		or	a
		jr	z,do_ei			; if a==0 then just ei		
		dec	a			; if a<>0 then dec a
		ld	(#dicount),a		; write back to counter
		or	a			; and check for ei
		jr	nz,dont_ei		; not yet...
do_ei:		ei
dont_ei:	ret
	
		;; set vector
_setvect::	ld	iy,#0x0000
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

		.area   _GSINIT
		;; initialize lock count
		xor	a
		ld	(#dicount),a

		.area	_DATA
		;; enable/disable interrupt
dicount:	.ds	1
