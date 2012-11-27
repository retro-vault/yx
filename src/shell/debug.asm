;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:32:59 2012
;--------------------------------------------------------
	.module debug
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _y
	.globl _x
	.globl _dbg_cls
	.globl _dbg_putc_xy
	.globl _dbg_scroll
	.globl _dbg_say
	.globl _dbg_wtox
	.globl _dbg_memdump
	.globl _dbg_taskdump
	.globl _dbg_timerdump
	.globl _dbg_eventdump
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_x::
	.ds 1
_y::
	.ds 1
;--------------------------------------------------------
; overlayable items in  ram 
;--------------------------------------------------------
	.area _OVERLAY
;--------------------------------------------------------
; external initialized ram data
;--------------------------------------------------------
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;debug.c:9: byte x=0;
	ld	iy,#_x
	ld	0 (iy),#0x00
;debug.c:10: byte y=23;
	ld	iy,#_y
	ld	0 (iy),#0x17
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;debug.c:15: void dbg_cls() __naked {
;	---------------------------------
; Function dbg_cls
; ---------------------------------
_dbg_cls_start::
_dbg_cls:
;debug.c:35: __endasm;
;;	first clear contents of vmemory
	ld	hl,#0x4000 ; vmemory
	ld	bc,#0x1800 ; vmem size
	ld	(hl),l ; l = 0
	ld	d,h
	ld	e,#1
	ldir	; clear screen
;;	now the attributes
	ld	(hl),#0b00111000
	ld	bc,#0x02ff ; size of attr
	ldir
;;	and the border
	ld	a,#0b00000111 ; gray border
	out	(0xfe),a ; set border
	ret
_dbg_cls_end::
;debug.c:43: void dbg_putc_xy(byte c, byte x, byte y) __naked {
;	---------------------------------
; Function dbg_putc_xy
; ---------------------------------
_dbg_putc_xy_start::
_dbg_putc_xy:
;debug.c:116: __endasm;	
	ld	iy,#0x0000
	add	iy,sp
;;	convert y to hires
	ld	b,3(iy) ; get x coordinate into b
	ld	c,4(iy) ; get y coordinate into a
	sla	c
	sla	c
	sla	c ; c=c*8 (hires y coordinate 0..191)
;;	calculate character inside font
	ld	a,2(iy) ; get character
	sub	#32 ; a = a-32
	ld	h,#0x00 ; h=0
	ld	l,a ; hl=a
	add	hl,hl ; hl=hl*2
	add	hl,hl ; hl=hl*4
	add	hl,hl ; hl=hl*8
	ld	de,#sysfont8x8 ; font address
	add	hl,de ; hl=character address
	ex	de,hl ; into de
;;	calculate row memory address
	ld	a,c ; get y
	and	#0x07 ; leave only bits 0-2
	ld	h,a ; to high
	ld	a,c ; y back to acc.
	and	#0x38 ; bits 3-5 need to be
	rla	; shifted left
	rla	; twice
	ld	l,a ; and placed into l
	ld	a,c ; y back to acc.
	and	#0xc0 ; bits 6-7
	rra	; shifted...
	rra	; ...three...
	rra	; ...times
	or	h ; ored into high
	or	#0x40 ; or video memory address to h
	ld	h,a ; hl = row addr
;;	add x offset
	ld	a,l
	add	b ; add x to l
	jr	nc,nocarry ; no carry
	inc	h
	nocarry:
	ld	l,a
;;	and now loop it
	ld	b,#8 ; eight lines
	loop:
	ld	a,(de) ; get character byte
	inc	de ; next byte
	ld	(hl),a ; transfer to screen
;;	next line
	inc	h
	ld	a,h
	and	#7
	jr	nz,next_line
	ld	a,l
	add	a,#32
	ld	l,a
	jr	c, next_line
	ld	a,h
	sub	#8
	ld	h,a
	next_line:
	djnz	loop
	ret
_dbg_putc_xy_end::
;debug.c:122: void dbg_scroll() __naked {
;	---------------------------------
; Function dbg_scroll
; ---------------------------------
_dbg_scroll_start::
_dbg_scroll:
;debug.c:168: __endasm;
	ld	b,#8 ; 8 lines
	scroll_up:
	push	bc ; store
	push	af
	ld	a,#192 ; lines to move
	ld	de,#0x4000 ; start here
	loopscroll:
	push	de ; store de
	push	af
;;	calculate next line de=next_line(de)
	inc	d
	ld	a,d
	and	#7
	jr	nz,nl_done
	ld	a,e
	add	a,#32
	ld	e,a
	jr	c,nl_done
	ld	a,d
	sub	#8
	ld	d,a
	nl_done:
	pop	af
	ex	de,hl ; de to hl
	pop	de ; previous line to de
	ld	bc,#32 ; 32 bytes to move
	push	hl ; store new line
	ldir	; move one line
	pop	de ; restore new line to de
	dec	a ; reduce line count
	jr	z,endscroll ; is it zero?
	jr	loopscroll
	endscroll:
	pop	af
	ld	hl,#0x57e0 ; last line address
	ld	b,#32
	clear_line:
	ld	(hl),#0
	inc	hl
	djnz	clear_line
	pop	bc
	djnz	scroll_up
	ret
_dbg_scroll_end::
;debug.c:174: void dbg_say(string msg) {
;	---------------------------------
; Function dbg_say
; ---------------------------------
_dbg_say_start::
_dbg_say:
	push	ix
	ld	ix,#0
	add	ix,sp
;debug.c:175: while(*msg) { 
	ld	e,4 (ix)
	ld	d,5 (ix)
00111$:
	ld	a,(de)
;debug.c:176: switch(*msg) {
	ld	b,a
	or	a,a
	jr	Z,00114$
	cp	a,#0x08
	jr	Z,00102$
	sub	a, #0x0A
	jr	NZ,00105$
;debug.c:178: x=0;
	ld	hl,#_x + 0
	ld	(hl), #0x00
;debug.c:179: y++;
	ld	iy,#_y
	inc	0 (iy)
;debug.c:180: break;
	jr	00106$
;debug.c:181: case '\b':
00102$:
;debug.c:182: if (x>0) x--;
	ld	iy,#_x
	ld	a,0 (iy)
	or	a, a
	jr	Z,00106$
	dec	0 (iy)
;debug.c:183: break;
	jr	00106$
;debug.c:184: default:
00105$:
;debug.c:185: dbg_putc_xy(*msg, x++, y);		
	ld	iy,#_x
	ld	c,0 (iy)
	inc	0 (iy)
	push	de
	ld	a,(_y)
	push	af
	inc	sp
	ld	a,c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_dbg_putc_xy
	pop	af
	inc	sp
	pop	de
;debug.c:186: }
00106$:
;debug.c:187: if (x>31) {
	ld	a,#0x1F
	ld	iy,#_x
	sub	a, 0 (iy)
	jr	NC,00108$
;debug.c:188: x=0;
	ld	0 (iy),#0x00
;debug.c:189: y++;
	ld	iy,#_y
	inc	0 (iy)
00108$:
;debug.c:191: if (y>23) {
	ld	a,#0x17
	ld	iy,#_y
	sub	a, 0 (iy)
	jr	NC,00110$
;debug.c:192: y=23;
	ld	0 (iy),#0x17
;debug.c:193: dbg_scroll();
	push	de
	call	_dbg_scroll
	pop	de
00110$:
;debug.c:195: msg++;	
	inc	de
	jr	00111$
00114$:
	pop	ix
	ret
_dbg_say_end::
;debug.c:200: void dbg_wtox(word w, string destination) {
;	---------------------------------
; Function dbg_wtox
; ---------------------------------
_dbg_wtox_start::
_dbg_wtox:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-22
	add	hl,sp
	ld	sp,hl
;debug.c:204: byte hex[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
	ld	hl,#0x0004
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x30
	ld	l,c
	ld	h,b
	inc	hl
	ld	(hl),#0x31
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0x32
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x33
	ld	hl,#0x0004
	add	hl,bc
	ld	(hl),#0x34
	ld	hl,#0x0005
	add	hl,bc
	ld	(hl),#0x35
	ld	hl,#0x0006
	add	hl,bc
	ld	(hl),#0x36
	ld	hl,#0x0007
	add	hl,bc
	ld	(hl),#0x37
	ld	hl,#0x0008
	add	hl,bc
	ld	(hl),#0x38
	ld	hl,#0x0009
	add	hl,bc
	ld	(hl),#0x39
	ld	hl,#0x000A
	add	hl,bc
	ld	(hl),#0x41
	ld	hl,#0x000B
	add	hl,bc
	ld	(hl),#0x42
	ld	hl,#0x000C
	add	hl,bc
	ld	(hl),#0x43
	ld	hl,#0x000D
	add	hl,bc
	ld	(hl),#0x44
	ld	hl,#0x000E
	add	hl,bc
	ld	(hl),#0x45
	ld	hl,#0x000F
	add	hl,bc
	ld	(hl),#0x46
;debug.c:206: p=(byte *)&w;
	ld	hl,#0x001A
	add	hl,sp
	ld	-2 (ix),l
	ld	-1 (ix),h
;debug.c:208: for(i = 0; i < 2; i++)	{
	ld	de,#0x0000
00101$:
	ld	a,e
	sub	a, #0x02
	ld	a,d
	sbc	a, #0x00
	jp	PO, 00110$
	xor	a, #0x80
00110$:
	jp	P,00104$
;debug.c:209: destination[i*2] = hex[((p[1-i] >> 4) & 0x0F)];
	ld	-20 (ix),e
	ld	-19 (ix),d
	sla	-20 (ix)
	rl	-19 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	pop	iy
	pop	hl
	push	bc
	ld	c,-20 (ix)
	ld	b,-19 (ix)
	add	iy, bc
	pop	bc
	ld	a,#0x01
	sub	a, e
	ld	-22 (ix),a
	ld	a,#0x00
	sbc	a, d
	ld	-21 (ix),a
	ld	a,-2 (ix)
	add	a, -22 (ix)
	ld	l,a
	ld	a,-1 (ix)
	adc	a, -21 (ix)
	ld	h,a
	ld	a,(hl)
	ld	-22 (ix), a
	srl	a
	srl	a
	srl	a
	srl	a
	and	a, #0x0F
	ld	l, a
	ld	h,#0x00
	add	hl,bc
	ld	a,(hl)
	ld	0 (iy), a
;debug.c:210: destination[(i*2) + 1] = hex[(p[1-i]) & 0x0F];
	push	hl
	ld	l,-20 (ix)
	ld	h,-19 (ix)
	inc	hl
	push	hl
	pop	iy
	pop	hl
	push	bc
	ld	c,6 (ix)
	ld	b,7 (ix)
	add	iy, bc
	pop	bc
	ld	a,-22 (ix)
	and	a, #0x0F
	ld	l, a
	ld	h,#0x00
	add	hl,bc
	ld	a,(hl)
	ld	0 (iy), a
;debug.c:208: for(i = 0; i < 2; i++)	{
	inc	de
	jp	00101$
00104$:
;debug.c:212: destination[i*2]=0;
	sla	e
	rl	d
	ld	a,e
	add	a, 6 (ix)
	ld	e,a
	ld	a,d
	adc	a, 7 (ix)
	ld	d,a
	ld	a,#0x00
	ld	(de),a
	ld	sp,ix
	pop	ix
	ret
_dbg_wtox_end::
;debug.c:215: void dbg_memdump() {
;	---------------------------------
; Function dbg_memdump
; ---------------------------------
_dbg_memdump_start::
_dbg_memdump:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-28
	add	hl,sp
	ld	sp,hl
;debug.c:220: buff[0]=0;
	ld	hl,#0x0016
	add	hl,sp
	ex	de,hl
	ld	a,#0x00
	ld	(de),a
;debug.c:222: dbg_say("MEMORY DUMP:\n");
	ld	hl,#__str_0
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:224: dbg_say("first last break\n");
	ld	hl,#__str_1
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:225: dbg_say("===== ==== =====\n");
	ld	hl,#__str_2
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:226: dbg_wtox((word)mem_first,buff);
	ld	c,e
	ld	b,d
	ld	iy,(_mem_first)
	push	de
	push	bc
	push	iy
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:227: dbg_say(" "); dbg_say(buff); dbg_say(" ");
	ld	hl,#__str_3
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	l,e
	ld	h,d
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_3
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:228: dbg_wtox((word)mem_last,buff);
	ld	c,e
	ld	b,d
	ld	iy,(_mem_last)
	push	de
	push	bc
	push	iy
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:229: dbg_say(buff); dbg_say(" ");
	ld	l,e
	ld	h,d
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_3
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:230: dbg_wtox((word)brk_addr,buff);
	ld	l,e
	ld	h,d
	push	de
	push	hl
	ld	hl,(_brk_addr)
	push	hl
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:231: dbg_say(" "); dbg_say(buff); dbg_say("\n");
	ld	hl,#__str_3
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	l,e
	ld	h,d
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_4
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:234: dbg_say("block owner size next prev\n");
	ld	hl,#__str_5
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:235: dbg_say("===== ===== ==== ==== ====\n");
	ld	hl,#__str_6
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:237: b=mem_first;
	ld	bc,(_mem_first)
;debug.c:238: while (b) {
	ld	-8 (ix),e
	ld	-7 (ix),d
	ld	-10 (ix),e
	ld	-9 (ix),d
	ld	-12 (ix),e
	ld	-11 (ix),d
	ld	-14 (ix),e
	ld	-13 (ix),d
	ld	-16 (ix),e
	ld	-15 (ix),d
	ld	-18 (ix),e
	ld	-17 (ix),d
	ld	-20 (ix),e
	ld	-19 (ix),d
	ld	-22 (ix),e
	ld	-21 (ix),d
	ld	-24 (ix),e
	ld	-23 (ix),d
	ld	-26 (ix),e
	ld	-25 (ix),d
00101$:
	ld	a,b
	or	a,c
	jp	Z,00104$
;debug.c:240: dbg_wtox((word)b,buff);
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	e,c
	ld	d,b
	push	bc
	push	hl
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
	pop	bc
;debug.c:241: dbg_say(" "); dbg_say(buff); dbg_say(" ");
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:242: dbg_wtox((word)b->owner,buff);
	ld	e,-12 (ix)
	ld	d,-11 (ix)
	push	de
	pop	iy
	ld	l,c
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	iy
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
	pop	bc
;debug.c:243: dbg_say(" "); dbg_say(buff); dbg_say(" ");
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:244: dbg_wtox(b->size,buff);
	ld	e,-16 (ix)
	ld	d,-15 (ix)
	push	de
	pop	iy
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	iy
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
	pop	bc
;debug.c:245: dbg_say(buff); dbg_say(" ");
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:246: dbg_wtox((word)b->next,buff);
	ld	e,-20 (ix)
	ld	d,-19 (ix)
	push	de
	pop	iy
	ld	hl,#0x0004
	add	hl,bc
	ld	-28 (ix),l
	ld	-27 (ix),h
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	iy
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
	pop	bc
;debug.c:247: dbg_say(buff); dbg_say(" ");
	ld	l,-22 (ix)
	ld	h,-21 (ix)
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
	ld	hl,#__str_3
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:248: dbg_wtox((word)b->prev,buff);
	ld	e,-24 (ix)
	ld	d,-23 (ix)
	ld	hl,#0x0006
	add	hl,bc
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	push	bc
	call	_dbg_wtox
	pop	af
	pop	af
;debug.c:249: dbg_say(buff); dbg_say("\n");
	ld	l,-26 (ix)
	ld	h,-25 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_4
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:250: b=b->next;
	ld	l,-28 (ix)
	ld	h,-27 (ix)
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	jp	00101$
00104$:
	ld	sp,ix
	pop	ix
	ret
_dbg_memdump_end::
__str_0:
	.ascii "MEMORY DUMP:"
	.db 0x0A
	.db 0x00
__str_1:
	.ascii "first last break"
	.db 0x0A
	.db 0x00
__str_2:
	.ascii "===== ==== ====="
	.db 0x0A
	.db 0x00
__str_3:
	.ascii " "
	.db 0x00
__str_4:
	.db 0x0A
	.db 0x00
__str_5:
	.ascii "block owner size next prev"
	.db 0x0A
	.db 0x00
__str_6:
	.ascii "===== ===== ==== ==== ===="
	.db 0x0A
	.db 0x00
;debug.c:255: void dbg_taskdump() {
;	---------------------------------
; Function dbg_taskdump
; ---------------------------------
_dbg_taskdump_start::
_dbg_taskdump:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-20
	add	hl,sp
	ld	sp,hl
;debug.c:259: buff[0]=0;
	ld	hl,#0x000E
	add	hl,sp
	ex	de,hl
	ld	a,#0x00
	ld	(de),a
;debug.c:261: dbg_say("TASKS:\n");
	ld	hl,#__str_7
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:262: dbg_say("task next stck state \n");
	ld	hl,#__str_8
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:263: dbg_say("==== ==== ==== ======= \n");
	ld	hl,#__str_9
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:265: t=tsk_first_running;
	ld	iy,#_tsk_first_running
	ld	a,0 (iy)
	ld	-8 (ix),a
	ld	a,1 (iy)
	ld	-7 (ix),a
;debug.c:266: while (t) {
	ld	-10 (ix),e
	ld	-9 (ix),d
	ld	-12 (ix),e
	ld	-11 (ix),d
	ld	-14 (ix),e
	ld	-13 (ix),d
	ld	-16 (ix),e
	ld	-15 (ix),d
	ld	-18 (ix),e
	ld	-17 (ix),d
	ld	-20 (ix),e
	ld	-19 (ix),d
00104$:
	ld	a,-7 (ix)
	or	a,-8 (ix)
	jp	Z,00107$
;debug.c:268: dbg_wtox((word)t,buff);
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	push	hl
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
;debug.c:269: dbg_say(buff); dbg_say(" ");
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_10
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:270: dbg_wtox((word)t->next,buff);
	ld	c,-14 (ix)
	ld	b,-13 (ix)
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
;debug.c:271: dbg_say(buff); dbg_say(" ");
	ld	l,-16 (ix)
	ld	h,-15 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_10
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:272: dbg_wtox((word)t->sp,buff);
	ld	c,-18 (ix)
	ld	b,-17 (ix)
	ld	a,-8 (ix)
	add	a, #0x04
	ld	l,a
	ld	a,-7 (ix)
	adc	a, #0x00
	ld	h,a
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
;debug.c:273: dbg_say(buff); dbg_say(" ");
	ld	l,-20 (ix)
	ld	h,-19 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_10
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:274: if (t->state == TASK_STATE_RUNNING)
	ld	iy,#0x0009
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	add	iy, de
	ld	a, 0 (iy)
	or	a, a
	jr	NZ,00102$
;debug.c:275: dbg_say("running\n");
	ld	hl,#__str_11
	push	hl
	call	_dbg_say
	pop	af
	jr	00103$
00102$:
;debug.c:277: dbg_say("waiting\n");
	ld	hl,#__str_12
	push	hl
	call	_dbg_say
	pop	af
00103$:
;debug.c:279: t=t->next;
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	ld	-8 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-7 (ix),a
	jp	00104$
00107$:
	ld	sp,ix
	pop	ix
	ret
_dbg_taskdump_end::
__str_7:
	.ascii "TASKS:"
	.db 0x0A
	.db 0x00
__str_8:
	.ascii "task next stck state "
	.db 0x0A
	.db 0x00
__str_9:
	.ascii "==== ==== ==== ======= "
	.db 0x0A
	.db 0x00
__str_10:
	.ascii " "
	.db 0x00
__str_11:
	.ascii "running"
	.db 0x0A
	.db 0x00
__str_12:
	.ascii "waiting"
	.db 0x0A
	.db 0x00
;debug.c:283: void dbg_timerdump() {
;	---------------------------------
; Function dbg_timerdump
; ---------------------------------
_dbg_timerdump_start::
_dbg_timerdump:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-22
	add	hl,sp
	ld	sp,hl
;debug.c:287: buff[0]=0;
	ld	hl,#0x0010
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	(hl),#0x00
;debug.c:289: dbg_say("TIMERS:\n");
	ld	hl,#__str_13
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:290: dbg_say("timer tick tc   next\n");
	ld	hl,#__str_14
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:291: dbg_say("===== ==== ==== ====\n");
	ld	hl,#__str_15
	push	bc
	push	hl
	call	_dbg_say
	pop	af
	pop	bc
;debug.c:293: tmr=tmr_first;
	ld	de,(_tmr_first)
;debug.c:294: while (tmr) {
	ld	-8 (ix),c
	ld	-7 (ix),b
	ld	-10 (ix),c
	ld	-9 (ix),b
	ld	-12 (ix),c
	ld	-11 (ix),b
	ld	-14 (ix),c
	ld	-13 (ix),b
	ld	-16 (ix),c
	ld	-15 (ix),b
	ld	-18 (ix),c
	ld	-17 (ix),b
	ld	-20 (ix),c
	ld	-19 (ix),b
	ld	-22 (ix),c
	ld	-21 (ix),b
00101$:
	ld	a,d
	or	a,e
	jp	Z,00104$
;debug.c:296: dbg_wtox((word)tmr,buff);
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	c,e
	ld	b,d
	push	de
	push	hl
	push	bc
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:297: dbg_say(" "); dbg_say(buff); dbg_say(" ");
	ld	hl,#__str_16
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_16
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:298: dbg_wtox((word)tmr->ticks,buff);
	ld	c,-12 (ix)
	ld	b,-11 (ix)
	push	bc
	pop	iy
	ld	hl,#0x0006
	add	hl,de
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	push	iy
	push	bc
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:299: dbg_say(buff); dbg_say(" ");
	ld	l,-14 (ix)
	ld	h,-13 (ix)
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_16
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:300: dbg_wtox((word)tmr->_tick_count,buff);
	ld	c,-16 (ix)
	ld	b,-15 (ix)
	push	bc
	pop	iy
	ld	hl,#0x0008
	add	hl,de
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	push	iy
	push	bc
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:301: dbg_say(buff); dbg_say(" ");
	ld	l,-18 (ix)
	ld	h,-17 (ix)
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_16
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:302: dbg_wtox((word)tmr->next,buff);
	ld	c,-20 (ix)
	ld	b,-19 (ix)
	push	bc
	pop	iy
	ld	l,e
	ld	h,d
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	push	de
	push	iy
	push	bc
	call	_dbg_wtox
	pop	af
	pop	af
	pop	de
;debug.c:303: dbg_say(buff); dbg_say("\n");
	ld	l,-22 (ix)
	ld	h,-21 (ix)
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
	ld	hl,#__str_17
	push	de
	push	hl
	call	_dbg_say
	pop	af
;debug.c:305: tmr=tmr->next;
	pop	hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	jp	00101$
00104$:
	ld	sp,ix
	pop	ix
	ret
_dbg_timerdump_end::
__str_13:
	.ascii "TIMERS:"
	.db 0x0A
	.db 0x00
__str_14:
	.ascii "timer tick tc   next"
	.db 0x0A
	.db 0x00
__str_15:
	.ascii "===== ==== ==== ===="
	.db 0x0A
	.db 0x00
__str_16:
	.ascii " "
	.db 0x00
__str_17:
	.db 0x0A
	.db 0x00
;debug.c:309: void dbg_eventdump() {
;	---------------------------------
; Function dbg_eventdump
; ---------------------------------
_dbg_eventdump_start::
_dbg_eventdump:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-16
	add	hl,sp
	ld	sp,hl
;debug.c:313: buff[0]=0;
	ld	hl,#0x000A
	add	hl,sp
	ex	de,hl
	ld	a,#0x00
	ld	(de),a
;debug.c:315: dbg_say("EVENTS:\n");
	ld	hl,#__str_18
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:316: dbg_say("event next state\n");
	ld	hl,#__str_19
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:317: dbg_say("===== ==== =====\n");
	ld	hl,#__str_20
	push	de
	push	hl
	call	_dbg_say
	pop	af
	pop	de
;debug.c:319: e=evt_first;
	ld	iy,#_evt_first
	ld	a,0 (iy)
	ld	-8 (ix),a
	ld	a,1 (iy)
	ld	-7 (ix),a
;debug.c:320: while (e) {
	ld	-10 (ix),e
	ld	-9 (ix),d
	ld	-12 (ix),e
	ld	-11 (ix),d
	ld	-14 (ix),e
	ld	-13 (ix),d
	ld	-16 (ix),e
	ld	-15 (ix),d
00104$:
	ld	a,-7 (ix)
	or	a,-8 (ix)
	jp	Z,00107$
;debug.c:322: dbg_wtox((word)e,buff);
	ld	l,-10 (ix)
	ld	h,-9 (ix)
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	push	hl
	push	de
	call	_dbg_wtox
	pop	af
;debug.c:323: dbg_say(" "); dbg_say(buff); dbg_say(" ");
	ld	hl, #__str_21
	ex	(sp),hl
	call	_dbg_say
	pop	af
	ld	l,-12 (ix)
	ld	h,-11 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_21
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:324: dbg_wtox((word)e->next,buff);
	ld	c,-14 (ix)
	ld	b,-13 (ix)
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	push	bc
	push	de
	call	_dbg_wtox
	pop	af
	pop	af
;debug.c:325: dbg_say(buff); dbg_say(" ");
	ld	l,-16 (ix)
	ld	h,-15 (ix)
	push	hl
	call	_dbg_say
	ld	hl, #__str_21
	ex	(sp),hl
	call	_dbg_say
	pop	af
;debug.c:326: if (e->state==signaled)
	ld	iy,#0x0004
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	add	iy, de
	ld	a, 0 (iy)
	sub	a, #0x01
	jr	NZ,00102$
;debug.c:327: dbg_say("signaled\n");
	ld	hl,#__str_22
	push	hl
	call	_dbg_say
	pop	af
	jr	00103$
00102$:
;debug.c:329: dbg_say("nonsignaled\n");		
	ld	hl,#__str_23
	push	hl
	call	_dbg_say
	pop	af
00103$:
;debug.c:331: e = e->next;
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	ld	-8 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-7 (ix),a
	jp	00104$
00107$:
	ld	sp,ix
	pop	ix
	ret
_dbg_eventdump_end::
__str_18:
	.ascii "EVENTS:"
	.db 0x0A
	.db 0x00
__str_19:
	.ascii "event next state"
	.db 0x0A
	.db 0x00
__str_20:
	.ascii "===== ==== ====="
	.db 0x0A
	.db 0x00
__str_21:
	.ascii " "
	.db 0x00
__str_22:
	.ascii "signaled"
	.db 0x0A
	.db 0x00
__str_23:
	.ascii "nonsignaled"
	.db 0x0A
	.db 0x00
	.area _CODE
	.area _CABS
