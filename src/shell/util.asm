;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:32:55 2012
;--------------------------------------------------------
	.module util
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _strcmp
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
;util.c:12: byte strcmp(string s1, string s2)
;	---------------------------------
; Function strcmp
; ---------------------------------
_strcmp_start::
_strcmp:
	push	ix
	ld	ix,#0
	add	ix,sp
	push	af
;util.c:14: while((*s1 && *s2) && (*s1++ == *s2++));
	ld	c,4 (ix)
	ld	b,5 (ix)
	ld	e,6 (ix)
	ld	d,7 (ix)
00103$:
	ld	a,(bc)
	ld	-1 (ix), a
	or	a, a
	jr	Z,00105$
	ld	a,(de)
	ld	-2 (ix), a
	or	a, a
	jr	Z,00105$
	inc	bc
	inc	de
	ld	a,-1 (ix)
	sub	a, -2 (ix)
	jr	Z,00103$
00105$:
;util.c:15: return *(--s1) - *(--s2);
	dec	bc
	ld	a,(bc)
	ld	b,a
	dec	de
	ld	a,(de)
	ld	e,a
	ld	a,b
	sub	a, e
	ld	l, a
	ld	sp,ix
	pop	ix
	ret
_strcmp_end::
	.area _CODE
	.area _CABS
