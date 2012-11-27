;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:50:40 2012
;--------------------------------------------------------
	.module font
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _fnt_get_font_info
	.globl _fnt_measure_string
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
;font.c:11: void fnt_get_font_info(
;	---------------------------------
; Function fnt_get_font_info
; ---------------------------------
_fnt_get_font_info_start::
_fnt_get_font_info:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-9
	add	hl,sp
	ld	sp,hl
;font.c:25: (*bytes_per_glyph_line)	=	1;
	ld	a,6 (ix)
	ld	-2 (ix),a
	ld	a,7 (ix)
	ld	-1 (ix),a
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),#0x01
;font.c:26: (*glyph_lines)		=	8;
	ld	c,8 (ix)
	ld	b,9 (ix)
	ld	a,#0x08
	ld	(bc),a
;font.c:27: (*xmax)			=	0;
	ld	a,10 (ix)
	ld	-4 (ix),a
	ld	a,11 (ix)
	ld	-3 (ix),a
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),#0x00
;font.c:28: (*descent)		=	0;
	ld	a,12 (ix)
	ld	-6 (ix),a
	ld	a,13 (ix)
	ld	-5 (ix),a
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),#0x00
;font.c:29: (*xmin)			=	0;
	ld	e,14 (ix)
	ld	d,15 (ix)
	ld	a,#0x00
	ld	(de),a
;font.c:31: switch(font->font_generation) {
	ld	a,4 (ix)
	ld	-8 (ix),a
	ld	a,5 (ix)
	ld	-7 (ix),a
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	a,(hl)
	ld	-9 (ix), a
	sub	a, #0x07
	jr	Z,00102$
	ld	a,-9 (ix)
	sub	a, #0x0C
	jr	NZ,00103$
;font.c:33: (*xmin)=font->xmin;
	ld	a,-8 (ix)
	add	a, #0x07
	ld	l,a
	ld	a,-7 (ix)
	adc	a, #0x00
	ld	h,a
	ld	a,(hl)
	ld	(de),a
;font.c:34: case FGEN_1: 
00102$:
;font.c:35: (*bytes_per_glyph_line)=font->bytes_per_glyph_line;
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	(hl),a
;font.c:36: (*glyph_lines)=font->glyph_lines;
	ld	iy,#0x0004
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	add	iy, de
	ld	a, 0 (iy)
	ld	(bc),a
;font.c:37: (*xmax)=font->xmax;
	ld	iy,#0x0005
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	add	iy, de
	ld	a, 0 (iy)
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	(hl),a
;font.c:38: (*descent)=font->descent;
	ld	iy,#0x0006
	ld	e,-8 (ix)
	ld	d,-7 (ix)
	add	iy, de
	ld	a, 0 (iy)
	ld	l,-6 (ix)
	ld	h,-5 (ix)
	ld	(hl),a
;font.c:40: }
00103$:
;font.c:42: (*first_glyph_addr) = ((word)font) + (font->font_generation);
	ld	a,16 (ix)
	ld	-8 (ix),a
	ld	a,17 (ix)
	ld	-7 (ix),a
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	e,-9 (ix)
	ld	d,#0x00
	add	hl,de
	ex	de,hl
	ld	l,-8 (ix)
	ld	h,-7 (ix)
	ld	(hl),e
	inc	hl
	ld	(hl),d
;font.c:43: (*glyph_size_in_bytes) = ( (*glyph_lines) + 1 ) * (*bytes_per_glyph_line) + 1 ;
	ld	e,18 (ix)
	ld	d,19 (ix)
	ld	a,(bc)
	ld	c,a
	ld	b,#0x00
	inc	bc
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	ld	l,(hl)
	ld	h,#0x00
	push	de
	push	hl
	push	bc
	call	__mulint_rrx_s
	pop	af
	pop	af
	pop	de
	inc	hl
	ex	de,hl
	ld	(hl),e
	inc	hl
	ld	(hl),d
	ld	sp,ix
	pop	ix
	ret
_fnt_get_font_info_end::
;font.c:47: void fnt_measure_string(font_t *font, string string, byte *widths)
;	---------------------------------
; Function fnt_measure_string
; ---------------------------------
_fnt_measure_string_start::
_fnt_measure_string:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-17
	add	hl,sp
	ld	sp,hl
;font.c:55: fnt_get_font_info(font, &bpg, &gl, &xmax, &descent, &xmin, &addr0, &glyph_size);
	ld	hl,#0x0008
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	hl,#0x000A
	add	hl,sp
	ex	de,hl
	ld	hl,#0x000C
	add	hl,sp
	ld	-11 (ix),l
	ld	-10 (ix),h
	ld	hl,#0x000D
	add	hl,sp
	ld	-13 (ix),l
	ld	-12 (ix),h
	ld	hl,#0x000E
	add	hl,sp
	ld	-15 (ix),l
	ld	-14 (ix),h
	ld	hl,#0x000F
	add	hl,sp
	ld	-17 (ix),l
	ld	-16 (ix),h
	ld	iy,#0x0010
	add	iy,sp
	push	bc
	push	de
	ld	l,-11 (ix)
	ld	h,-10 (ix)
	push	hl
	ld	l,-13 (ix)
	ld	h,-12 (ix)
	push	hl
	ld	l,-15 (ix)
	ld	h,-14 (ix)
	push	hl
	ld	l,-17 (ix)
	ld	h,-16 (ix)
	push	hl
	push	iy
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_fnt_get_font_info
	ld	hl,#0x0010
	add	hl,sp
	ld	sp,hl
	ld	sp,ix
	pop	ix
	ret
_fnt_measure_string_end::
	.area _CODE
	.area _CABS
