		;; vector.s
		;; vector graphics routines
		;;
		;; tomaz stih, sat jun 6 2015
		.module	vector

		.globl	_vector_plotxy
		.globl	_vector_vertline
		.globl 	_vector_horzline

		.area	_CODE


;; void vector_plotxy(byte x, byte y)
_vector_plotxy::
		pop	hl		; return address
		pop	bc		; x,y
		;; restore stack		
		push	bc
		push	hl
		;; plot at x,y RAW
		;; input:	b=y, c=x
		;; output:	hl=address, a=d=shifted value
		;; affects:	flags, a, b, c, d, l
vector_plotxy_raw::
		call	vid_rowaddr	; hl=row address, a=l
		ld	b,c		; store x to b
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x		
		ld	a,b		; return x to acc
		and	#0x07		; get bottom 3 bits
		jr	nz,vp_shift	; if 0 we dont shift
		ld	a,#0x80		; a=10000000
		jr	vp_shift_done
vp_shift:		
		ld	b,a		; b=counter
		ld	a,#0x80		; a=10000000
vp_loop:	srl	a
		djnz	vp_loop
vp_shift_done:
		ld	d,a		; store a
		or	(hl)		; merge bit with background
		ld	(hl),a
		ld	a,d		; restore a
		ret

;; void vector_vertline(byte x, byte y0, byte y1, byte pattern)
_vector_vertline::
		pop	hl		; ret addr.
		pop	bc		; x,y0
		pop	de		; y1,pattern
		;; restore stack
		push	de
		push	bc
		push	hl
		;; vertical line RAW
		;; input:	b=y0, c=x, e=y1, d=pattern (i.e. 01010101)
		;; affects:
vector_vertline_raw::
		ld	a,e		; a=y1
		sub	b		; a=y1-y0 ... counter
		ld	e,a		; counter to e
		inc	e		; e=y1-y0+1, 1 based counter
		; get first row address		
		call	vid_rowaddr	; hl=row address, a=l
		ld	b,c		; store x to b
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x		
		ld	a,b		; return x to acc
		and	#0x07		; get bottom 3 bits
		jr	nz,vl_shift	; if 0 we dont shift
		ld	a,#0x80		; a=10000000
		jr	vl_shift_done
vl_shift:	; shift mask	
		ld	b,a		; b=counter
		ld	a,#0x80		; a=10000000
vl_msk_loop:	srl	a
		rlc	d		; pattern
		djnz	vl_msk_loop
vl_shift_done:	; we have correct mask in a
		ld	b,e		; b=counter
		ld	c,a		; store a (mask)
vl_loop:	; to screen	
		and	d		; line pattern
		or	(hl)
		ld	(hl),a		; write to vmem
		rlc	d		; rotate pattern
		call	vid_nextrow	; hl=next row
		ld	a,c		; restore mask
		djnz	vl_loop						
vl_done:
		ret	


;; void vector_horzline(byte y, byte x0, byte x1, byte pattern)
_vector_horzline::
		pop	hl		; ret addr
		pop	bc		; c=y, b=x0
		pop	de		; e=x1, d=pattern
		;; restore stack
		push	de
		push	bc
		push 	hl		
		ld	a,b		; switch b and c
		ld	b,c
		ld	c,a		
		ld	a,d		; switch d and e
		ld	d,e
		ld	e,a
		;; horizontal line RAW
		;; inputs:	b=y, c=x0, d=x1, e=pattern (i.e. 0110110 for dashed)
vector_horzline_raw::	
		call	vid_rowaddr	; hl=row address, a=l		
		ld	b,c		; store x0 to b
		srl	c		; c=x0/8 (byte offset)
		srl	c
		srl	c	
		add	c
		ld	l,a		; hl is correct vmem byte
		ld	a,d		; a=x1
		srl	a		; a=x1/8
		srl	a
		srl	a
		sub	c		; a=x1-x0, a counts bytes until rmask
		jr	z,vhorz_single
vhorz_lmask:
		push	af		; store counter
		ld	a,b		; a=x0
		ld	c,#0xff		; c=11111111
		and	#0x07		; mask 00000111 (scroll counter)
		jr	z,vh_l_done	; left mask is aligned
vh_l_shift:	; we need to create the mask
		rrc	e		; shift mask
		srl	c		; shift
		dec	a
		jr	nz,vh_l_shift
vh_l_done:	; we have the mask
		ld	a,c		; to a
		cpl			; negate
		and	(hl)		; with screen
		ld	(hl),a		; and clear screen place
		ld	a,c
		and	e		; through mask
		or	(hl)		; or with cleared screen
		ld	(hl),a		; and back to the screen
vhorz_pad:	; now fill lines
		ld	c,e		; mask to c
		pop	af		; a=counter
vh_p_loop:		
		dec	a		; one down
		jr	z,vhorz_rmask
		inc	hl
		ld	(hl),c		; entire line
		jr	vh_p_loop
vhorz_rmask:	; right rmask
		inc	hl
		ld	c,#0xff		; c=11111111 (default mask)		
		ld	a,d		; a=x1
		and	#0x07		; lower 3 bits
		sub	#0x07		; full byte?
		jr	z,vh_r_done	; don't shift
vh_r_shift:	; right shift
		sla	c
		inc	a
		jr	nz,vh_r_shift
vh_r_done:	; put to vmem	
		ld	a,c		; line to a
		cpl			; invert
		and	(hl)		; with screen
		ld	(hl),a		; back to screen
		ld	a,c
		and	e		; apply mask
		or	(hl)		; or with scren
		ld	(hl),a
		jr	vhorz_done
vhorz_single:	; b=from, d=to (inside 1 byte at hl)
		ld	a,d		; a=x1
		ld	d,b		; store x0 to d
		ld	c,#0x80		; c is 10000000
		sub	b		; a=x1-x0
		jr	z,vh_single_2	; done?		
vh_single_loop:	; loop 
		scf
		rr	c
		dec	a
		jr	nz,vh_single_loop
vh_single_2:
		;	now shift x0 more times
		ld	a,d		; x0 
		and	#0x07		; get shift out 
vh_single_x0lp:	cp	#0		; a==0?
		jr	z,vh_single_put
		dec	a
		srl	c
		rrc	e		; line pattern too
		jr	vh_single_x0lp
vh_single_put:
		ld	a,c		; mask to a
		and	e		; line pattern
		or	(hl)		; or HL
		ld	(hl),a		; to vmem
vhorz_done:
		ret
		
