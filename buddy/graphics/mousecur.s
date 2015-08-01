		;; mousecur.s
		;; mouse cursor routines
		;;
		;; tomaz stih, wed apr 22 2015
		.module	mousecur

		.globl	_mouse_show_cursor
		.globl	_mouse_hide_cursor

		.globl	_cur_classic
		.globl	_cur_std
		.globl	_cur_hand		
		.globl	_cur_hourglass
		.globl	_cur_caret

		.area	_CODE

		;; store bytes under cursor
		;; input:	b=y, c=x
		;; affects:	hl, bc, de, a
mouse_store_bg:	
		ld	hl,#cur_bg
		ld	(hl),c		; store x
		inc	hl
		ld	(hl),b		; store y
		inc	hl
		push	hl		; data address
		call	vid_rowaddr	; hl=row address, a=l	
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x		
		ld	b,#10		; c=counter for rows
		pop	de		; de=data addres
msb_loop:	
		ld	a,(hl)		; get vmem byte
		ld	(de),a		; to de
		inc	hl		; next byte (dont care about clipping)
		inc	de		; next byte in memory
		ld	a,(hl)		; byte 2 from vmem
		ld	(de),a		; to memory
		dec 	hl		; hl back
		inc	de		; mem forward
		call	vid_nextrow	; hl=next row
		djnz	msb_loop	; loop
		ret


		;; extern void mouse_hide_cursor();
_mouse_hide_cursor::
		;; restore background
		;; input:	(cur_bg)
mouse_restore_bg:
		ld	hl,#cur_bg	; get background
		ld	c,(hl)		; restore x
		inc	hl		; next
		ld	b,(hl)		; restore y
		inc	hl		; hl=data
		push	hl		; store addr.
		;; c=x, b=y
		ld	a,#192		; max y + 1, ignore >192 values
		sub	b		; minus y (i.e. 1 px for y=191)
		cp	#10		; compare to 10
		jr	c,mrb_rows_done	; rows in a
		ld	a,#10		; else 10
mrb_rows_done:	
		ld	d,a		; store clipped row counter to d
		ld	e,#1		; assume 1 col
		ld	a,#255		; max a
		sub	c		; minus x
		cp	#8		; has to be >=8
		jr	c,mrb_onecol	; one column
		ld	e,#2		; two cols
mrb_onecol:
		call	vid_rowaddr	; hl=row address, a=l	
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x	
		ld	b,d		; b=row counter
		pop	de		; data to de
mrb_loop:	
		ld	a,(de)		; from memory
		ld	(hl),a		; to vmem
		inc	hl
		inc	de
		ld	a,e
		cp	#1		; one col?
		jr	z,mrb_nonext	; yes...
		ld	a,(de)
		ld	(hl),a
mrb_nonext:
		dec	hl		; screen back
		inc	de		; data forward
		call	vid_nextrow	; hl=next row
		djnz	mrb_loop	; loop
		ret


		;; extern void mouse_show_cursor(byte x, byte y, void *cursor);
_mouse_show_cursor::
		pop	hl		; return address
		pop	bc		; c=x,b=y
		;; restore stack
		push	bc
		push	hl
		;; store background
		call	mouse_store_bg
		pop	hl		; ret addr.
		pop	bc		; c=x,b=y
		pop	de		; de=cursor
		;; restore stack (again)
		push	de
		push	bc
		push	hl
		
		push	de		; and store cursor addr.

		;; draw clipped cursor at x,y
		;; input:	b=y, c=x, de=cursor
cur_drawxy:	
		ld	a,#192		; max y + 1, ignore >192 values
		sub	b		; minus y (i.e. 1 px for y=191)
		cp	#10		; compare to 10
		jr	c,cdr_rows_done	; rows in a
		ld	a,#10		; else 10
cdr_rows_done:	
		ld	e,a		; store clipped row counter to e
		ld	d,#1		; assume 1 col
		ld	a,#255		; max a
		sub	c		; minus x
		cp	#8		; has to be >=8
		jr	c,cdr_cols_done	; one column
		ld	d,#2		; two cols
cdr_cols_done:	;; at this point d=rows, e=cols
		push	de		; store rows and cols
		call	vid_rowaddr	; hl=row address, a=l
		ld	b,c		; store x to b
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x	
		ld	a,b		; a=x0
		and	#0x07		; shifts
		pop	bc		; b=cols, c=rows
		ex	af,af'	
		ld	a,b		; store cols to a'
		ex 	af,af'
		ld	b,a		; b=counter for shifts
		pop	de		; cursor data

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
		; should we do another?
		ex	af,af'
		cp	#1
		jr	z,cdr_nomore
		ld	a,e
		and	(hl)
		or	c
		ld	(hl),a
cdr_nomore:	
		ex	af,af'
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

_cur_classic::	;; classic mouse cursor
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
		
_cur_std::	;; default
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
		
_cur_hourglass::	;; wait cursor
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
				
_cur_caret::	;; caret (text) cursor
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

_cur_hand::	;; hand pointer
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

		.AREA	_BSS
cur_bg:		.ds	22		; 0...x, 1...y and 20 bytes ... for background
