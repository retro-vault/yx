		;; interrupts.s
		;; zx spectrum interrupts
		;;
		;; note: _intr_set_vect is NOT guarded by ei/di!
		;;
		;; tomaz stih, sun may 20 2012
		.module interrupts

		.globl	_intr_di_refcount
		.globl	_intr_set_vect
		.globl	_intr_enable
		.globl	_intr_disable
	
		.area	_CODE


		;; ---------------------------
		;; extern void intr_disable();
		;; ---------------------------
_intr_disable::		
		di
		ld	hl,#_intr_di_refcount
		inc	(hl)
		ret


		;; --------------------------
		;; extern void intr_enable();
		;; --------------------------
_intr_enable::		
		ld	a,(#_intr_di_refcount)
		or	a
		jr	z,do_ei			; if a==0 then just ei		
		dec	a			; if a<>0 then dec a
		ld	(#_intr_di_refcount),a	; write back to counter
		or	a			; and check for ei
		jr	nz,dont_ei		; not yet...
do_ei:		
		ei
dont_ei:	
		ret
	

		;; -----------------------------------------------------------
		;; extern void intr_set_vect(void (*handler)(), byte vec_num);
		;; -----------------------------------------------------------
_intr_set_vect::	
		pop	hl			; ret address / ignore
		pop	bc			; bc = handler
		pop	de			; d = undefined, e = vector number
		;; restore stack
		push	de
		push	bc
		push	hl
		ld	d,#0x00			; de = 16 bit vector number
		ld	hl,#_sys_vec_tbl	; vector table start
		add	hl,de
		add	hl,de
		add	hl,de
		inc	hl			; hl = hl + 3 * de + 1
		;; hl now points to vector address in RAM		
		;; so set it to handler value in bc
		ld	(hl),c
		inc	hl
		ld	(hl),b
		ret



		.area _INITIALIZED
_intr_di_refcount:
		.ds	1


		.area _INITIALIZER
__xinit__intr_di_refcount:
		.byte	0
		.area _CABS (ABS)
