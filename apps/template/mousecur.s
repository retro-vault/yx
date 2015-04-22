		;; mousecur.s
		;; mouse cursor routines
		;;
		;; tomaz stih, wed apr 22 2015
		.module	mousecur

		.globl	cur_classic
		.globl	cur_std
		.globl	cur_hand		
		.globl	cur_hourglass
		.globl	cur_caret
		.globl	cur_drawxy

		.area	_CODE

		;; draw cursor at x,y
		;; input:	b=y, c=x, de=cursor
cur_drawxy::	
		call	vid_rowaddr	; hl=row address, a=l
		ld	b,c		; store x to b
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x	
		ld	a,b		; a=x0
		and	#0x07		; shifts
		ld	b,a		; b=counter for shifts
		ld	c,#10		; c=counter for rows

cur_row_loop:
		push	hl
		push	de		
		push	bc
		
		exx
		; 1. shift it
		pop	af		; a=b=shifts...
		pop	hl		; hl=cursor addr (former de)	
		ld	b,(hl)		; b=mask byte
		ld	c,#0xff		; c=mask byte+1	
		push	bc		; store cursor bytes
		inc	hl
		ld	b,(hl)		; b=cursor byte
		ld	c,#0		; c=cursor byte+1
		pop	de		; de=mask byte and byte+1

		cp	#0		; none?
		jr	z,cur_shft_done ; if 0 we dont shift	
cur_shft_loop:	
		srl	b
		rr	c
		scf			; carry for mask
		rr	d
		rr	e
		dec	a
		jr	nz,cur_shft_loop
cur_shft_done:
		; put to screen
		pop	hl
		; bc=cursor, de=mask
		ld	a,d		
		and	(hl)
		or	b
		ld	(hl),a
		inc	hl
		ld	a,e
		and	(hl)
		or	c
		ld	(hl),a
		exx

		; 2. loop
		inc	de
		inc	de
		call	vid_nextrow	; hl=next row
		dec	c
		jr	nz,cur_row_loop
		ret


		;; ===== CURSOR FORMAT =====
		;; size ... 8x10 pixels
		;; length ... 21 bytes 
		;; data:
		;; odd byte ... mask bits (AND background)
		;; even byte ... cursor bits (OR background)
		;; last byte is hotspot offset (high nibble=y, low nibble=x)

cur_classic::	;; classic mouse cursor
		.db	0b00111111
		.db	0b00000000
		.db	0b00011111
		.db	0b01000000
		.db	0b00001111
		.db	0b01100000
		.db	0b00000111
		.db	0b01110000
		.db	0b00000011
		.db	0b01111000
		.db	0b00000001
		.db	0b01111100
		.db	0b00000011
		.db	0b01110000
		.db	0b00000011
		.db	0b01011000
		.db	0b00100011
		.db	0b00001000
		.db	0b11110111
		.db	0b00000000
		.db	0x11		; offset y=1,x=1
		
cur_std::	;; default
		.db	0b11111111
		.db	0b11000000
		.db	0b00011111
		.db	0b10100000
		.db	0b00001111
		.db	0b10010000
		.db	0b00000111
		.db	0b10001000
		.db	0b00000011
		.db	0b10000100
		.db	0b00000001
		.db	0b10000010
		.db	0b00000011
		.db	0b10001100
		.db	0b00000011
		.db	0b10100100
		.db	0b10000011
		.db	0b01100100
		.db	0b11100111
		.db	0b00011000
		.db	0x11		; offset y=1,x=1
		
cur_hourglass::	;; wait cursor
		.db	0b00000001
		.db	0b11111110
		.db	0b10000011
		.db	0b01000100
		.db	0b10000011
		.db	0b01010100
		.db	0b11000111
		.db	0b00101000
		.db	0b11101111
		.db	0b00010000
		.db	0b11000111
		.db	0b00101000
		.db	0b10000011
		.db	0b01000100
		.db	0b10000011
		.db	0b01010100
		.db	0b00000001
		.db	0b11111110
		.db	0b11111111
		.db	0b00000000	
		.db	0x43		; offset y=4,x=3	
				
cur_caret::	;; caret (text) cursor
		.db	0b00100111
		.db	0b11011000
		.db	0b00000111
		.db	0b10101000
		.db	0b00000111
		.db	0b11011000
		.db	0b10001111
		.db	0b01010000
		.db	0b10001111
		.db	0b01010000
		.db	0b10001111
		.db	0b01010000
		.db	0b10001111
		.db	0b01010000
		.db	0b00000111
		.db	0b11011000
		.db	0b00000111
		.db	0b10101000
		.db	0b00100111
		.db	0b11011000
		.db	0x71		; offset y=7,x=1

cur_hand::	;; hand pointer
		.db	0b11011111
		.db	0b00100000
		.db	0b10001111
		.db	0b01010000
		.db	0b10000011
		.db	0b01011100
		.db	0b10000001
		.db	0b01010110
		.db	0b00000000
		.db	0b11010101
		.db	0b00000000
		.db	0b10010101
		.db	0b00000000
		.db	0b10000001
		.db	0b00000000
		.db	0b10000001
		.db	0b10000001
		.db	0b01000010
		.db	0b11000011
		.db	0b00111100
		.db	0x02		; offset y=0,x=2
