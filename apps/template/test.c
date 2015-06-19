/*
 *	test.c
 *	tests
 *
 *	tomaz stih sun apr 19 2015
 */
#include "test.h"

void test_rects() {
	graphics_t *g;	
	rect_t filled, clip;
	byte row;
	byte mask[]={0x80,0x40,0x20,0x10,0x08,0x04,0x02,0x01};
	
	filled.x0=filled.y0=0;
	filled.x1=255; filled.y1=191;

	g=graphics_create(0);


	/* FILL rect */
	clip.x0=17; clip.y0=0; clip.x1=40; clip.y1=20;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);

	clip.x0=0; clip.y0=0; clip.x1=20; clip.y1=23;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);	
	
	clip.x0=0; clip.y0=23; clip.x1=20; clip.y1=47;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);
	
	clip.x0=0; clip.y0=47; clip.x1=20; clip.y1=80;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);
	
	clip.x0=0; clip.y0=80; clip.x1=20; clip.y1=191;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);

	clip.x0=8; clip.y0=0; clip.x1=32; clip.y1=16;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);
	
	clip.x0=0; clip.y0=8; clip.x1=8; clip.y1=32;
	graphics_set_clipping(g, &clip);
	graphics_fill_rect(g,&filled,mask);

	/* DRAW rect */
	clip.x0=20; clip.y0=20; clip.x1=40; clip.y1=40;
	graphics_set_clipping(g, &clip);
	graphics_draw_rect(g,&clip,0xaa);
	filled.x0=filled.y0=2;filled.x1=30; filled.y1=30;
	graphics_draw_rect(g,&filled,0xff);
	filled.x0=filled.y0=30;filled.x1=60; filled.y1=60;
	graphics_draw_rect(g,&filled,0xcc);
	
}

void test_bitmap() {
	__asm
		ld	hl,#50000
		ld	b,#8
		ld	c,#0
		ld	d,#128
		ld	e,#15
		call	bmp_get
		ld	hl,#50000
		ld	b,#24
		ld	c,#42
		call	bmp_put	
		ld	hl,#50000
		ld	b,#32
		ld	c,#10
		call	bmp_put	
		ld	hl,#50000
		ld	b,#48
		ld	c,#11
		call	bmp_put	
		call	bmp_put	
		ld	hl,#50000
		ld	b,#64
		ld	c,#12
		call	bmp_put	
	__endasm;
}

void test_mouse() {
	__asm
		ld	b,#95
		ld	c,#127
		push	bc
		push	bc
		call	kmp_calib
		pop	bc
		call	vector_plotxy_raw
mouse_loop:	
		pop	bc
		call	vector_plotxy_raw
		call	kmp_scan
		push	bc
		cp	#1
		jr	z,mbtn
		call	vector_plotxy_raw
		jr	mouse_loop
mbtn:
		pop	bc
	__endasm;	
}


void test_cursor() {
	__asm
		ld	b,#100
		ld 	c,#1
		ld	de,#cur_std
		call	cur_drawxy

		ld	b,#100
		ld 	c,#10
		ld	de,#cur_classic
		call	cur_drawxy

		ld	b,#100
		ld 	c,#20
		ld	de,#cur_hand
		call	cur_drawxy

		ld	b,#100
		ld 	c,#31
		ld	de,#cur_hourglass
		call	cur_drawxy

		ld	b,#100
		ld 	c,#43
		ld	de,#cur_caret
		call	cur_drawxy

		ld	b,#100
		ld 	c,#56
		ld	de,#cur_std
		call	cur_drawxy
	__endasm;
}

void test_plot() {
	__asm
		ld	b,#191
		ld 	c,#0
tploop:
		push	bc
		call 	vector_plotxy_raw
		pop	bc
		inc	c
		jr	nz,tploop
		djnz	tploop
	__endasm;
}

void test_vline1() {
	__asm
		ld	c,#0
		ld	b,#0
		ld	e,#191
		ld	d,#0x27
		call	vector_vertline_raw
		ld	c,#255
		ld	b,#0
		ld	e,#191
		ld	d,#0xaa
		call	vector_vertline_raw
	__endasm;
}

void test_vline2() {
	__asm
		ld	c,#0
		ld	b,#0
		ld	e,#191
		ld	d,#0xaa
vlloop:		
		push	bc
		push	de
		call	vector_vertline_raw
		pop	de
		pop	bc
		inc	c
		jr	nz,vlloop
	__endasm;
}

void test_hline1() {
	__asm
		ld	b,#0
		ld	c,#2
		ld	d,#2
		ld	e,#0xAA
		call	vector_horzline_raw
	__endasm;
}

void test_hline2() {
	__asm
		ld	b,#191
		ld	c,#191
		ld	e,#0x55
hlloop:
		push	bc
		push	de	
		ld	d,c
		ld	c,#0
		call	vector_horzline_raw
		pop	de
		pop	bc
		dec	c
		djnz	hlloop
	__endasm;
}

