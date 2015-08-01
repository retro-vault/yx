		;; bitmap.s
		;; bitmap store and draw
		;;
		;; tomaz stih, sun may 20 2012
		.module	bitmap

		.globl	_bmp_get
		.globl	_bmp_put
		.globl	bmp_get_raw

		.area	_CODE

		
;; bitmap_t* bmp_get(rect_t *rect, void *mem)
_bmp_get::
		pop	hl		; ret. address
		pop	de		; rect
		pop	bc		; mem
		;; restore stack
		push	bc
		push	de
		push 	hl
		push	bc		; store memory
		ex	de,hl		; hl=rect
		ld	c,(hl)		; c=x0
		inc	hl
		ld	b,(hl)		; b=y0
		inc 	hl
		ld	d,(hl)		; d=x1
		inc	hl
		ld	e,(hl)		; e=y1
		pop	hl		; hl=bitmap_t *, prev. bc

		;; get bitmap data to 
		;; inputs:	b=y0, c=x0, d=x1, e=y1, hl=bitmap_t*
		;; output:	
		;; affects:	flags, af, af', hl, bc, de, de'
bmp_get_raw::
		push	hl		; store original bitmap_t *
		ex	af,af'		
		ld	a,c		; a=x0
		and	#0x07		; how many shifts 0..7
		ex	af,af'
		ld	a,d		; a=x1
		sub	c		; a=x1-x0
		ld	(hl),a		; pseudo width
		srl	a		; a=a/8
		srl	a		; will give
		srl	a		; number of bytes req. to store row
		ld	d,a		; store to d
		inc	hl
		ld	a,e		; a=y1
		sub	b		; a=y1-x1
		ld	(hl),a		; pseudo height
		inc	hl		; hl now points to start of bmp data
		push	hl		; store start of bmp data + 2
		call	vid_rowaddr	; hl=row address, a=l
		srl	c		; c=x0/8 (byte align)
		srl	c
		srl	c	
		add	c
		ld	l,a		; hl is correct vmem byte, c=byte aligned x0
		;; calc y diff
		ld	c,d		; c=diff in bytes
		ld	a,e		; a=y1
		sub	b		; a=y1-y0
		inc	a		; 1 based		
		;; a=ydiff (1 based), c=xdiff (0 based)
		exx			; alt set for addresses
		pop	de		; de'=start of bmp data (ex. hl)
		exx
		push	hl		; store start of row
		ld	b,a		; b=row counter
bmp_g_rowloop:	;; row loop
		push	bc		; store row and col counter		
bmp_g_colloop:	;; column loop
		;; shifting
		ld	d,(hl)		; d=first
		inc	hl		; next screen col
		ld	e,(hl)		; e=next
		ex	af,af'		
		push	af		; store counter
		cp	#0
		jr	z,bmp_g_s_done
bmp_g_shft:	;; do the shift
		sla	e
		rl	d
		dec	a
		jr	nz,bmp_g_shft
bmp_g_s_done:	;;	d,e has shifted data
		pop	af		; restore counter
		ex	af,af'		
		ld	a,d		; d to a
		exx
		ld	(de),a
		inc	de
		exx
		dec	c
		jp	p,bmp_g_colloop
		pop	bc		; return col counter
		pop	hl		; get start of row
		call	vid_nextrow	; next row addr
		push	hl		; row address
		djnz	bmp_g_rowloop
		pop	hl		; clean last row address
		pop	hl		; original bitmap_t* value as ret value
		ret



;; void bmp_put(void *data, byte x, byte y, byte rows, byte cols, byte shift, byte skip)
_bmp_put::
		push	ix		; store ix
		ld	ix,#0		; ix =
		add	ix,sp		; = sp
		;; first arg. is at 4(ix)
		inc	8(ix)		; make rows 1 based (0 is 1)
		exx			; alt set on
		ld	b,7(ix)		; b'=y
		call	vid_rowaddr	; get vmem row address
		ld	c,6(ix)		; c'=x
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; a=a+c', we know this wont overflow
		ld	l,a		; hl' has the correct vmem address
		push	hl		; store vmem row start
		ld	e,4(ix)		; de' =
		ld	d,5(ix)		; = *data
		ex	de,hl		; hl'=src, de'=dst
		exx			; alt set off
bp_rows:	;; rows loop
		ld	a,6(ix)		; a=x
		and	#0x07		; left bit offset
		ld	c,a		; to c
		ld	a,10(ix)	; a=shifts
		ld	b,9(ix)		; b=bits
		call	shift_copy
		exx			; alt set on
		ex	de,hl		; skip src and dest.
		ld	h,#0		; hl=skip
		ld	l,11(ix)	; -"-
		add	hl,de		; skip dest. bytes
		ex	de,hl		; to de
		pop	hl		; get vmem back
		call	vid_nextrow	; next row
		push	hl		; new row start to stack
		ex	de,hl		; hl=src, de=dest, once again
		exx			; alt set off
		dec	8(ix)		; dec rows
		jr	nz,bp_rows	; repeat
		pop	hl		; get last hl off the stack
		pop	ix		; restore ix
		ret

		
		;; shift and copy
		;; shifts line N bits and copies it to destination 
		;; inputs:	
		;;	hl'	source address
		;;	de'	destination address
		;;	a	num. shifts right
		;;	b	total bits (0 based)
		;;	c	left bit offset (0..7)
		;; output:	
		;;	hl	next byte
		;;	de	next byte
		;; affects:
		;;	just about everything else
shift_copy::	
		push	af		; store shifts
		push	bc		; store bits and offset
		ld	de,#0xffff	; full mask
		ld	a,c		; left offset
		cp	#0		; no left offset?
		jr	z,sc_noloff
		;; create left mask
		ld	a,#0		; initial lmask=0
sc_loffs:
		scf			; set carry
		rr	a		; bit to d
		dec	c
		jr	nz,sc_loffs
		cpl			; a has the correct (negated) mask now
		ld	d,a		; store first mask to d
sc_noloff:	;; create right mask
		pop	bc		; get bits and offset
		push	bc		; and back
		ld	a,b
		add	c
		ld	c,#0xff		; initial rmask=0xff
		and	#7		; just reminder of div. by 8
		jr	z,sc_maskdone
		ld	c,#0x80		; build a mask
sc_roffs:	
		scf			; set carry
		rr	c		; into mask
		dec	a
		jr	nz,sc_roffs
		ld	e,c
sc_maskdone:
		pop	bc		; bits and offset
		ld	a,#7		; 7 bits (0 based)
		sub	c		; minus offset
		cp	b		; compare to total bits
		jr	z,sc_single	; exact match
		jr	nc,sc_single	; single byte
sc_multi:	;; multi bytes copy
		;; 1. first byte
		pop	af		; get number of shifts
		push	af		; and back to stack
		push	bc		; bits and offset
		push	de		; mask on stack too
		exx
		call	sc_shift_reg	; shift value to a
		pop	bc		; get masks
		and	b		; (hl) and b
		ld	c,a		; a to c
		ld	a,b		; mask to b
		cpl			; complement
		ld	b,a		; new mask to b
		ld	a,(de)		; destination
		and	b		; with new mask
		or	c		; value	
		ld	(de),a		; copy value
		inc	hl		; next src byte
		inc	de		; next dst byte
		exx
				
		;; 2. mid bytes
		pop	bc
		ld	a,#7		; 7 bits (0 based)
		sub	c		; minus offset
		ld	c,a		; store to c
		ld	a,b		; get bits
		sub	c		; we've just consumed c bits
		ld	b,a		; remainder to b
sc_m_more:	
		cp	#8		; more then 8 bits left?
		jr	c,sc_m_last	; 8 bits left
		jr	z,sc_m_last	; 8 bits left
		pop	af		; number of shifts
		push	af		; and back to stack
		ex	af,af'	
		ld	d,a		; d will no longer be needed
		ex	af,af'
		push	de		; store mask and reminder
		exx			; alt set on
		call	sc_shift_reg	; shift it all
		pop	bc		; restore b=d
		or	b		; reminder from prev. shift
		ld	(de),a
		inc	hl
		inc	de
		exx			; alt set off
		ld	a,b		; counter back to a
		sub	#8		; we consumed 8
		jr	sc_m_more	; repeat
		
sc_m_last:	;; 3. last byte
		pop	af		; restore shifts to a
		ex	af,af'
		ld	d,a		; d=a'
		ex	af,af'
		push	de		; d=reminder, e=rmask
		exx
		call	sc_shift_reg	; shift it
		pop	bc		; b=a',c=end mask
		or	b		; add reminder		
		and	c		; mask it
		ld	b,a		; store value
		ld	a,c		; mask to a
		cpl			; complement
		ex	de,hl		; hl=de
		and	(hl)		; and compl. mask
		or	b		; or bitmap
		ld	(hl),a		; write to mem
		inc	hl		; next
		inc	de		; next
		ex	de,hl		; rev. to previous
		exx
		ret
sc_single:	;; single byte copy
		pop	af		; restore shifts to a
		push	de		; store rmask and lmask
		exx			; alt set on
		;; first shift value		
		call	sc_shift_reg
		;; now copy, a has hl!		
		pop	bc		; get rmask and lmask
		and	b		; apply mask...
		and	c		; over a
		push	af		; store a
		ld	a,b		; create one mask...
		and	c		; ...in a
		cpl			; negate mask
		ex	de,hl		; hl=de
		and	(hl)		; clear target
		pop	bc		; b = bitmap value
		or	b		; bitmap value
		ld	(hl),a		; put to destionation
		inc	hl		; next
		inc	de		; next
		ex	de,hl		; rev. back
		exx			; alt set off
		ret

		;; shift value (hl), number of shifts is hi word of stack word
		;; input:
		;;	a	number of shifts
		;;	hl	memory location to shift
		;; output:
		;;	a	shifted byte
		;;	a'	overflow
		;; affects:
		;;	af, af', bc
sc_shift_reg:	
		ex	af,af'
		xor	a		; initial overflow is 0
		ex	af,af'
		cp	#0		; a==0?
		jr	z,sc_shift_none	; go to no shifts
		ld	c,a		; number of shifts
		ld	b,(hl)		; b=value
		xor	a		; a=remainder
sc_shift_it:	
		srl	b		; b to the right
		rra			; and to a
		dec	c
		jr	nz,sc_shift_it
		push	af		; a to stack
		ex	af,af'
		pop	af		; a to a'
		ex	af,af'
		ld	a,b		; a=main value
		ret
sc_shift_none:
		ld	a,(hl)		; a=hl
		ret
