		;; glyph.s
		;; fast font routines
		;;
		;; tomaz stih, thu apr 23 2015
		.module	glyph

		.globl	cur_classic
		

		.area	_CODE

		;; put glyph of font at x,y
		;; input:	b=y, c=x, hl=font, a=char
		;; output:	hl=0 (success), hl=1 (fontgen error)
gyh_putxy::	
		; first get font info
		push	hl
		; alternate set for in-font calculations
		ex	af,af'		
		exx			
		pop	hl
		ld	a,(hl)		; get font generation/offset to raw data
		inc	hl
		ld	d,(hl)		; get first ascii
		inc	hl
		ld	e,(hl)		; get last ascii
		inc 	hl		
		; hl=font address (for fixed8x8 generation, i.e. gen 3)
		cp	#3
		jr	z,gyh_hl_fstart
		ld	b,(hl)		; b=bytes per glyph line
		inc	hl
		ld	c,(hl)		; c=glyph lines
		inc	hl
		; advance to gen. 7 start
		inc	hl
		inc	hl
		cp	#7
		jr	z,gyh_hl_fstart
		; font generation unknown
		exx
		ex	af,af'
		ld	hl,#1		; error!
		ret			
		; hl'=font start
		; de'=first and last ascii
		; bc'=bytes per glyph line and glyph lines
		; a=char
gyh_hl_fstart:	
		push	hl		; store font start
		ex	af,af'		
		cp	d		; char=char-first ascii
		jr	c,gyh_out_bounds		
		cp	e		; last char
		jr	z,gyh_bounds_ok	; still fine
		jr	nc,gyh_out_bounds
gyh_bounds_ok:
		; de' is now free
		sub	d		; a=a-first char ascii
		ld	e,a		; store a
		ld	a,b		; a=bytes per glyph line
		cp	#1		; is 1 byte glyph?
		jr	z,gyh_bytes_1
		cp	#2		; is 2 byte glyph
		jr	z,gyh_bytes_2
		; error!!!
		pop	hl		; clear stack
		exx
		ld	hl,#3		; error!
		ret
gyh_bytes_1:	
		ld	a,c
		jr	gyh_charoff
gyh_bytes_2:
		ld	a,c		; glyph lines to a
		sla	a		; a=a*2
gyh_charoff:	; a is glyph lines * bytes per glyph line
		; e is char nr.
		; hl = de * a
		push	bc		; store bytes per glyph and glyph lines
		ld	d,#0		; de=0 based char
    		ld 	hl,#0		; use HL to store the product
		ld	b,#8		; eight bits to check
gyh_mul:
		add	hl,hl
		rlca			; check MSB of a
		jr	nc,gyh_mul_skip ; if zero, skip addition
		add	hl,de
gyh_mul_skip:
		djnz	gyh_mul
		pop	bc		; bytes per glyph and glyph lines
		pop	de		; de=font start
		add	hl,de		; hl=char start
		jr	gyh_put
gyh_out_bounds:	
		pop	hl		; clear stack
		exx
		ld	hl,#2		; error!
		ret
gyh_put:	; hl'=actual glyph start
		; stack bc'...byte bytes per glyph, glyph lines
		push	hl		; glyph start to stack
		push	bc		; bytes per glyph, glyph lines
		exx			; normal reg set.
		pop	hl		; bytes per glyph, glyph lines
		pop	de		; addr. to de
		call	gyh_drawxy	; draw at x,y
		ret

		;; draw glyph at x,y
		;; input:	b=y
		;;		c=x
		;;		de=glyph addr
		;;		h=bytes per glyph
		;;		l=glyph lines
gyh_drawxy:	
		ret
