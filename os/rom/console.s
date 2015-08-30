		;; console.s
		;; basic console functions
		;;
		;; tomaz stih, wed aug 26 2015
		.module	console

		.globl	_con_putcharxy
		.globl	_con_puts
		.globl	_con_clrscr
		.globl	_con_scroll_up
		.globl	_con_back
		.globl	_con_x
		.globl	_con_y
		
		BLACK	=	0x00
		GREEN	=	0x04

		WIDTH	=	0x06
		HEIGHT	=	0x06
		XMAX	=	246	
		YMAX	=	186

		BDRPORT	=	0xfe
		VMEMBEG	=	0x4000	
		ATTRSZE	=	0x02ff
		VMEMSZE	=	0x1800
		SCRROW6	=	0x4600	; screen row 6
		BYTSROW	=	32	; bytes per screen row

		FASCII	=	32
		LF	=	0x0A
		CR	=	0x0D

		.area	_CODE


		;; ------------------------------------------------------
		;; extern void con_putcharxy(byte x, byte y, byte ascii);
		;; ------------------------------------------------------
_con_putcharxy::
		pop	hl		; get return address
		pop	bc		; c=x, b=y
		pop	de		; e=ascii
		;; now restore stack
		push	de
		push	bc
		push	hl
putcharxy:	;; raw method needs c=x, b=y, e=ascii
		;; clip 1 byte?
		ex	af,af'
		ld	a,c		; a'=x
		cp	#(XMAX+2)
		jr	c,no_clip
		ld	a,#1
		jr	pc_main
no_clip:
		xor	a
pc_main:
		ex	af,af'
		;; make hl point to correct character
		ld	a,e
		sub	#FASCII		; minus first ascii
		ld	h,#0		; high=0
		ld	l,a		; char
		push	hl		; store hl
		add	hl,hl		; hl=hl*2
		add	hl,hl		; hl=hl*4
		pop	de		; de=original hl
		add 	hl,de		; hl=hl*5
		ex	de,hl		; de=hl
		ld	hl,#_con_font6x6	
		add	hl,de		; hl points to correct char
		ex	de,hl		; de=start of char
		;; vmem start
		call	vid_rowaddr	; hl=row address in video memory
		ld	b,c		; store x to b
		srl	c		; x=x/8 (byte offset)
		srl	c
		srl	c	
		add	c		; l=l+c, we know this wont overflow
		ld	l,a		; hl has the correct byte for x		
		ld	a,b		; return x to acc
		and	#0x07		; get bottom 3 bits (shift right)
		;; at this point
		;; de=char start
		;; hl=vmem start
		;; a=shifts
		ld	c,a		; num shift
		push	bc
		ex	de,hl		; easier to calculate
		;; scan line 0
		ld	a,(hl)		; data
		call	pch_to_screen
		;; scan line 1
		ld	a,(hl)		; data
		inc	hl
		ld	b,(hl)		; data byte 2
		srl	a
		rr	b
		srl	a
		rr	b
		ld	a,b		; a=data
		call	pch_to_screen
		;; scan line 2
		ld	a,(hl)		; data
		inc	hl
		ld	b,(hl)		; data
		sla	b		; shift 4xleft
		rl	a
		sla	b
		rl	a
		sla	b
		rl	a
		sla	b
		rl	a		; a=data
		call	pch_to_screen
		;; scan line 3
		ld	a,(hl)		; data
		inc	hl		; next char byte
		sla	a		; 2x left
		sla	a		; a=data
		call	pch_to_screen
		;; scan line 4
		ld	a,(hl)		; data
		call	pch_to_screen
		;; scan line 5
		ld	a,(hl)		; data
		inc	hl
		ld	b,(hl)		; data byte 2
		srl	a
		rr	b
		srl	a
		rr	b
		ld	a,b		; a=data
		call	pch_to_screen
		pop	bc
		ret
pch_to_screen:
		;; a=data
		;; de=vmem address
		exx			; temp
		pop	hl		; ret address
		exx
		pop	bc		; get num shifts into c
		push	bc		; restore stack
		exx
		push	hl		; ret address back
		exx
		ex	de,hl		; hl=vmem address
		push	de		; ...will need it later
		ld	de,#0x03ff	; mask
		and	#0xfc		; cut data
		ld	b,a		; store data to b
		ld	a,c		; a=num shifts
		cp	#0		; no shifts?
		jr	z,pch_sh_done	; shift is done
		ld	c,#0x00		; c=0
pch_shift:
		srl	b		; shift data
		rr	c		; 16 bits
		scf			; carry
		rr	d		; shift mask
		rr	e		; and data
		dec	a		; a=a-1
		jr	nz,pch_shift	; shift on
pch_sh_done:
		ld	a,d		; first mask to a
		and	(hl)		; mask AND screen
		or	b		; OR data
		ld	(hl),a		; back to screen
		ex	af,af'
		or	a		; clip?
		jr	nz,pch_skip2	; skip byte 2
		ex	af,af'
		inc	hl		; next byte
		ld	a,e		; second mask
		and	(hl)		; mask AND screen
		or	c		; and data
		ld	(hl),a		; to screen
		dec	hl		; vmem pointer back
		jr	pch_no_alt
pch_skip2:	
		ex	af,af'
pch_no_alt:
		call	vid_nextrow	; next row
		pop	de		; restore de
		ex	de,hl		; toggle de and hl
		ret


		;; -------------------------
		;; extern void con_clrscr();
		;; -------------------------
_con_clrscr::
		ld	a,#BLACK
		out	(#BDRPORT),a	; set border to black
		;; prepare attr
		rlca			; bits 3-5 
		rlca
		rlca	
		or	#GREEN		; ink color to bits 0-2
		;; first vmem
		ld	hl,#VMEMBEG	; vmem
		ld	bc,#VMEMSZE	; size
		ld	(hl),l		; l=0
		ld	d,h		
		ld	e,#1
		ldir			; cls
		ld	(hl),a		; attr
		ld	bc,#ATTRSZE	; size of attr
		ldir
		ret


		;; ----------------------------
		;; extern void con_scroll_up();
		;; ----------------------------
_con_scroll_up::
		ld	de,#VMEMBEG	; scan line 1
		ld	hl,#SCRROW6	; scan line 6
		ld	bc,#BYTSROW	; bytes to transfer
		;; move 186 lines (192 - 6)
		ld	a,#YMAX
ls_loop:	
		push	af		
		push	bc
		push	de		
		push	hl
		ldir			; move scan line
		pop	hl
		pop	de
		call	vid_nextrow
		ex	de,hl
		call	vid_nextrow
		ex	de,hl
		pop	bc
		pop	af
		dec	a
		jr	nz,ls_loop
		;; fill last line with zeroes
		;; note: de already points to correct line
		ld	a,#HEIGHT	; 6 lines 
		ex 	de,hl		; correct line to hl
ls_clr_loop:
		push	hl		; store hl
		ld	b,#BYTSROW	; bytes
ls_clrlne_loop:	
		ld	(hl),#0
		inc	hl
		djnz	ls_clrlne_loop
		pop	hl
		push	af
		call	vid_nextrow
		pop	af
		dec	a
		jr	nz,ls_clr_loop
		ret



		;; -------------------------------
		;; extern void con_puts(string s);
		;; -------------------------------
_con_puts::
		ld	hl,(#_con_x)
		push	hl		; bc=hl 1/2
		pop	bc		; c = x, b = y
		pop	de		; ret addr
		pop	hl		; string pointer
		;; restore stack		
		push	hl
		push	de
		;; at this point c=x, b=y, hl=string
puts_loop:
		ld	a,(hl)		; a = ascii
		cp	#0		; end of string?
		ret	z		; return if done...
		cp	#LF		; line feed?
		jr	z, linefeed
		ld	e,a		; ascii to e
		push	hl		; store pointer to char
		push	bc		; store coordinates
		call	putcharxy	; to screen
		pop	bc		; coords back to bc
		pop	hl		; get hl back
		ld	a,c		; a=x
		cp	#XMAX		; x==max x?
		jr	z,linefeed	; linefeed
		add	#WIDTH		; x=x+width
		ld	c,a		; new x to c	
		push	hl		; store nexc char	
		push	bc		; coord on stack
		pop	hl		; coords to hl
		ld	(#_con_x),hl	; to memory
		pop	hl		; pointer to next char		
nextch:
		inc	hl		; prepare for next char
		jr	puts_loop	; and next
linefeed:	
		call	newline
		jr	nextch
newline:	
		ld	c,#0		; x=0 (in any case)
		ex	af,af'
		ld	a,b		; a=y
		cp	#YMAX		; y==max y?
		jr	nz,nl_add
		;; we need to scroll
		push	af
		push	bc
		push	hl
		call	_con_scroll_up
		pop	hl
		pop	bc
		pop	af
		jr	nl_update
nl_add:
		add	#HEIGHT		; y=y+HEIGHT
nl_update:
		ld	(#_con_y),a	; store new y
		xor	a		; a=0
		ld	(#_con_x),a	; and new x		
		ex	af,af'
		ret
		

		;; -----------------------
		;; extern void con_back();
		;; -----------------------
_con_back::	
		ld	a,(#_con_x)	; get x
		cp	#0		; is it 0?
		ret	z		; sorry, not possible to move back...
		sub	#WIDTH		; a=a-width
		ld	(#_con_x),a	; store new coord.
		ld	c,a		; c=x
		ld	a,(#_con_y)	; a=y
		ld	b,a		; b=y
		ld	e,#' '		; delete 1 back
		call	putcharxy	; draw char
		ret			; and we're done...



		.area _INITIALIZED
_con_x:		.ds	1
_con_y:		.ds	1


		.area _INITIALIZER
__xinit__con_x:	.byte	0
__xinit__con_y:	.byte	186
		.area _CABS (ABS)
