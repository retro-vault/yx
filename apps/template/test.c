/*
 *	test.c
 *	tests
 *
 *	tomaz stih sun apr 19 2015
 */

void test_bitmap() {
	__asm
		ld	hl,#50000
		ld	bc,#0x0000
		ld	d,#128
		ld	e,#24
		call	bmp_get
		ld	hl,#50000
		ld	b,#24
		ld	c,#9
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
		call	vid_plotxy
mouse_loop:	
		pop	bc
		call	vid_plotxy
		call	kmp_scan
		push	bc
		cp	#1
		jr	z,mbtn
		call	vid_plotxy
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
		call vid_plotxy
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
		call	vid_vertline
		ld	c,#255
		ld	b,#0
		ld	e,#191
		ld	d,#0xaa
		call	vid_vertline
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
		call	vid_vertline
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
		call	vid_horzline
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
		call	vid_horzline
		pop	de
		pop	bc
		dec	c
		djnz	hlloop
	__endasm;
}

