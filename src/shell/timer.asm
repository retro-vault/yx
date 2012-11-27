;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:33:01 2012
;--------------------------------------------------------
	.module timer
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _di
	.globl _ei
	.globl _lst_delete
	.globl _lst_insert
	.globl _tmr_first
	.globl _tmr_install
	.globl _tmr_uninstall
	.globl _tmr_chain
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_tmr_first::
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
;timer.c:9: timer_t *tmr_first=NULL;
	ld	iy,#_tmr_first
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
;timer.c:14: timer_t *tmr_install(void (*hook)(), word ticks) {
;	---------------------------------
; Function tmr_install
; ---------------------------------
_tmr_install_start::
_tmr_install:
	push	ix
	ld	ix,#0
	add	ix,sp
;timer.c:16: di();
	call	_di
;timer.c:17: t=(timer_t *)lst_insert((list_header_t **)&tmr_first, sizeof(timer_t), KERNEL);
	ld	de,#_tmr_first
	ld	hl,#0x0100
	push	hl
	ld	hl,#0x000A
	push	hl
	push	de
	call	_lst_insert
	pop	af
	pop	af
	pop	af
	ex	de,hl
;timer.c:18: t->hook=hook;
	ld	hl,#0x0004
	add	hl,de
	ld	a,4 (ix)
	ld	(hl),a
	inc	hl
	ld	a,5 (ix)
	ld	(hl),a
;timer.c:19: t->_tick_count=t->ticks=ticks;
	ld	hl,#0x0008
	add	hl,de
	ld	b,l
	ld	c,h
	ld	hl,#0x0006
	add	hl,de
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
	ld	l,b
	ld	h,c
	ld	a,6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,7 (ix)
	ld	(hl),a
;timer.c:20: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
;timer.c:21: ei();
	push	de
	call	_ei
;timer.c:22: return t;
	pop	hl
	pop	ix
	ret
_tmr_install_end::
;timer.c:28: result tmr_uninstall(timer_t *t) {
;	---------------------------------
; Function tmr_uninstall
; ---------------------------------
_tmr_uninstall_start::
_tmr_uninstall:
	push	ix
	ld	ix,#0
	add	ix,sp
;timer.c:30: di();
	call	_di
;timer.c:31: r=lst_delete((list_header_t **)&tmr_first, (list_header_t *)t, 1);
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	bc,#_tmr_first
	ld	a,#0x01
	push	af
	inc	sp
	push	de
	push	bc
	call	_lst_delete
	pop	af
	pop	af
	inc	sp
	ld	d,l
;timer.c:32: ei();
	push	de
	call	_ei
	pop	de
;timer.c:33: return r;
	ld	l,d
	pop	ix
	ret
_tmr_uninstall_end::
;timer.c:41: void tmr_chain() {
;	---------------------------------
; Function tmr_chain
; ---------------------------------
_tmr_chain_start::
_tmr_chain:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-6
	add	hl,sp
	ld	sp,hl
;timer.c:42: timer_t *t=tmr_first;
	ld	iy,#_tmr_first
	ld	a,0 (iy)
	ld	-2 (ix),a
	ld	a,1 (iy)
	ld	-1 (ix),a
;timer.c:43: while(t) {
00104$:
	ld	a,-1 (ix)
	or	a,-2 (ix)
	jp	Z,00106$
;timer.c:44: if (t->_tick_count==0) { /* trig it */
	ld	a,-2 (ix)
	add	a, #0x08
	ld	-4 (ix),a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	a,(hl)
	ld	-6 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-5 (ix), a
	or	a,-6 (ix)
	jr	NZ,00102$
;timer.c:45: t->_tick_count=t->ticks;			
	ld	a,-2 (ix)
	add	a, #0x06
	ld	l,a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	h,a
	ld	d,(hl)
	inc	hl
	ld	e,(hl)
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),d
	inc	hl
	ld	(hl),e
;timer.c:46: t->hook();
	ld	a,-2 (ix)
	add	a, #0x04
	ld	l,a
	ld	a,-1 (ix)
	adc	a, #0x00
	ld	h,a
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	call	__sdcc_call_hl
	jr	00103$
00102$:
;timer.c:47: } else t->_tick_count--;
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	a,(hl)
	ld	-6 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-5 (ix),a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	dec	hl
	ld	-6 (ix),l
	ld	-5 (ix),h
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	a,-6 (ix)
	ld	(hl),a
	inc	hl
	ld	a,-5 (ix)
	ld	(hl),a
00103$:
;timer.c:48: t=t->next;
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	a,(hl)
	ld	-2 (ix),a
	inc	hl
	ld	a,(hl)
	ld	-1 (ix),a
	jp	00104$
00106$:
;timer.c:50: last_error=RESULT_SUCCESS;
	ld	hl,#_last_error + 0
	ld	(hl), #0x00
	ld	sp,ix
	pop	ix
	ret
_tmr_chain_end::
	.area _CODE
	.area _CABS
