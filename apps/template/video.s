		;; video.s
		;; video memory manipulation routines
		;;
		;; tomaz stih, sun may 20 2012
		.module	video

		.globl	vid_rowaddr
		.globl	vid_nextrow

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


		;; given hl get next row address in vmem
		;; input:	hl=address
		;; output:	hl=next row address
		;; affects:	flags, a, hl
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



		
