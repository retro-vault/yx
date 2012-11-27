;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:21:24 2012
;--------------------------------------------------------
	.module event
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _di
	.globl _ei
	.globl _lst_find
	.globl _lst_delete
	.globl _lst_insert
	.globl _evt_first
	.globl _evt_create
	.globl _evt_destroy
	.globl _evt_set
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_evt_first::
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
;event.c:9: event_t *evt_first=NULL;
	ld	iy,#_evt_first
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
;event.c:14: event_t *evt_create(word owner) {
;	---------------------------------
; Function evt_create
; ---------------------------------
_evt_create_start::
_evt_create:
	push	ix
	ld	ix,#0
	add	ix,sp
;event.c:16: di();
	call	_di
;event.c:17: e=(event_t *)lst_insert((list_header_t **)&evt_first, sizeof(event_t),owner);
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	de,#_evt_first
	push	bc
	ld	hl,#0x0005
	push	hl
	push	de
	call	_lst_insert
	pop	af
	pop	af
	pop	af
	ex	de,hl
;event.c:18: e->state=nonsignaled;
	ld	hl,#0x0004
	add	hl,de
	ld	(hl),#0x00
;event.c:19: ei();
	push	de
	call	_ei
;event.c:20: return e;
	pop	hl
	pop	ix
	ret
_evt_create_end::
;event.c:26: result evt_destroy(event_t *e) {
;	---------------------------------
; Function evt_destroy
; ---------------------------------
_evt_destroy_start::
_evt_destroy:
	push	ix
	ld	ix,#0
	add	ix,sp
;event.c:28: di();
	call	_di
;event.c:29: r=lst_delete((list_header_t **)&evt_first, (list_header_t *)e, 1);
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	bc,#_evt_first
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
;event.c:30: ei();
	push	de
	call	_ei
	pop	de
;event.c:31: return r;
	ld	l,d
	pop	ix
	ret
_evt_destroy_end::
;event.c:37: result evt_set(event_t *e, event_state_t newstate) {
;	---------------------------------
; Function evt_set
; ---------------------------------
_evt_set_start::
_evt_set:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;event.c:42: di();
	call	_di
;event.c:43: r=lst_find((list_header_t *)evt_first, (list_header_t **)last, (list_header_t *)e);
	ld	e,4 (ix)
	ld	d,5 (ix)
	ld	c,-2 (ix)
	ld	b,-1 (ix)
	ld	iy,(_evt_first)
	push	de
	push	bc
	push	iy
	call	_lst_find
	pop	af
	pop	af
	pop	af
	ld	d,l
;event.c:44: if (r==RESULT_SUCCESS)
	ld	a,d
	or	a, a
	jr	NZ,00102$
;event.c:45: e->state=newstate;
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	bc,#0x0004
	add	hl,bc
	ld	a,6 (ix)
	ld	(hl),a
00102$:
;event.c:46: ei();
	push	de
	call	_ei
	pop	de
;event.c:47: return r;
	ld	l,d
	ld	sp,ix
	pop	ix
	ret
_evt_set_end::
	.area _CODE
	.area _CABS
