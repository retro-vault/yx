		;; video.s
		;; video memory manipulation routines
		;;
		;; tomaz stih, sun may 20 2012
		.module	video

		.globl	vid_rowaddr
		.globl	vid_plotxy
		.globl	vid_nextrow
		.globl	vid_vertline
		.globl 	vid_horzline

		.area	_CODE

		
		;; given y (0...191) calc. row addr. in vmem
		;; input:	b=y
		;; output:	hl=vmem address, a=l
		;; affects:	flags, a, hl
vid_rowaddr::
		ld	a,b		; get y0-y2 to acc.
		and	#0x07		; mask out 00000111
		or	#0x40		; vmem addr
		ld	h,a		; to h
		ld	a,b		; y to acc. again  
		rrca			
		rrca
		rrca
		and	#0x18		; y6,y7 to correct pos.
		or	h		; h or a
		ld	h,a		; store to h
		ld	a,b		; y back to a
		rla			; move y3-y5 to position
		rla	
		and	#0xe0		; mask out 11100000
		ld	l,a		; to l
		ret


		;; plot at x,y
		;; input:	b=y, c=x
		;; output:	hl=address, a=d=shifted value
		;; affects:	flags, a, b, c, d, l
vid_plotxy::
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


		;; given hl get next row address in vmem
		;; input:	hl=address
		;; output:	hl=next row address
		;; affects:	flags, a, c, h, l
vid_nextrow::
		inc	h
		ld	a,h
		and	#7
		jr	nz,nextrow_done
		ld	a,l
		add	a,#32
		ld	l,a
		jr	c, nextrow_done
		ld	a,h
		sub	#8
		ld	h,a
nextrow_done:
		ret
		

		;; vertical line
		;; input:	b=y0, c=x, e=y1, d=pattern (i.e. 01010101)
		;; affects:
vid_vertline::
		push	bc
		call	vid_plotxy	; draw first point
		pop	af		; a=y0, who cares for c
		cp	e		; y0==y1?
		jr	z,vl_done
vl_loop:
		inc	a		; y0=y0+1
		push	af
		call	vid_nextrow	
		ld	a,d		; bitmask
		or	(hl)
		ld	(hl),a		; write to vmem
		pop	af
		cp	e
		jr	nz,vl_loop
		
vl_done:
		ret	


		;; horizontal line
		;; inputs:	b=y, c=x0, d=x1, e=pattern (i.e. 0110110 for dashed)
vid_horzline::	
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
		and	e		; through mask
		or	(hl)		; merge with background
		ld	(hl),a		; and to the screen
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
		ld	a,c
		and	e		; mask it with pattern
		or	(hl)
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
