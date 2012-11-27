;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:27 2012
;--------------------------------------------------------
	.module ball
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _wait
	.globl _timer2
	.globl _timer1
	.globl _tsk_wait4events
	.globl _evt_set
	.globl _evt_create
	.globl _tmr_install
	.globl _dbg_cls
	.globl _dbg_putc_xy
	.globl _done
	.globl _b2
	.globl _b1
	.globl _init_balls
	.globl _ball
	.globl _ball2
	.globl _ball3
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_b1::
	.ds 2
_b2::
	.ds 2
_done::
	.ds 2
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
;ball.c:10: event_t *b1=NULL;
	ld	iy,#_b1
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;ball.c:11: event_t *b2=NULL;
	ld	iy,#_b2
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;ball.c:12: event_t *done=NULL;
	ld	iy,#_done
	ld	0 (iy),#0x00
	ld	1 (iy),#0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;ball.c:14: void timer1() {
;	---------------------------------
; Function timer1
; ---------------------------------
_timer1_start::
_timer1:
;ball.c:15: evt_set(b1,signaled);
	ld	a,#0x01
	push	af
	inc	sp
	ld	hl,(_b1)
	push	hl
	call	_evt_set
	pop	af
	inc	sp
	ret
_timer1_end::
;ball.c:18: void timer2() {
;	---------------------------------
; Function timer2
; ---------------------------------
_timer2_start::
_timer2:
;ball.c:19: evt_set(b2,signaled);
	ld	a,#0x01
	push	af
	inc	sp
	ld	hl,(_b2)
	push	hl
	call	_evt_set
	pop	af
	inc	sp
	ret
_timer2_end::
;ball.c:22: void init_balls() {
;	---------------------------------
; Function init_balls
; ---------------------------------
_init_balls_start::
_init_balls:
;ball.c:24: b1=evt_create(KERNEL);
	ld	hl,#0x0100
	push	hl
	call	_evt_create
	pop	af
	ld	iy,#_b1
	ld	0 (iy),l
	ld	1 (iy),h
;ball.c:25: b2=evt_create(KERNEL);
	ld	hl,#0x0100
	push	hl
	call	_evt_create
	pop	af
	ld	iy,#_b2
	ld	0 (iy),l
	ld	1 (iy),h
;ball.c:26: done=evt_create(KERNEL);
	ld	hl,#0x0100
	push	hl
	call	_evt_create
	pop	af
	ld	iy,#_done
	ld	0 (iy),l
	ld	1 (iy),h
;ball.c:27: tmr_install(timer1,0x05); 
	ld	hl,#0x0005
	push	hl
	ld	hl,#_timer1
	push	hl
	call	_tmr_install
	pop	af
;ball.c:28: tmr_install(timer2,0x0a);
	ld	hl, #0x000A
	ex	(sp),hl
	ld	hl,#_timer2
	push	hl
	call	_tmr_install
	pop	af
	pop	af
	ret
_init_balls_end::
;ball.c:31: void wait(word pause) {
;	---------------------------------
; Function wait
; ---------------------------------
_wait_start::
_wait:
	push	ix
	ld	ix,#0
	add	ix,sp
;ball.c:33: for (n=0;n<pause;n++);
	ld	hl,#0x0000
00101$:
	ld	a, l
	ld	e, h
	sub	a, 4 (ix)
	ld	a,e
	sbc	a, 5 (ix)
	jr	NC,00105$
	inc	hl
	jr	00101$
00105$:
	pop	ix
	ret
_wait_end::
;ball.c:36: void ball() {
;	---------------------------------
; Function ball
; ---------------------------------
_ball_start::
_ball:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-12
	add	hl,sp
	ld	sp,hl
;ball.c:41: dbg_cls();
	call	_dbg_cls
;ball.c:43: x=5;
	ld	-2 (ix),#0x05
	ld	-1 (ix),#0x00
;ball.c:44: y=0;
	ld	-4 (ix),#0x00
	ld	-3 (ix),#0x00
;ball.c:45: dx=dy=1;
	ld	-12 (ix),#0x01
	ld	-11 (ix),#0x00
	ld	-10 (ix),#0x01
	ld	-9 (ix),#0x00
;ball.c:47: while (1) {
00110$:
;ball.c:48: dbg_putc_xy('o',x,y);
	ld	b,-4 (ix)
	ld	c, -2 (ix)
	push	bc
	ld	a,#0x6F
	push	af
	inc	sp
	call	_dbg_putc_xy
	pop	af
	inc	sp
;ball.c:49: old_x=x;
	ld	a,-2 (ix)
	ld	-6 (ix),a
	ld	a,-1 (ix)
	ld	-5 (ix),a
;ball.c:50: old_y=y;
	ld	a,-4 (ix)
	ld	-8 (ix),a
	ld	a,-3 (ix)
	ld	-7 (ix),a
;ball.c:51: x=x+dx;
	ld	a,-2 (ix)
	add	a, -10 (ix)
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, -9 (ix)
	ld	-1 (ix),a
;ball.c:52: y=y+dy;
	ld	a,-4 (ix)
	add	a, -12 (ix)
	ld	-4 (ix),a
	ld	a,-3 (ix)
	adc	a, -11 (ix)
	ld	-3 (ix),a
;ball.c:53: if (x>31) { x=31; dx=-1; }
	ld	a,#0x1F
	sub	a, -2 (ix)
	ld	a,#0x00
	sbc	a, -1 (ix)
	jp	PO, 00119$
	xor	a, #0x80
00119$:
	jp	P,00102$
	ld	-2 (ix),#0x1F
	ld	-1 (ix),#0x00
	ld	-10 (ix),#0xFF
	ld	-9 (ix),#0xFF
00102$:
;ball.c:54: if (x<0) { x=0; dx=1; }
	bit	7,-1 (ix)
	jr	Z,00104$
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
	ld	-10 (ix),#0x01
	ld	-9 (ix),#0x00
00104$:
;ball.c:55: if (y>23) { y=23; dy=-1; }
	ld	a,#0x17
	sub	a, -4 (ix)
	ld	a,#0x00
	sbc	a, -3 (ix)
	jp	PO, 00120$
	xor	a, #0x80
00120$:
	jp	P,00106$
	ld	-4 (ix),#0x17
	ld	-3 (ix),#0x00
	ld	-12 (ix),#0xFF
	ld	-11 (ix),#0xFF
00106$:
;ball.c:56: if (y<0) { y=0; dy=1; }
	bit	7,-3 (ix)
	jr	Z,00108$
	ld	-4 (ix),#0x00
	ld	-3 (ix),#0x00
	ld	-12 (ix),#0x01
	ld	-11 (ix),#0x00
00108$:
;ball.c:57: tsk_wait4events(&b1,1);
	ld	de,#_b1
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	call	_tsk_wait4events
	pop	af
	inc	sp
;ball.c:58: evt_set(b1,nonsignaled);
	ld	a,#0x00
	push	af
	inc	sp
	ld	hl,(_b1)
	push	hl
	call	_evt_set
	pop	af
	inc	sp
;ball.c:59: dbg_putc_xy(' ',old_x,old_y);
	ld	d,-8 (ix)
	ld	b,-6 (ix)
	push	de
	inc	sp
	push	bc
	inc	sp
	ld	a,#0x20
	push	af
	inc	sp
	call	_dbg_putc_xy
	pop	af
	inc	sp
	jp	00110$
_ball_end::
;ball.c:63: void ball2() {
;	---------------------------------
; Function ball2
; ---------------------------------
_ball2_start::
_ball2:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;ball.c:68: dbg_cls();
	call	_dbg_cls
;ball.c:70: x=0;
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
;ball.c:71: y=15;
	ld	bc,#0x000F
;ball.c:72: dx=1;
	ld	de,#0x0001
;ball.c:73: dy=-1;
	ld	-8 (ix),#0xFF
	ld	-7 (ix),#0xFF
;ball.c:75: while (1) {
00110$:
;ball.c:76: dbg_putc_xy('O',x,y);
	ld	h,c
	ld	a,-2 (ix)
	ld	-9 (ix),a
	push	bc
	push	de
	push	hl
	inc	sp
	ld	d, -9 (ix)
	ld	e,#0x4F
	push	de
	call	_dbg_putc_xy
	pop	af
	inc	sp
	pop	de
	pop	bc
;ball.c:77: old_x=x;
	ld	a,-2 (ix)
	ld	-4 (ix),a
	ld	a,-1 (ix)
	ld	-3 (ix),a
;ball.c:78: old_y=y;
	ld	-6 (ix),c
	ld	-5 (ix),b
;ball.c:79: x=x+dx;
	ld	a,-2 (ix)
	add	a, e
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, d
	ld	-1 (ix),a
;ball.c:80: y=y+dy;
	ld	a,c
	add	a, -8 (ix)
	ld	c,a
	ld	a,b
	adc	a, -7 (ix)
	ld	b,a
;ball.c:81: if (x>31) { x=31; dx=-1; }
	ld	a,#0x1F
	sub	a, -2 (ix)
	ld	a,#0x00
	sbc	a, -1 (ix)
	jp	PO, 00119$
	xor	a, #0x80
00119$:
	jp	P,00102$
	ld	-2 (ix),#0x1F
	ld	-1 (ix),#0x00
	ld	de,#0xFFFFFFFF
00102$:
;ball.c:82: if (x<0) { x=0; dx=1; }
	bit	7,-1 (ix)
	jr	Z,00104$
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
	ld	de,#0x0001
00104$:
;ball.c:83: if (y>23) { y=23; dy=-1; }
	ld	a,#0x17
	sub	a, c
	ld	a,#0x00
	sbc	a, b
	jp	PO, 00120$
	xor	a, #0x80
00120$:
	jp	P,00106$
	ld	bc,#0x0017
	ld	-8 (ix),#0xFF
	ld	-7 (ix),#0xFF
00106$:
;ball.c:84: if (y<0) { y=0; dy=1; }
	bit	7,b
	jr	Z,00108$
	ld	bc,#0x0000
	ld	-8 (ix),#0x01
	ld	-7 (ix),#0x00
00108$:
;ball.c:85: tsk_wait4events(&b2,1);
	push	bc
	push	de
	ld	a,#0x01
	push	af
	inc	sp
	ld	hl,#_b2
	push	hl
	call	_tsk_wait4events
	pop	af
	inc	sp
	ld	a,#0x00
	push	af
	inc	sp
	ld	hl,(_b2)
	push	hl
	call	_evt_set
	pop	af
	inc	sp
	pop	de
	pop	bc
;ball.c:87: dbg_putc_xy(' ',old_x,old_y);
	ld	h,-6 (ix)
	ld	a,-4 (ix)
	ld	-9 (ix),a
	push	bc
	push	de
	push	hl
	inc	sp
	ld	d, -9 (ix)
	ld	e,#0x20
	push	de
	call	_dbg_putc_xy
	pop	af
	inc	sp
	pop	de
	pop	bc
	jp	00110$
_ball2_end::
;ball.c:94: void ball3() {
;	---------------------------------
; Function ball3
; ---------------------------------
_ball3_start::
_ball3:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;ball.c:99: dbg_cls();
	call	_dbg_cls
;ball.c:101: x=31;
	ld	-2 (ix),#0x1F
	ld	-1 (ix),#0x00
;ball.c:102: y=5;
	ld	bc,#0x0005
;ball.c:103: dx=1;
	ld	de,#0x0001
;ball.c:104: dy=1;
	ld	-8 (ix),#0x01
	ld	-7 (ix),#0x00
;ball.c:106: while (1) {
00110$:
;ball.c:107: dbg_putc_xy('0',x,y);
	ld	h,c
	ld	a,-2 (ix)
	ld	-9 (ix),a
	push	bc
	push	de
	push	hl
	inc	sp
	ld	d, -9 (ix)
	ld	e,#0x30
	push	de
	call	_dbg_putc_xy
	pop	af
	inc	sp
	pop	de
	pop	bc
;ball.c:108: old_x=x;
	ld	a,-2 (ix)
	ld	-4 (ix),a
	ld	a,-1 (ix)
	ld	-3 (ix),a
;ball.c:109: old_y=y;
	ld	-6 (ix),c
	ld	-5 (ix),b
;ball.c:110: x=x+dx;
	ld	a,-2 (ix)
	add	a, e
	ld	-2 (ix),a
	ld	a,-1 (ix)
	adc	a, d
	ld	-1 (ix),a
;ball.c:111: y=y+dy;
	ld	a,c
	add	a, -8 (ix)
	ld	c,a
	ld	a,b
	adc	a, -7 (ix)
	ld	b,a
;ball.c:112: if (x>31) { x=31; dx=-1; }
	ld	a,#0x1F
	sub	a, -2 (ix)
	ld	a,#0x00
	sbc	a, -1 (ix)
	jp	PO, 00119$
	xor	a, #0x80
00119$:
	jp	P,00102$
	ld	-2 (ix),#0x1F
	ld	-1 (ix),#0x00
	ld	de,#0xFFFFFFFF
00102$:
;ball.c:113: if (x<0) { x=0; dx=1; }
	bit	7,-1 (ix)
	jr	Z,00104$
	ld	-2 (ix),#0x00
	ld	-1 (ix),#0x00
	ld	de,#0x0001
00104$:
;ball.c:114: if (y>23) { y=23; dy=-1; }
	ld	a,#0x17
	sub	a, c
	ld	a,#0x00
	sbc	a, b
	jp	PO, 00120$
	xor	a, #0x80
00120$:
	jp	P,00106$
	ld	bc,#0x0017
	ld	-8 (ix),#0xFF
	ld	-7 (ix),#0xFF
00106$:
;ball.c:115: if (y<0) { y=0; dy=1; }
	bit	7,b
	jr	Z,00108$
	ld	bc,#0x0000
	ld	-8 (ix),#0x01
	ld	-7 (ix),#0x00
00108$:
;ball.c:116: wait(1000);
	push	bc
	push	de
	ld	hl,#0x03E8
	push	hl
	call	_wait
	pop	af
	pop	de
	pop	bc
;ball.c:117: dbg_putc_xy(' ',old_x,old_y);
	ld	h,-6 (ix)
	ld	a,-4 (ix)
	ld	-9 (ix),a
	push	bc
	push	de
	push	hl
	inc	sp
	ld	d, -9 (ix)
	ld	e,#0x20
	push	de
	call	_dbg_putc_xy
	pop	af
	inc	sp
	pop	de
	pop	bc
	jp	00110$
_ball3_end::
	.area _CODE
	.area _CABS
