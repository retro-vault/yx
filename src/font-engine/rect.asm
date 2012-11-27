;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:50:40 2012
;--------------------------------------------------------
	.module rect
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _rct_intersect
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
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
;rect.c:9: boolean rct_intersect(rect_t *r1, rect_t *r2) __naked {
;	---------------------------------
; Function rct_intersect
; ---------------------------------
_rct_intersect_start::
_rct_intersect:
;rect.c:62: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	ld	e,4(iy)
	ld	d,5(iy)
	rct_intersect_raw::
	push	ix
	push	hl
	push	de
	pop	iy
	pop	ix
	ld	a,(ix)
	cp	2(iy)
	jr	nc, ri_false
	ld	a,2(ix)
	cp	(iy)
	jr	c, ri_false
	ld	a,1(ix)
	cp	3(iy)
	jr	nc, ri_false
	ld	a,3(ix)
	cp	1(iy)
	jr	c,ri_false
	ld	l,#1
	jr	ri_end
	ri_false:
	ld	l,#0
	ri_end:
	pop	ix
	ret
_rct_intersect_end::
	.area _CODE
	.area _CABS
