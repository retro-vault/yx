;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.1.0 #7066 (Jun 14 2012) (Linux)
; This file was generated Tue Nov 27 20:50:39 2012
;--------------------------------------------------------
	.module test
	.optsdcc -mz80
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _g_clip_margins
	.globl _g_translate_coordinates
	.globl _main
	.globl _ocra_font
	.globl _sinserif_font
	.globl _liquid_font
	.globl _c64_font
	.globl _c60s_font
	.globl _cour_new_font
	.globl _envy_font
	.globl _chicago_font
	.globl _fnt_get_font_info
	.globl _last_error
	.globl _delta_g
	.globl _screen_rect
	.globl _shadow_screen
	.globl _screen
	.globl _g_draw_text
	.globl _g_draw_clipped_glyph
	.globl _g_init
	.globl _directg_realize
	.globl _mem_copy
	.globl _string_length
	.globl _mem_set
	.globl _directg_vmem_addr
	.globl _directg_vmem_nextrow_addr
	.globl _shift_buffer_right
	.globl _directg_aligned_glyph_16x16
	.globl _directg_render_masked_glyph_16x16
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
;--------------------------------------------------------
;  ram data
;--------------------------------------------------------
	.area _DATA
_screen::
	.ds 2
_shadow_screen::
	.ds 2
_screen_rect::
	.ds 4
_delta_g::
	.ds 2
_last_error::
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
;test.c:15: result last_error = RESULT_SUCCESS; /* last error, 0 = success */
	ld	iy,#_last_error
	ld	0 (iy),#0x00
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;test.c:18: void main() {
;	---------------------------------
; Function main
; ---------------------------------
_main_start::
_main:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-10
	add	hl,sp
	ld	sp,hl
;test.c:24: g_init(); /* initialize graphics */
	call	_g_init
;test.c:27: g.clip_rect = &screen_rect;
	ld	hl,#0x0004
	add	hl,sp
	ld	e, h
	ld	h,e
	ld	(hl),#<(_screen_rect)
	inc	hl
	ld	(hl),#>(_screen_rect)
;test.c:28: g.delta_g = 0;
	ld	hl,#0x0004
	add	hl,sp
	ld	e,l
	ld	d,h
	inc	hl
	inc	hl
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;test.c:29: g.coord_sys = NULL; /* absolute coordinates */
	ld	hl,#0x0004
	add	hl,de
	xor	a, a
	ld	(hl), a
	inc	hl
	ld	(hl), a
;test.c:31: mstart=screen;
	ld	de,(_screen)
;test.c:32: mem_set(mstart, 0b00000000, VIDEO_MEM_SIZE);
	push	de
	ld	hl,#0x1800
	push	hl
	ld	a,#0x00
	push	af
	inc	sp
	push	de
	call	_mem_set
	pop	af
	pop	af
	inc	sp
	pop	de
;test.c:33: mstart+=VIDEO_MEM_SIZE;
	ld	hl,#0x1800
	add	hl,de
	ex	de,hl
;test.c:34: mem_set(mstart, 0b00111000, ATTR_MEM_SIZE);
	ld	hl,#0x0300
	push	hl
	ld	a,#0x38
	push	af
	inc	sp
	push	de
	call	_mem_set
	pop	af
	pop	af
	inc	sp
;test.c:36: POPULATE_RECT((g.clip_rect),0,0,255,191)
	ld	hl,#0x0004
	add	hl,sp
	ld	d,l
	ld	b,h
	ld	a,(hl)
	inc	hl
	ld	h,(hl)
	ld	l,a
	ld	(hl),#0x00
	ld	l,d
	ld	h,b
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	l,e
	ld	h,d
	inc	hl
	ld	(hl),#0x00
	ld	l,e
	ld	h,d
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	inc	de
	inc	de
	inc	de
	ld	a,#0xBF
	ld	(de),a
;test.c:38: POPULATE_RECT((&r),0,0,MAX_X,10)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x00
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x0A
;test.c:39: g_draw_text(&g,liquid_font(),"This is liquid font! ABCDE",&r);
	push	bc
	call	_liquid_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_0
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:40: POPULATE_RECT((&r),0,10,MAX_X,20)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x0A
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x14
;test.c:41: g_draw_text(&g,c64_font(),"This is c64 font! ABCDE",&r);
	push	bc
	call	_c64_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_1
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:42: POPULATE_RECT((&r),0,20,MAX_X,30)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x14
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x1E
;test.c:43: g_draw_text(&g,c60s_font(),"This is c60s font! ABCDE",&r);
	push	bc
	call	_c60s_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_2
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:44: POPULATE_RECT((&r),0,30,MAX_X,40)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x1E
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x28
;test.c:45: g_draw_text(&g,cour_new_font(),"This is courier new font! ABCDE",&r);
	push	bc
	call	_cour_new_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_3
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:46: POPULATE_RECT((&r),0,40,MAX_X,50)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x28
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x32
;test.c:47: g_draw_text(&g,envy_font(),"This is envy font! ABCDE",&r);
	push	bc
	call	_envy_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_4
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:48: POPULATE_RECT((&r),0,50,MAX_X,60)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x32
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x3C
;test.c:49: g_draw_text(&g,ocra_font(),"This is ocra font! ABCDE",&r);
	push	bc
	call	_ocra_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_5
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:50: POPULATE_RECT((&r),0,60,MAX_X,70)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x3C
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x46
;test.c:51: g_draw_text(&g,sinserif_font(),"This is sinserif font! ABCDE",&r);
	push	bc
	call	_sinserif_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_6
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	pop	af
	pop	af
	pop	af
	pop	af
;test.c:52: POPULATE_RECT((&r),0,70,MAX_X,80)
	ld	hl,#0x0000
	add	hl,sp
	ld	(hl),#0x00
	ld	hl,#0x0000
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	ld	(hl),#0x46
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	ld	(hl),#0xFF
	ld	l,c
	ld	h,b
	inc	hl
	inc	hl
	inc	hl
	ld	(hl),#0x50
;test.c:53: g_draw_text(&g,chicago_font(),"This is chicago font! ABCDE",&r);	
	push	bc
	call	_chicago_font
	pop	bc
	ex	de,hl
	ld	iy,#0x0004
	add	iy,sp
	push	bc
	ld	hl,#__str_7
	push	hl
	push	de
	push	iy
	call	_g_draw_text
	ld	sp,ix
	pop	ix
	ret
_main_end::
__str_0:
	.ascii "This is liquid font! ABCDE"
	.db 0x00
__str_1:
	.ascii "This is c64 font! ABCDE"
	.db 0x00
__str_2:
	.ascii "This is c60s font! ABCDE"
	.db 0x00
__str_3:
	.ascii "This is courier new font! ABCDE"
	.db 0x00
__str_4:
	.ascii "This is envy font! ABCDE"
	.db 0x00
__str_5:
	.ascii "This is ocra font! ABCDE"
	.db 0x00
__str_6:
	.ascii "This is sinserif font! ABCDE"
	.db 0x00
__str_7:
	.ascii "This is chicago font! ABCDE"
	.db 0x00
;test.c:56: void g_translate_coordinates(graphics_t *g, byte *x, byte *y) {
;	---------------------------------
; Function g_translate_coordinates
; ---------------------------------
_g_translate_coordinates_start::
_g_translate_coordinates:
	push	ix
	ld	ix,#0
	add	ix,sp
	dec	sp
;test.c:60: if (g->coord_sys) { 
	ld	l,4 (ix)
	ld	h,5 (ix)
	ld	bc,#0x0004
	add	hl,bc
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	a,d
	or	a,e
	jr	Z,00103$
;test.c:61: (*x) += (g->coord_sys->origin_x);
	ld	c,6 (ix)
	ld	b,7 (ix)
	push	bc
	pop	iy
	ld	b, 0 (iy)
	ld	a,(de)
	add	a,b
	ld	0 (iy), a
;test.c:62: (*y) += (g->coord_sys->origin_y);
	ld	c,8 (ix)
	ld	b,9 (ix)
	ld	a,(bc)
	ld	-1 (ix),a
	inc	de
	ld	a,(de)
	ld	h,a
	ld	a,-1 (ix)
	add	a, h
	ld	(bc),a
00103$:
	ld	sp,ix
	pop	ix
	ret
_g_translate_coordinates_end::
;test.c:67: boolean g_clip_margins(graphics_t *g, rect_t *r, margins_t *m, byte *lmask, byte *rmask) __naked {
;	---------------------------------
; Function g_clip_margins
; ---------------------------------
_g_clip_margins_start::
_g_clip_margins:
;test.c:180: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	ld	l,4(iy)
	ld	h,5(iy)
	ld	c,6(iy)
	ld	b,7(iy)
	exx
	ld	e,8(iy)
	ld	d,9(iy)
	ld	l,10(iy)
	ld	h,11(iy)
	exx
	g_clip_margins_raw::
	push	ix
	push	hl
	push	de
	call	rct_intersect_raw
	pop	iy
	pop	ix
	ld	a,l
	cp	#0
	jr	z,cm_no_clipping
	cm_left:
	xor	a
	ld	(bc),a
	ld	a,(iy)
	sub	(ix)
	jr	c,cm_top
	ld	(bc),a
	cm_top:
	inc	bc
	xor	a
	ld	(bc),a
	ld	a,1(iy)
	sub	1(ix)
	jr	c,cm_right
	ld	(bc),a
	cm_right:
	inc	bc
	xor	a
	ld	(bc),a
	ld	a,2(ix)
	sub	2(iy)
	jr	c,cm_bottom
	ld	(bc),a
	cm_bottom:
	inc	bc
	xor	a
	ld	(bc),a
	ld	a,3(ix)
	sub	3(iy)
	jr	c,cm_masks
	ld	(bc),a
	cm_masks:
	dec	bc
	ld	a,(bc)
	exx
	ld	(hl),#0
	ld	b,a
	ld	a,2(ix)
	sub	b
	and	#0x07
	jr	z,cm_lmask
	ld	b,a
	xor	a
	cm_rmask_loop:
	scf
	rra
	djnz	cm_rmask_loop
	ld	(hl),a
	cm_lmask:
	ex	de,hl
	exx
	dec	bc
	dec	bc
	ld	a,(bc)
	exx
	ld	b,a
	ld	a,(ix)
	add	b
	and	#0x07
	jr	z,cm_done_mask
	ld	b,a
	xor	a
	cm_lmask_loop:
	scf
	rra
	djnz	cm_lmask_loop
	cpl
	ld	(hl),a
	cm_done_mask:
	exx
	ld	l,#1
	jr	cm_end
	cm_no_clipping:
	ld	l,#0
	cm_end:
	pop	ix
	ret
_g_clip_margins_end::
;test.c:185: void g_draw_text(graphics_t *g, font_t *font, string text, rect_t *target_rect) {
;	---------------------------------
; Function g_draw_text
; ---------------------------------
_g_draw_text_start::
_g_draw_text:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-91
	add	hl,sp
	ld	sp,hl
;test.c:190: byte x = target_rect->x0;
	ld	e,10 (ix)
	ld	d,11 (ix)
	ld	a,(de)
	ld	-1 (ix),a
;test.c:191: byte y = target_rect->y0;
	ld	l,e
	ld	h,d
	inc	hl
	ld	a,(hl)
	ld	-2 (ix),a
;test.c:230: if (!g_clip_margins(g, target_rect, &clip_margins, &lmask, &rmask)) return;
	ld	hl,#0x0053
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	hl,#0x0054
	add	hl,sp
	ld	-83 (ix),l
	ld	-82 (ix),h
	ld	iy,#0x0055
	add	iy,sp
	push	bc
	ld	l,-83 (ix)
	ld	h,-82 (ix)
	push	hl
	push	iy
	push	de
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_g_clip_margins
	ld	iy,#0x000A
	add	iy,sp
	ld	sp,iy
	ld	a, l
	or	a, a
	jp	Z,00106$
;test.c:240: &char_size);
	ld	hl,#0x004A
	add	hl,sp
	ex	de,hl
;test.c:239: &first_char_addr,
	ld	hl,#0x004C
	add	hl,sp
	ld	-83 (ix),l
	ld	-82 (ix),h
;test.c:238: &xmin,
	ld	hl,#0x004E
	add	hl,sp
	ld	-85 (ix),l
	ld	-84 (ix),h
;test.c:237: &descent,
	ld	hl,#0x004F
	add	hl,sp
	ld	c,l
	ld	b,h
;test.c:236: &xmax,
	ld	hl,#0x0050
	add	hl,sp
	ld	-87 (ix),l
	ld	-86 (ix),h
;test.c:235: &glyph_lines,
	ld	hl,#0x0051
	add	hl,sp
	ld	-89 (ix),l
	ld	-88 (ix),h
;test.c:234: &bytes_per_glyph_line,
	ld	hl,#0x0052
	add	hl,sp
	ld	-91 (ix),l
	ld	-90 (ix),h
;test.c:233: font, 
	push	de
	ld	l,-83 (ix)
	ld	h,-82 (ix)
	push	hl
	ld	l,-85 (ix)
	ld	h,-84 (ix)
	push	hl
	push	bc
	ld	l,-87 (ix)
	ld	h,-86 (ix)
	push	hl
	ld	l,-89 (ix)
	ld	h,-88 (ix)
	push	hl
	ld	l,-91 (ix)
	ld	h,-90 (ix)
	push	hl
	ld	l,6 (ix)
	ld	h,7 (ix)
	push	hl
	call	_fnt_get_font_info
	ld	hl,#0x0010
	add	hl,sp
	ld	sp,hl
;test.c:242: g_translate_coordinates(g,&x,&y);
	ld	hl,#0x0059
	add	hl,sp
	ex	de,hl
	ld	hl,#0x005A
	add	hl,sp
	push	de
	push	hl
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_g_translate_coordinates
	pop	af
	pop	af
	pop	af
;test.c:245: while (*text) {
	ld	c,6 (ix)
	ld	b,7 (ix)
	inc	bc
	ld	a,8 (ix)
	ld	-91 (ix),a
	ld	a,9 (ix)
	ld	-90 (ix),a
00103$:
	ld	l,-91 (ix)
	ld	h,-90 (ix)
	ld	a,(hl)
	ld	-89 (ix), a
	or	a, a
	jp	Z,00106$
;test.c:251: delta_ch = ( (*text) - (font->first_ascii) );
	ld	a,(bc)
	ld	d,a
	ld	a,-89 (ix)
	sub	a, d
;test.c:253: delta_ch * char_size;
	ld	e,a
	ld	d,#0x00
	push	bc
	ld	l,-17 (ix)
	ld	h,-16 (ix)
	push	hl
	push	de
	call	__mulint_rrx_s
	pop	af
	pop	af
	ld	e,l
	ld	d,h
	pop	bc
	push	hl
	ld	l,-15 (ix)
	ld	h,-14 (ix)
	push	hl
	pop	iy
	pop	hl
	add	iy, de
;test.c:258: x = x + xmin;
	ld	a,-1 (ix)
	add	a, -13 (ix)
	ld	-1 (ix),a
;test.c:260: width = ( ((byte *)char_addr)[char_size-1] );			
	push	iy
	pop	de
	ld	a,-17 (ix)
	add	a,#0xFF
	ld	-89 (ix),a
	ld	a,-16 (ix)
	adc	a,#0xFF
	ld	-88 (ix),a
	ld	l,-89 (ix)
	ld	h,-88 (ix)
	add	hl,de
	ld	e,(hl)
;test.c:261: g_draw_clipped_glyph(g, char_addr,x,y,bytes_per_glyph_line,glyph_lines);		
	push	bc
	push	de
	ld	h,-10 (ix)
	ld	l,-9 (ix)
	push	hl
	ld	h,-2 (ix)
	ld	l,-1 (ix)
	push	hl
	push	iy
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_g_draw_clipped_glyph
	pop	af
	pop	af
	pop	af
	pop	af
	pop	de
	pop	bc
;test.c:263: x = x + width + xmax;
	ld	a,-1 (ix)
	add	a, e
	add	a, -11 (ix)
	ld	-1 (ix),a
;test.c:265: text++;
	inc	-91 (ix)
	jp	NZ,00103$
	inc	-90 (ix)
	jp	00103$
00106$:
	ld	sp,ix
	pop	ix
	ret
_g_draw_text_end::
;test.c:270: void g_draw_clipped_glyph(graphics_t *g, word glyph, byte x, byte y, byte bytes_per_glyph_line, byte glyph_lines) {
;	---------------------------------
; Function g_draw_clipped_glyph
; ---------------------------------
_g_draw_clipped_glyph_start::
_g_draw_clipped_glyph:
	push	ix
	ld	ix,#0
	add	ix,sp
	ld	hl,#-97
	add	hl,sp
	ld	sp,hl
;test.c:289: POPULATE_RECT((&glyph_rect),x,y,x+(bytes_per_glyph_line<<3)-1,y+glyph_lines-1)
	ld	hl,#0x0056
	add	hl,sp
	ld	a,8 (ix)
	ld	(hl),a
	ld	hl,#0x0056
	add	hl,sp
	ld	e,l
	ld	d,h
	inc	hl
	ld	a,9 (ix)
	ld	(hl),a
	ld	c,e
	ld	b,d
	inc	bc
	inc	bc
	ld	a,10 (ix)
	rlca
	rlca
	rlca
	and	a,#0xF8
	ld	h,a
	ld	a,8 (ix)
	add	a, h
	dec	a
	ld	(bc),a
	ld	c,e
	ld	b,d
	inc	bc
	inc	bc
	inc	bc
	ld	a,9 (ix)
	add	a, 11 (ix)
	dec	a
	ld	(bc),a
;test.c:290: if (!g_clip_margins(g, &glyph_rect, &clip_margins, &lmask, &rmask)) return;
	ld	hl,#0x0050
	add	hl,sp
	ld	c,l
	ld	b,h
	ld	hl,#0x0051
	add	hl,sp
	ld	-83 (ix),l
	ld	-82 (ix),h
	ld	hl,#0x0052
	add	hl,sp
	ld	-85 (ix),l
	ld	-84 (ix),h
	push	bc
	ld	l,-83 (ix)
	ld	h,-82 (ix)
	push	hl
	ld	l,-85 (ix)
	ld	h,-84 (ix)
	push	hl
	push	de
	ld	l,4 (ix)
	ld	h,5 (ix)
	push	hl
	call	_g_clip_margins
	ld	iy,#0x000A
	add	iy,sp
	ld	sp,iy
	ld	a, l
	or	a, a
	jp	Z,00122$
;test.c:292: shift_bits = x & 0x07;
	ld	a,8 (ix)
	and	a, #0x07
	ld	-7 (ix),a
;test.c:297: mem_copy(mask,glyph,bytes_per_glyph_line);
	ld	c,10 (ix)
	ld	b,#0x00
	ld	e,6 (ix)
	ld	d,7 (ix)
	ld	hl,#0x0030
	add	hl,sp
	ld	-85 (ix),l
	ld	-84 (ix),h
	push	hl
	ld	l,-85 (ix)
	ld	h,-84 (ix)
	push	hl
	pop	iy
	pop	hl
	push	bc
	push	de
	push	iy
	call	_mem_copy
	pop	af
	pop	af
	pop	af
;test.c:298: mask[bytes_per_glyph_line]=0;
	ld	a,-85 (ix)
	add	a, 10 (ix)
	ld	e,a
	ld	a,-84 (ix)
	adc	a, #0x00
	ld	d,a
	ld	a,#0x00
	ld	(de),a
;test.c:299: glyph += bytes_per_glyph_line; /* skip over mask */		
	ld	a,10 (ix)
	ld	-83 (ix), a
	ld	-87 (ix),a
	ld	-86 (ix),#0x00
	ld	a,6 (ix)
	add	a, -87 (ix)
	ld	6 (ix),a
	ld	a,7 (ix)
	adc	a, -86 (ix)
	ld	7 (ix),a
;test.c:300: if (shift_bits)
	ld	a,-7 (ix)
	or	a, a
	jr	Z,00104$
;test.c:301: shift_buffer_right((word)mask, bytes_per_glyph_line + 1, shift_bits, 0x80);	
	ld	b,-83 (ix)
	inc	b
	ld	e,-85 (ix)
	ld	d,-84 (ix)
	ld	a,#0x80
	push	af
	inc	sp
	ld	a,-7 (ix)
	push	af
	inc	sp
	push	bc
	inc	sp
	push	de
	call	_shift_buffer_right
	pop	af
	pop	af
	inc	sp
00104$:
;test.c:305: glyph += (bytes_per_glyph_line * clip_margins.top);
	ld	hl,#0x0052+1
	add	hl,sp
	ld	c,(hl)
	ld	e,c
	ld	h,-83 (ix)
	ld	l,#0x00
	ld	d,l
	ld	b,#0x08
00137$:
	add	hl,hl
	jr	NC,00138$
	add	hl,de
00138$:
	djnz	00137$
	ld	d,l
	ld	e,h
	ld	a,6 (ix)
	add	a, d
	ld	6 (ix),a
	ld	a,7 (ix)
	adc	a, e
	ld	7 (ix),a
;test.c:306: line = clip_margins.top;
	ld	d,c
;test.c:307: y += clip_margins.top;
	ld	a,9 (ix)
	add	a, c
;test.c:308: dest_addr = directg_vmem_addr(x,y);
	ld	9 (ix), a
	push	de
	push	af
	inc	sp
	ld	a,8 (ix)
	push	af
	inc	sp
	call	_directg_vmem_addr
	pop	af
	pop	de
	ld	-2 (ix),l
	ld	-1 (ix),h
;test.c:309: glyph_lines-=clip_margins.bottom;
	ld	hl,#0x0052
	add	hl,sp
	ld	c,l
	ld	b,h
	inc	hl
	inc	hl
	inc	hl
	ld	a,11 (ix)
	sub	a,(hl)
	ld	11 (ix),a
;test.c:314: b_beg = (clip_margins.left>>3);
	ld	a,(bc)
	srl	a
	srl	a
	srl	a
	ld	-5 (ix),a
;test.c:315: b_end = bytes_per_glyph_line - (clip_margins.right>>3) + 1;
	inc	bc
	inc	bc
	ld	a,(bc)
	ld	e,a
	srl	e
	srl	e
	srl	e
	ld	a,-83 (ix)
	sub	a, e
	inc	a
	ld	-6 (ix),a
;test.c:317: while (line < glyph_lines) {
	ld	a,-83 (ix)
	inc	a
	ld	-88 (ix),a
	ld	hl,#0x0010
	add	hl,sp
	ld	-90 (ix),l
	ld	-89 (ix),h
	ld	hl,#0x0052
	add	hl,sp
	ld	-92 (ix),l
	ld	-91 (ix),h
	ld	hl,#0x0052
	add	hl,sp
	ld	a,l
	add	a, #0x02
	ld	-94 (ix),a
	ld	a,h
	adc	a, #0x00
	ld	-93 (ix),a
	ld	-95 (ix),d
00115$:
	ld	a,-95 (ix)
	sub	a, 11 (ix)
	jp	NC,00122$
;test.c:318: mem_copy(pattern,glyph,bytes_per_glyph_line);
	ld	e,6 (ix)
	ld	d,7 (ix)
	ld	c,-90 (ix)
	ld	b,-89 (ix)
	ld	l,-87 (ix)
	ld	h,-86 (ix)
	push	hl
	push	de
	push	bc
	call	_mem_copy
	pop	af
	pop	af
	pop	af
;test.c:319: pattern[bytes_per_glyph_line]=0;
	ld	a,-90 (ix)
	add	a, -83 (ix)
	ld	l,a
	ld	a,-89 (ix)
	adc	a, #0x00
	ld	h,a
	ld	(hl),#0x00
;test.c:320: glyph += bytes_per_glyph_line;
	ld	a,6 (ix)
	add	a, -87 (ix)
	ld	6 (ix),a
	ld	a,7 (ix)
	adc	a, -86 (ix)
	ld	7 (ix),a
;test.c:321: if (shift_bits)
	ld	a,-7 (ix)
	or	a, a
	jr	Z,00106$
;test.c:322: shift_buffer_right((word)pattern, bytes_per_glyph_line + 1, shift_bits, 0x00);
	ld	a,-90 (ix)
	ld	-97 (ix),a
	ld	a,-89 (ix)
	ld	-96 (ix),a
	ld	a,#0x00
	push	af
	inc	sp
	ld	h,-7 (ix)
	ld	l,-88 (ix)
	push	hl
	ld	l,-97 (ix)
	ld	h,-96 (ix)
	push	hl
	call	_shift_buffer_right
	pop	af
	pop	af
	inc	sp
00106$:
;test.c:324: v=(byte *)dest_addr;
	ld	a,-2 (ix)
	ld	-4 (ix),a
	ld	a,-1 (ix)
	ld	-3 (ix),a
;test.c:325: for (b=b_beg; b < b_end; b++)
	ld	e,-5 (ix)
00118$:
	ld	a,e
	sub	a, -6 (ix)
	jr	NC,00121$
;test.c:326: if (clip_margins.left && b==b_beg)
	ld	l,-92 (ix)
	ld	h,-91 (ix)
	ld	a,(hl)
	or	a, a
	jr	Z,00112$
	ld	a,e
	sub	a, -5 (ix)
	jr	NZ,00112$
;test.c:327: v[b] = ~lmask; // v[b] & ~lmask | pattern[b] & lmask; 
	ld	a,-4 (ix)
	add	a, e
	ld	c,a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	b,a
	ld	a,-16 (ix)
	cpl
	ld	d,a
	ld	(bc),a
	jr	00120$
00112$:
;test.c:328: else if (clip_margins.right && b==b_end)
	ld	l,-94 (ix)
	ld	h,-93 (ix)
	ld	a,(hl)
	or	a, a
	jr	Z,00108$
	ld	a,e
	sub	a, -6 (ix)
	jr	NZ,00108$
;test.c:329: v[b] = rmask;
	ld	l,-4 (ix)
	ld	h,-3 (ix)
	ld	d,#0x00
	add	hl, de
	ld	a,-17 (ix)
	ld	(hl),a
	jr	00120$
00108$:
;test.c:331: v[b] = v[b] & mask[b] | pattern[b];			
	ld	a,-4 (ix)
	add	a, e
	ld	c,a
	ld	a,-3 (ix)
	adc	a, #0x00
	ld	b,a
	ld	a,(bc)
	ld	-97 (ix),a
	ld	l,-85 (ix)
	ld	h,-84 (ix)
	ld	d,#0x00
	add	hl, de
	ld	a,(hl)
	and	a, -97 (ix)
	ld	d,a
	ld	a,-90 (ix)
	add	a, e
	ld	l,a
	ld	a,-89 (ix)
	adc	a, #0x00
	ld	h,a
	ld	a,(hl)
	or	a, d
	ld	(bc),a
00120$:
;test.c:325: for (b=b_beg; b < b_end; b++)
	inc	e
	jp	00118$
00121$:
;test.c:333: dest_addr=directg_vmem_nextrow_addr(dest_addr);
	ld	l,-2 (ix)
	ld	h,-1 (ix)
	push	hl
	call	_directg_vmem_nextrow_addr
	pop	af
	ld	-2 (ix),l
	ld	-1 (ix),h
;test.c:334: line++;
	inc	-95 (ix)
	jp	00115$
00122$:
	ld	sp,ix
	pop	ix
	ret
_g_draw_clipped_glyph_end::
;test.c:338: void g_init() {
;	---------------------------------
; Function g_init
; ---------------------------------
_g_init_start::
_g_init:
;test.c:346: shadow_screen=(byte *)50000;
	ld	iy,#_shadow_screen
	ld	0 (iy),#0x50
	ld	1 (iy),#0xC3
;test.c:347: screen=(byte *)VIDEO_MEM_ADDR;
	ld	iy,#_screen
	ld	0 (iy),#0x00
	ld	1 (iy),#0x40
;test.c:348: delta_g = shadow_screen - screen;
	ld	iy,#_delta_g
	ld	0 (iy),#0x50
	ld	1 (iy),#0x83
;test.c:353: POPULATE_RECT((&screen_rect), 0, 0, MAX_X, MAX_Y)
	ld	hl,#_screen_rect
	ld	(hl),#0x00
	ld	hl,#_screen_rect + 1
	ld	(hl),#0x00
	ld	hl,#_screen_rect + 2
	ld	(hl),#0xFF
	ld	hl,#_screen_rect + 3
	ld	(hl),#0xBF
;test.c:357: mem_set(mstart, 0, VIDEO_MEM_SIZE);
	ld	hl,#0x1800
	push	hl
	ld	a,#0x00
	push	af
	inc	sp
	ld	h, #0x40
	push	hl
	call	_mem_set
	pop	af
	pop	af
	inc	sp
;test.c:359: mem_set(mstart, 0b00111000, ATTR_MEM_SIZE);
	ld	hl,#0x0300
	push	hl
	ld	a,#0x38
	push	af
	inc	sp
	ld	h, #0x58
	push	hl
	call	_mem_set
	pop	af
;test.c:361: mem_copy(shadow_screen, screen, VIDEO_MEM_SIZE + ATTR_MEM_SIZE);
	inc	sp
	ld	hl,#0x1B00
	ex	(sp),hl
	ld	hl,(_screen)
	push	hl
	ld	hl,(_shadow_screen)
	push	hl
	call	_mem_copy
	pop	af
	pop	af
	pop	af
;test.c:369: __endasm;
	ld	a,#0b00000111
	out	(#0xfe),a
	ret
_g_init_end::
;test.c:372: void directg_realize(rect_t *r) __naked {
;	---------------------------------
; Function directg_realize
; ---------------------------------
_directg_realize_start::
_directg_realize:
;test.c:462: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	ld	e,(hl)
	inc	hl
	ld	c,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	b,(hl)
	exx
	ld	a,(#_delta_g+0)
	ld	e,a
	ld	a,(#_delta_g+1)
	ld	d,a
	exx
	push	bc
	push	de
	call	directg_vmem_addr_raw
	pop	de
	pop	bc
	srl	d
	srl	d
	srl	d
	srl	e
	srl	e
	srl	e
	ld	a,b
	sub	c
	inc	a
	ld	b,a
	ld	a,d
	sub	e
	inc	a
	exx
	push	de
	exx
	pop	de
	real_y_loop:
	push	af
	push	bc
	push	de
	push	hl
	ld	b,#0
	ld	c,a
	push	hl
	add	hl,de
	pop	de
	ldir
	pop	hl
	call	directg_vmem_nextrow_addr_raw
	pop	de
	pop	bc
	pop	af
	djnz	real_y_loop
	ret
_directg_realize_end::
;test.c:465: void mem_copy(byte *dest, byte *src, word count) __naked {
;	---------------------------------
; Function mem_copy
; ---------------------------------
_mem_copy_start::
_mem_copy:
;test.c:483: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	e,2(iy)
	ld	d,3(iy)
	ld	l,4(iy)
	ld	h,5(iy)
	ld	c,6(iy)
	ld	b,7(iy)
	ldir
	ret
_mem_copy_end::
;test.c:486: word string_length(string s) __naked {
;	---------------------------------
; Function string_length
; ---------------------------------
_string_length_start::
_string_length:
;test.c:503: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	de,#0x0000
	ld	l,2(iy)
	ld	h,3(iy)
	sl_loop:
	cp	(hl)
	jr	z,sl_end
	inc	de
	inc	hl
	jr	sl_loop
	sl_end:
	ex	de,hl
	ret
_string_length_end::
;test.c:511: void mem_set(byte *dest, byte val, word count) __naked {
;	---------------------------------
; Function mem_set
; ---------------------------------
_mem_set_start::
_mem_set:
;test.c:540: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	ld	a,4(iy)
	ld	c,5(iy)
	ld	b,6(iy)
	mem_set_raw::
	dec	bc
	push	hl
	pop	de
	inc	de
	ld	(hl),a
	ldir
	ret
_mem_set_end::
;test.c:543: word directg_vmem_addr(byte x, byte y) __naked {
;	---------------------------------
; Function directg_vmem_addr
; ---------------------------------
_directg_vmem_addr_start::
_directg_vmem_addr:
;test.c:593: __endasm;
;;	get function parameters from stack
	ld	iy,#0x0000
	add	iy,sp
	ld	e,2(iy)
	ld	c,3(iy)
	directg_vmem_addr_raw::
;;	calculate row memory address
	ld	a,c
	and	#0x07
	ld	h,a
	ld	a,c
	and	#0x38
	rla
	rla
	ld	l,a
	ld	a,c
	and	#0xc0
	rra
	rra
	rra
	or	h
	or	#0x40
	ld	h,a
	ld	d,#0
	srl	e
	srl	e
	srl	e
	add	hl,de
	ret
_directg_vmem_addr_end::
;test.c:597: word directg_vmem_nextrow_addr(word addr) __naked {
;	---------------------------------
; Function directg_vmem_nextrow_addr
; ---------------------------------
_directg_vmem_nextrow_addr_start::
_directg_vmem_nextrow_addr:
;test.c:631: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	directg_vmem_nextrow_addr_raw::
	inc	h
	ld	a,h
	and	#7
	jr	nz,nextrow_done
	ld	a,l
	add	a,#32
	ld	l,a
	jr	c, nextrow_done
	ld	a,h
	sub	#8
	ld	h,a
	nextrow_done:
	ret
_directg_vmem_nextrow_addr_end::
;test.c:637: void shift_buffer_right(word start_addr, byte len, byte bits, byte lmask) __naked {
;	---------------------------------
; Function shift_buffer_right
; ---------------------------------
_shift_buffer_right_start::
_shift_buffer_right:
;test.c:678: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	l,2(iy)
	ld	h,3(iy)
	ld	c,4(iy)
	ld	e,#0x00
	ld	a,6(iy)
	or	a
	jr	z,no_mask
	ld	e,#0x80
	ld	b,5(iy)
	mask_loop:
	sra	e
	djnz	mask_loop
	sla	e
	no_mask:
	ld	d,#0
	len_loop:
	ld	a,d
	ld	d,#0
	ld	b,5(iy)
	shift_loop:
	rr	(hl)
	rr	d
	djnz	shift_loop
	or	(hl)
	ld	(hl),a
	inc	hl
	dec	c
	jr	nz,len_loop
	ld	l,2(iy)
	ld	h,3(iy)
	ld	a,e
	or	(hl)
	ld	(hl),a
	ret
_shift_buffer_right_end::
;test.c:681: void directg_aligned_glyph_16x16(byte x, byte y, byte *glyph, byte op) __naked {
;	---------------------------------
; Function directg_aligned_glyph_16x16
; ---------------------------------
_directg_aligned_glyph_16x16_start::
_directg_aligned_glyph_16x16:
;test.c:757: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	a,3(iy)
	cp	#191
	jr	nc,pag_done
	ld	c,a
	add	#16
	ld	b,a
	cp	#191
	jr	c,bottom_ok
	ld	b,#191 + 1
	bottom_ok:
	ld	a,b
	sub	c
	ld	b,a
	ld	e,4(iy)
	ld	d,5(iy)
	push	de
	ld	e,2(iy)
	call	directg_vmem_addr_raw
	pop	de
	pag_loop:
	push	bc
	ld	a,6(iy)
	and	#0x02
	jr	z,no_ex
	ex	de,hl
	no_ex:
	ldi
	ld	a,2(iy)
	cp	#247
	jr	nc,pag_no_second
	ldi
	ld	a,6(iy)
	and	#0x02
	jr	z,not_put_1
	dec	de
	dec	de
	jr	pag_line_ok
	not_put_1:
	dec	hl
	dec	hl
	jr	pag_line_ok
	pag_no_second:
	ld	a,6(iy)
	and	#0x02
	jr	z,not_put_2
	inc	hl
	dec	de
	jr	pag_line_ok
	not_put_2:
	inc	de
	dec	hl
	pag_line_ok:
	ld	a,6(iy)
	and	#0x02
	jr	z,no_ex_2
	ex	de,hl
	no_ex_2:
	call	directg_vmem_nextrow_addr_raw
	pop	bc
	djnz	pag_loop
	pag_done:
	ret
_directg_aligned_glyph_16x16_end::
;test.c:760: void directg_render_masked_glyph_16x16(byte x, byte y, byte *glyph, byte* mask) __naked {
;	---------------------------------
; Function directg_render_masked_glyph_16x16
; ---------------------------------
_directg_render_masked_glyph_16x16_start::
_directg_render_masked_glyph_16x16:
;test.c:868: __endasm;
	ld	iy,#0x0000
	add	iy,sp
	ld	a,3(iy)
	cp	#191
	jr	nc,rmg_done
	ld	c,a
	add	#16
	ld	b,a
	cp	#191
	jr	c,rmg_bott_ok
	ld	b,#191 + 1
	rmg_bott_ok:
	ld	a,b
	sub	c
	ld	b,a
	ld	e,2(iy)
	call	directg_vmem_addr_raw
	exx
	ld	l,4(iy)
	ld	h,5(iy)
	ld	e,6(iy)
	ld	d,7(iy)
	exx
	rmg_loop:
	push	bc
	exx
	ex	de,hl
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	inc	hl
	push	hl
	ex	de,hl
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	push	hl
	ld	a,2(iy)
	and	#0x07
	jr	z,rmg_dont_shift
	rmg_shift:
	or	a
	rr	e
	rr	d
	scf
	rr	c
	rr	b
	dec	a
	jr	nz,rmg_shift
	rmg_dont_shift:
	push	bc
	push	de
	exx
	pop	de
	pop	bc
	exx
	pop	hl
	pop	de
	exx
	ld	a,(hl)
	and	c
	or	e
	ld	(hl),a
	ld	a,2(iy)
	cp	#247
	jr	nc,rmg_no_second
	inc	hl
	ld	a,(hl)
	and	b
	or	d
	ld	(hl),a
	dec	hl
	rmg_no_second:
	call	directg_vmem_nextrow_addr_raw
	pop	bc
	djnz	rmg_loop
	rmg_done:
	ret
_directg_render_masked_glyph_16x16_end::
	.area _CODE
	.area _CABS
