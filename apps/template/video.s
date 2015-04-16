		;; video.s
		;; video memory manipulation routines
		;;
		;; tomaz stih, sun may 20 2012
		.module	video

		.globl	vid_rowaddr
		.globl	vid_plotxy
		.globl	vid_nextrow
		.globl	vid_vertline

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
		;; input:	b=y0, c=x, e=y1
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
