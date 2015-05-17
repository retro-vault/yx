		;; bitmap.s
		;; bitmap store and draw
		;;
		;; tomaz stih, sun may 20 2012
		.module	bitmap

		.globl	bmp_get
		.globl	bmp_put

		.area	_CODE

		
		;; get bitmap data to 
		;; inputs:	b=y0, c=x0, d=x1, e=y1, hl=bitmap_t*
		;; output:	
		;; affects:	flags, af, af', hl, bc, de, de'
bmp_get::
		ex	af,af'		
		ld	a,c		; a=x0
		and	#0x07		; how many shifts 0..7
		ex	af,af'
		ld	(hl),d		; x1...right edge
		inc	hl
		ld	(hl),e		; y1...bottom edge
		inc	hl		; hl now points to start of bmp data
		push	hl		; store start of bmp data
		call	vid_rowaddr	; hl=row address, a=l
		srl	c		; c=x0/8 (byte align)
		srl	c
		srl	c	
		add	c
		ld	l,a		; hl is correct vmem byte, c=byte aligned x0
		ld	a,d		; a=x1
		srl	a		; a=x1/8
		srl	a
		srl	a
		sub	c		; a=x1-x0, a counts bytes, 0 based!
		;; calc y diff
		ld	c,a		; store a
		ld	a,e		; a=y1
		sub	b		; a=y1-y0
		inc	a		; 1 based		
		;; a=ydiff (1 based), c=xdiff (0 based)
		exx			; alt set for addresses
		pop	de		; de'=target address
		exx
		push	hl		; store start of row
		ld	b,a		; b=row counter
bmp_g_rowloop:	;; row loop
		push	bc		; store row and col counter		
bmp_g_colloop:	;; column loop
		;; shifting
		ld	d,(hl)		; d=first
		inc	hl		; next screen row
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
		push	hl
		djnz	bmp_g_rowloop
		pop	hl		; clean stack
		ret

		;; put bitmap data 
		;; inputs:	b=y0, c=x0, hl=bitmap_t*
		;; output:	
		;; affects:	flags, af, af', hl, bc, de, de'
		;; known bug:	passing screen boundary
bmp_put::	
		;; 1. how many shifts?
		ex	af,af'		
		ld	a,c		; a'=x0
		and	#0x07		; a'=#shifts (0..7)
		ex	af,af'
		;; 2. get row byte count
		ld	a,(hl)		; a=x1
		srl	a		; a=x1/8 (byte align)
		srl	a
		srl	a		; a=0 based col byte count
		ld	e,a		; e=col byte count
		inc	hl		
		ld	d,(hl)		; d=row count (0 based)
		inc	d		; make it 1 based
		inc	hl		; hl=start of bitmap data
		;; de=row and line count, hl=bitmap data
		push	hl		; store start of bmp
		exx			; alt set for addresses
		pop	hl		; hl'=target address
		exx
		;; calculate hl=vmem addr
		call	vid_rowaddr	; hl=row address, a=l
		srl	c		; c=x0/8 (byte align)
		srl	c
		srl	c	
		add	c
		ld	l,a		; hl is correct vmem byte, c=byte aligned x0
		push	hl		; vmem address
bmp_p_rowloop:	;; row loop
		push	de		; store counters
bmp_p_colloop:	
		;; shifting
		exx			; alt set
		ld	b,#0		; shift mask
		ld	d,(hl)		; d'=first
		inc	hl		; next data row
		ld	e,(hl)		; e'=next
		ex	af,af'		
		push	af		; store counter
		cp	#0
		jr	z,bmp_p_s_done
bmp_p_shft:	;; do the shift		
		srl	d
		rr	e
		scf			; set carry
		rr	b		; b=mask
		dec	a
		jr	nz,bmp_p_shft
bmp_p_s_done:	;;	d,e has shifted data
		pop	af		; restore counter
		ex	af,af'		
		ld	a,b		; mask to a
		push	bc
		push	de		; push [i] and [i+1]
		exx
		pop	bc		; get de
		and	(hl)		; a or vid memory		
		or	b
		ld	(hl),a		; to video memory
		inc	hl
		pop	af		; a=old b
		dec	e		; dec col byte counter
		jp	p,bmp_p_cont
		jr	bmp_p_done	
bmp_p_cont:
		cpl
		and	(hl)
		or	c
		ld	(hl),a
		jr	bmp_p_colloop
bmp_p_done:
		pop	de		; return col counter
		pop	hl		; get start of row
		call	vid_nextrow	; next row addr
		push	hl
		dec	d
		jr	nz,bmp_p_rowloop
		pop	hl		; clean stack
		ret
