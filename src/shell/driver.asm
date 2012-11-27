;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:33:01 2012
;--------------------------------------------------------
	.module driver
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _tmr_install
	.globl _mem_allocate
	.globl _drv_first
	.globl _drv_register
	.globl _drv_query
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_drv_first::
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
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;driver.c:14: result drv_register(
;	---------------------------------
; Function drv_register
; ---------------------------------
_drv_register_start::
_drv_register:
	push	ix
	ld	ix,#0
	add	ix,sp
;driver.c:25: driver_t *d=mem_allocate(sizeof(driver_t),KALLOC);
	ld	hl,#0x0100
	push	hl
	ld	hl,#0x0011
	push	hl
	call	_mem_allocate
	pop	af
	pop	af
	ex	de,hl
;driver.c:26: d->id0=id0;
	ld	a,4 (ix)
	ld	(de),a
;driver.c:27: d->id1=id1;
	ld	l,e
	ld	h,d
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;driver.c:28: d->id2=id2;
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	ld	a,6 (ix)
	ld	(hl),a
;driver.c:29: d->open=open;
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
	inc	hl
	ld	a,8 (ix)
	ld	(hl),a
;driver.c:30: d->close=close;
	ld	hl,#0x0005
	add	hl,de
	ld	a,9 (ix)
	ld	(hl),a
	inc	hl
	ld	a,10 (ix)
	ld	(hl),a
;driver.c:31: d->read_async=read_async;
	ld	hl,#0x0007
	add	hl,de
	ld	a,11 (ix)
	ld	(hl),a
	inc	hl
	ld	a,12 (ix)
	ld	(hl),a
;driver.c:32: d->write_async=write_async;
	ld	hl,#0x0009
	add	hl,de
	ld	a,13 (ix)
	ld	(hl),a
	inc	hl
	ld	a,14 (ix)
	ld	(hl),a
;driver.c:33: d->ioctl=ioctl;
	ld	hl,#0x000B
	add	hl,de
	ld	a,15 (ix)
	ld	(hl),a
	inc	hl
	ld	a,16 (ix)
	ld	(hl),a
;driver.c:34: d->timer_hook=timer_hook;
	ld	hl,#0x000D
	add	hl,de
	ld	a,17 (ix)
	ld	(hl),a
	inc	hl
	ld	a,18 (ix)
	ld	(hl),a
;driver.c:35: d->next=drv_first;
	ld	hl,#0x000F
	add	hl,de
	ld	iy,#_drv_first
	ld	a,0 (iy)
	ld	(hl),a
	inc	hl
	ld	a,1 (iy)
	ld	(hl),a
;driver.c:36: drv_first=d;
	ld	0 (iy),e
	ld	1 (iy),d
;driver.c:38: if (init_fn) init_fn(d);
	ld	a,20 (ix)
	or	a,19 (ix)
	jr	Z,00102$
	push	de
	ld	l,19 (ix)
	ld	h,20 (ix)
	call	__sdcc_call_hl
	pop	af
00102$:
;driver.c:41: tmr_install(timer_hook,EVERYTIME);
	ld	hl,#0x0000
	push	hl
	ld	l,17 (ix)
	ld	h,18 (ix)
	push	hl
	call	_tmr_install
	pop	af
	pop	af
	pop	ix
	ret
_drv_register_end::
;driver.c:47: driver_t *drv_query(uint8_t id0, uint8_t id1, uint8_t id2) {
;	---------------------------------
; Function drv_query
; ---------------------------------
_drv_query_start::
_drv_query:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;driver.c:48: driver_t *d=NULL;
	ld	bc,#0x0000
;driver.c:49: driver_t *iter=drv_first;
	ld	de,(_drv_first)
;driver.c:51: while (!d && iter) 
00107$:
	ld	a,b
	or	a,c
	jr	NZ,00109$
	ld	a,d
	or	a,e
	jr	Z,00109$
;driver.c:52: if (iter->id0==id0 && iter->id1==id1 && iter->id2==id2)
	ld	a,(de)
	ld	-1 (ix), a
	sub	a, 4 (ix)
	jr	NZ,00102$
	ld	l,e
	ld	h,d
	inc	hl
	ld	a,(hl)
	ld	-1 (ix), a
	sub	a, 5 (ix)
	jr	NZ,00102$
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	-1 (ix), a
	sub	a, 6 (ix)
	jr	NZ,00102$
;driver.c:53: d=iter;
	ld	c,e
	ld	b,d
	jr	00107$
00102$:
;driver.c:55: iter=iter->next;
	ld	hl,#0x000F
	add	hl,de
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	jr	00107$
00109$:
;driver.c:57: return d;
	ld	l,c
	ld	h,b
	ld	sp,ix
	pop	ix
	ret
_drv_query_end::
	.area _CODE
	.area _CABS
