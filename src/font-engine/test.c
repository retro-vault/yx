/*
 *	test.c
 *	test code (under limited conditions)
 *
 *	tomaz stih sat jun 16 2012
 */
#include "test.h"

byte *screen;
byte *shadow_screen;

rect_t screen_rect;
word delta_g;

result last_error = RESULT_SUCCESS; /* last error, 0 = success */

/* do your test here */
void main() {

	byte *mstart;
	graphics_t g;
	rect_t r;

	g_init(); /* initialize graphics */

	/* create fake graphics object */
	g.clip_rect = &screen_rect;
	g.delta_g = 0;
	g.coord_sys = NULL; /* absolute coordinates */

	mstart=screen;
	mem_set(mstart, 0b00000000, VIDEO_MEM_SIZE);
	mstart+=VIDEO_MEM_SIZE;
	mem_set(mstart, 0b00111000, ATTR_MEM_SIZE);

	POPULATE_RECT((g.clip_rect),0,0,255,191)

	POPULATE_RECT((&r),0,0,MAX_X,10)
	g_draw_text(&g,liquid_font(),"This is liquid font! ABCDE",&r);
	POPULATE_RECT((&r),0,10,MAX_X,20)
	g_draw_text(&g,c64_font(),"This is c64 font! ABCDE",&r);
	POPULATE_RECT((&r),0,20,MAX_X,30)
	g_draw_text(&g,c60s_font(),"This is c60s font! ABCDE",&r);
	POPULATE_RECT((&r),0,30,MAX_X,40)
	g_draw_text(&g,cour_new_font(),"This is courier new font! ABCDE",&r);
	POPULATE_RECT((&r),0,40,MAX_X,50)
	g_draw_text(&g,envy_font(),"This is envy font! ABCDE",&r);
	POPULATE_RECT((&r),0,50,MAX_X,60)
	g_draw_text(&g,ocra_font(),"This is ocra font! ABCDE",&r);
	POPULATE_RECT((&r),0,60,MAX_X,70)
	g_draw_text(&g,sinserif_font(),"This is sinserif font! ABCDE",&r);
	POPULATE_RECT((&r),0,70,MAX_X,80)
	g_draw_text(&g,chicago_font(),"This is chicago font! ABCDE",&r);	
}

void g_translate_coordinates(graphics_t *g, byte *x, byte *y) {
	/*
	 * if coordinate system exists then coordinates are relative
	 */
	if (g->coord_sys) { 
		(*x) += (g->coord_sys->origin_x);
		(*y) += (g->coord_sys->origin_y);
	}
}


boolean g_clip_margins(graphics_t *g, rect_t *r, margins_t *m, byte *lmask, byte *rmask) __naked {
	__asm
		
		/* iy=sp */
		ld	iy,#0x0000		
		add	iy,sp			/* iy = sp */

		/* hl=pointer to graphics_t */
		ld	l,2(iy)		
		ld	h,3(iy)

		/* de=pointer to clip rect, hl=pointer to rect, bc=pointer to margins */
		ld	e,(hl)	
		inc	hl
		ld	d,(hl)
		ld	l,4(iy)
		ld	h,5(iy)
		ld	c,6(iy)
		ld	b,7(iy)
		exx
		ld	e,8(iy)			/* lmask ptr to alt(de) */
		ld	d,9(iy)
		ld	l,10(iy)		/* rmask ptr to alt(hl) */
		ld	h,11(iy)
		exx

g_clip_margins_raw::
		push	ix
		push	hl
		push	de		
		call	rct_intersect_raw
		/* ix, iy stuff */
		pop	iy
		pop	ix
		ld	a,l
		cp	#FALSE			/* no intersection? */
		jr	z,cm_no_clipping	/* ...will call pop ix */
		
		/* rectangles intersect, now calculate clip margins */
cm_left:	xor	a
		ld	(bc),a			/* assume no margin */
		ld	a,(iy)			/* a=cr.x0 */
		sub	(ix)			/* a=cr.x0 - r.x0 */
		jr	c,cm_top
		ld	(bc),a			/* left margin */
cm_top:		inc	bc
		xor	a
		ld	(bc),a
		ld	a,1(iy)			/* a=cr.y0 */
		sub	1(ix)			/* a=cr.y0-r.y0 */
		jr	c,cm_right
		ld	(bc),a			/* top margin */
cm_right:	inc	bc
		xor	a
		ld	(bc),a
		ld	a,2(ix)			/* a=r.x1 */
		sub	2(iy)			/* a=r.x1-cr.x1 */
		jr	c,cm_bottom
		ld	(bc),a			/* right margin */
cm_bottom:	inc	bc
		xor	a
		ld	(bc),a
		ld	a,3(ix)			/* a=r.y1 */
		sub	3(iy)			/* a=r.y1-cr.y1 */
		jr	c,cm_masks
		ld	(bc),a			/* bottom margin */
cm_masks:
		/* and left and right masks */
		dec	bc			/* points to right margin */
		ld	a,(bc)			/* get it to a */		
		exx
		ld	(hl),#0			/* assume no rmask */
		ld	b,a			
		ld	a,2(ix)			/* a=r.x1 */
		sub	b			/* a=r.x1-right margin */
		and	#0x07			/* bits to shift */
		jr	z,cm_lmask
		ld	b,a
		xor	a
cm_rmask_loop:	scf
		rra
		djnz	cm_rmask_loop
		ld	(hl),a			/* store rmask */
cm_lmask:	ex	de,hl			/* hl now points to lmask */
		exx
		dec	bc
		dec	bc			/* bc points to lmargin */
		ld	a,(bc)			/* lmargin to a */
		exx
		ld	b,a			
		ld	a,(ix)			/* a=r.x0 */
		add	b			/* a=r.x0+left margin */
		and	#0x07			/* bits to shift */
		jr	z,cm_done_mask
		ld	b,a
		xor	a
cm_lmask_loop:	scf
		rra
		djnz	cm_lmask_loop
		cpl				/* complement left mask */
		ld	(hl),a
cm_done_mask:		
		exx

		/* finish */
		ld	l,#TRUE
		jr	cm_end

cm_no_clipping:
		ld	l,#FALSE
cm_end:
		pop	ix
		ret
	__endasm;
}

extern void g_draw_clipped_glyph(graphics_t *g, word glyph, byte x, byte y, byte bytes_per_glyph_line, byte glyph_lines);

void g_draw_text(graphics_t *g, font_t *font, string text, rect_t *target_rect) {

	/*
	 * coordinates 
	 */
	byte x = target_rect->x0;
	byte y = target_rect->y0;

	/*
	 * clip margins
	 */
	margins_t clip_margins;
	byte lmask;
	byte rmask;

	/* 
	 * basic font metrics
	 */
	byte bytes_per_glyph_line, glyph_lines,	xmax, descent, xmin;

	/*
	 * addresses
	 */
	word char_addr;
	word first_char_addr;

	/*
	 * per char data
	 */
	byte width;
	byte shift_bits;
	byte line;
	word dest_addr;
	byte b;
	byte *v;
	byte delta_ch;
	word char_size;

	/*
	 * buffers
	 */
	byte mask[32];
	byte pattern[32];

	/* do we need to start ? */
	if (!g_clip_margins(g, target_rect, &clip_margins, &lmask, &rmask)) return;

	fnt_get_font_info(
		font, 
		&bytes_per_glyph_line,
		&glyph_lines,
		&xmax,
		&descent,
		&xmin,
		&first_char_addr,
		&char_size);

	g_translate_coordinates(g,&x,&y);

	/* for each character */
	while (*text) {

		/*
		 * first calculate char address

		 */
		delta_ch = ( (*text) - (font->first_ascii) );
		char_addr = first_char_addr + 
			delta_ch * char_size;

		/* 
		 * do we need shifting?
		 */
		x = x + xmin;

		width = ( ((byte *)char_addr)[char_size-1] );			
		g_draw_clipped_glyph(g, char_addr,x,y,bytes_per_glyph_line,glyph_lines);		
		
		x = x + width + xmax;

		text++;
	}
}


void g_draw_clipped_glyph(graphics_t *g, word glyph, byte x, byte y, byte bytes_per_glyph_line, byte glyph_lines) {

	byte line;
	word dest_addr;
	byte b,*v, b_beg, b_end;
	byte shift_bits;
	rect_t glyph_rect;
	margins_t clip_margins;
	byte lmask, rmask;

	/*
	 * buffers
	 */
	byte mask[32];
	byte pattern[32];

	/*
	 * calculate clipping
	 */
	POPULATE_RECT((&glyph_rect),x,y,x+(bytes_per_glyph_line<<3)-1,y+glyph_lines-1)
	if (!g_clip_margins(g, &glyph_rect, &clip_margins, &lmask, &rmask)) return;

	shift_bits = x & 0x07;

	/*
	 * move mask bytes
	 */
	mem_copy(mask,glyph,bytes_per_glyph_line);
	mask[bytes_per_glyph_line]=0;
	glyph += bytes_per_glyph_line; /* skip over mask */		
	if (shift_bits)
		shift_buffer_right((word)mask, bytes_per_glyph_line + 1, shift_bits, 0x80);	
	/*
	 * handle clip top and bottom
	 */
	glyph += (bytes_per_glyph_line * clip_margins.top);
	line = clip_margins.top;
	y += clip_margins.top;
	dest_addr = directg_vmem_addr(x,y);
	glyph_lines-=clip_margins.bottom;

	/*
	 * handle clip left & right
	 */
	b_beg = (clip_margins.left>>3);
	b_end = bytes_per_glyph_line - (clip_margins.right>>3) + 1;

	while (line < glyph_lines) {
		mem_copy(pattern,glyph,bytes_per_glyph_line);
		pattern[bytes_per_glyph_line]=0;
		glyph += bytes_per_glyph_line;
		if (shift_bits)
			shift_buffer_right((word)pattern, bytes_per_glyph_line + 1, shift_bits, 0x00);
			
		v=(byte *)dest_addr;
		for (b=b_beg; b < b_end; b++)
			if (clip_margins.left && b==b_beg)
				v[b] = ~lmask; // v[b] & ~lmask | pattern[b] & lmask; 
			else if (clip_margins.right && b==b_end)
				v[b] = rmask;
			else
				v[b] = v[b] & mask[b] | pattern[b];			

		dest_addr=directg_vmem_nextrow_addr(dest_addr);
		line++;
	} 	
}

void g_init() {

	byte *mstart;

	/* 
	 * TODO: alocate shadow screen 
	 * shadow_screen=mem_allocate(0x5b00,KERNEL);
	 */
	shadow_screen=(byte *)50000;
	screen=(byte *)VIDEO_MEM_ADDR;
	delta_g = shadow_screen - screen;

	/*
	 * screen rectangle
	 */
	POPULATE_RECT((&screen_rect), 0, 0, MAX_X, MAX_Y)

	/* clear screen and ... */
	mstart=screen;
	mem_set(mstart, 0, VIDEO_MEM_SIZE);
	mstart+=VIDEO_MEM_SIZE;
	mem_set(mstart, 0b00111000, ATTR_MEM_SIZE);
	/* ... copy to shadow screen */
	mem_copy(shadow_screen, screen, VIDEO_MEM_SIZE + ATTR_MEM_SIZE);

	/*
	 * initial border
	 */
	__asm
		ld	a,#0b00000111		/* black border */
		out	(#0xfe),a		/* set border */
	__endasm;
}

void directg_realize(rect_t *r) __naked {
	__asm
		/* stack to iy */
		ld	iy,#0x0000
		add	iy,sp

		/* rect to hl */
		ld	l,2(iy)
		ld	h,3(iy)			/* hl now points to rect structure */

		/* extract rect coords to bc, de */
		ld	e,(hl)			/* e=x0 */
		inc	hl
		ld	c,(hl)			/* c=y0 */
		inc	hl
		ld	d,(hl)			/* d=x1 */
		inc	hl
		ld	b,(hl)			/* b=y1 */

		/* get delta_g to de' */
		exx
		ld	a,(#_delta_g+0)
		ld	e,a
		ld	a,(#_delta_g+1)
		ld	d,a
		exx

		/* store coordinates */
		push	bc
		push	de

		call	directg_vmem_addr_raw	/* vmem addr to hl */

		/* restore coordinates */
		pop	de
		pop	bc

		/* make d and e low resolution for byte alignment */
		srl	d
		srl	d
		srl	d
		srl	e
		srl	e
		srl	e
				
		/* initialize counters */			
		ld	a,b			/* a = b - c + 1 (delta y) */
		sub	c
		inc	a
		ld	b,a			/* delta y to b */
		ld	a,d
		sub	e			/* a = d - e + 1 (delta x) */
		inc	a

		/* get delta */
		exx
		push	de
		exx
		pop	de			/* de=de' */

		/* 
		 * hl=first address
		 * a=x counter (byte aligned)
		 * b=y counter 
		 * de=delta g
		 */
real_y_loop:	
		push	af			
		push	bc			
		push	de
		push	hl

		ld	b,#0
		ld	c,a			/* bc=x counter */
		push	hl
		add	hl,de			/* hl = shadow screen address */
		pop	de			/* de = screen address */
		ldir				/* move it all */

		pop	hl
		call	directg_vmem_nextrow_addr_raw

		pop	de
		pop	bc
		pop	af

		djnz	real_y_loop

		ret

	__endasm;
}

void mem_copy(byte *dest, byte *src, word count) __naked {
	__asm

		ld	iy,#0x0000
		add	iy,sp

		/* just ldir the whole thing! */
		ld	e,2(iy)
		ld	d,3(iy)
		ld	l,4(iy)
		ld	h,5(iy)
		ld	c,6(iy)
		ld	b,7(iy)

		ldir
		
		ret

	__endasm;
}

word string_length(string s) __naked {
	__asm
		ld	iy,#0x0000
		add	iy,sp

		ld	de,#0x0000		/* de=counter */
		ld	l,2(iy)			/* hl=pointer */
		ld	h,3(iy)
sl_loop:	cp	(hl)			/* zero? */
		jr	z,sl_end
		inc	de			/* inc counter */
		inc	hl			/* next char */
		jr	sl_loop
sl_end:
		ex	de,hl			/* result to hl */

		ret
	__endasm;
}

/*
 * sets bytes in memory block to value
 * 
 * note: only works for count values > 1 !!!
 */
void mem_set(byte *dest, byte val, word count) __naked {
	__asm
		ld	iy,#0x0000
		add	iy,sp

		ld	l,2(iy)		/* hl=dest addr */
		ld	h,3(iy)
		ld	a,4(iy)		/* a=val */
		ld	c,5(iy)		/* bc=count */
		ld	b,6(iy)
	
		/*
		 * mem_set_raw
		 * sets each byte of memory block to a value
		 * input
		 *	hl	...block address
		 *	a	...value
		 *	bc	...len
		 * effects
		 *	a, flags, bc, de, hl
		 */
mem_set_raw::	dec	bc		/* first byte is already set */
		push	hl		/* hl to de */
		pop	de
		inc	de
		ld	(hl),a		/* initial value */
		ldir	
		
		ret
	__endasm;
}

word directg_vmem_addr(byte x, byte y) __naked {

	__asm
		;; get function parameters from stack
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */
		ld	e,2(iy)		/* e=x (hires) */
		ld	c,3(iy)		/* c=y */

		/*
		 * directg_vmem_addr_raw
		 * based on hires x and hires y, calculate vmem address
		 * input
		 *	e	...hires x
		 *	c	...hires y
		* output
		 *	hl	...cell address in vmem
		 * effects
		 *	a, flags, c, de, hl
		 */	
directg_vmem_addr_raw::
		;; calculate row memory address
		ld	a,c		/* get y */
                and	#0x07 		/* leave only bits 0-2 */
                ld	h,a		/* to high */
                ld	a,c		/* y back to acc. */
		and	#0x38		/* bits 3-5 need to be */
		rla			/* shifted left */
		rla			/* twice */
		ld	l,a		/* and placed into l */
                ld	a,c		/* y back to acc. */
		and	#0xc0		/* bits 6-7 */
		rra			/* shifted... */
		rra			/* ...three... */
		rra			/* ...times */
		or	h		/* ored into high */
		or	#0x40		/* or video memory address to h */
		ld	h,a		/* hl = row addr */

		/* add x offset... */
		ld	d,#0
		srl	e		/* divide */
		srl	e		/* e */
		srl	e		/* by 8 */

		/* ...to hl */
		add	hl,de
		
		ret
		
	__endasm;

}

word directg_vmem_nextrow_addr(word addr) __naked {

	__asm
		/* get current address to hl */
		ld	iy,#0x0000	
		add	iy,sp
		ld	l,2(iy)
		ld	h,3(iy)

		/*
		 * vmem_nextrow_addr_raw
		 * based on address in vmem, calculate next row address in vmem
		 * input
		 *	hl	...address in vmem
		 * output
		 *	hl	...next row address in vmem
		 * effects
		 *	a, flags, c, hl
		 */	
directg_vmem_nextrow_addr_raw::
		/* calc. next line to hl */
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
	__endasm;
}

/*
 * shift buffer
 */
void shift_buffer_right(word start_addr, byte len, byte bits, byte lmask) __naked {
	__asm 
		ld	iy,#0x0000
		add	iy,sp			/* iy=sp */
		ld	l,2(iy)
		ld	h,3(iy)			/* hl = start addr */
		ld	c,4(iy)			/* c=len */

		ld	e,#0x00
		ld	a,6(iy)			/* a=lmask */
		or	a
		jr	z,no_mask
		ld	e,#0x80
		ld	b,5(iy)
mask_loop:	sra	e
		djnz	mask_loop
		sla	e			/* "shift" too far */
no_mask:
		
		ld	d,#0			/* initial value is lmask */
len_loop:	ld	a,d
		ld	d,#0			/* current shift overflow */

		ld	b,5(iy)			/* b=bits */
shift_loop:	rr	(hl)			/* rotate hl through carry */
		rr	d			/* into d */
		djnz	shift_loop
		or	(hl)			/* or shifted value with a */
		ld	(hl),a			/* and replace */
		inc	hl			/* next hl address */
		
		dec	c			/* len=len-1 */
		jr	nz,len_loop		/* and loop */
		
		ld	l,2(iy)
		ld	h,3(iy)
		ld	a,e
		or	(hl)
		ld	(hl),a

		ret
	__endasm;
}

void directg_aligned_glyph_16x16(byte x, byte y, byte *glyph, byte op) __naked {

	__asm

		ld	iy,#0x0000
		add	iy,sp
		
		ld	a,3(iy)			/* a=y */
		cp	#MAX_Y			/* compare to max coordinate */
		jr	nc,pag_done		/* y > MAX_Y */
		ld	c,a			/* store y to c */
		add	#16			/* add 16 pixels */
		ld	b,a			/* store bottom*/
		cp	#MAX_Y			/* exceeds max y? */
		jr	c,bottom_ok
		ld	b,#MAX_Y + 1
bottom_ok:	/* calculate delta b = max_y - y + 1 */
		ld	a,b		
		sub	c
		ld	b,a			/* delta is counter */

		/* get glyph buffer into de */
		ld	e,4(iy)
		ld	d,5(iy)

		push	de			/* temp store de */
		ld	e,2(iy)			/* e=x */
		call	directg_vmem_addr_raw	/* get initial vmem into hl */
		pop	de			/* restore de as glyph buffer pointer */
		
		/* hl=vmem address, de=buffer, b=row count */	
pag_loop:	push	bc			/* b is counter */
		ld	a,6(iy)			/* op (mode) */
		and	#GLYPH_PUT
		jr	z,no_ex
		ex	de,hl			/* de=vmem hl=buffer */	
no_ex:
		ldi
		ld	a,2(iy)			/* a=x */
		cp	#247			/* edge of screen? */
		jr	nc,pag_no_second
		ldi

		/* update de, hl */
		ld	a,6(iy)
		and	#GLYPH_PUT
		jr	z,not_put_1
		dec	de			/* restore to initial value */
		dec	de
		jr	pag_line_ok
not_put_1:	dec	hl
		dec	hl
		jr	pag_line_ok

pag_no_second:
		ld	a,6(iy)
		and	#GLYPH_PUT
		jr	z,not_put_2
		inc	hl
		dec	de
		jr	pag_line_ok
not_put_2:	inc	de
		dec	hl

pag_line_ok:	/* new line into hl */
		ld	a,6(iy)			/* operation */
		and	#GLYPH_PUT
		jr	z,no_ex_2
		ex	de,hl			/* de=buffer hl=vmem */
no_ex_2:
		call	directg_vmem_nextrow_addr_raw
		pop	bc
		djnz	pag_loop
pag_done:
		ret

	__endasm;
}

void directg_render_masked_glyph_16x16(byte x, byte y, byte *glyph, byte* mask) __naked {

	__asm
		ld	iy,#0x0000
		add	iy,sp
		
		ld	a,3(iy)			/* a=y */
		cp	#MAX_Y			/* compare to max coordinate */
		jr	nc,rmg_done		/* y > MAX_Y */
		ld	c,a			/* store y to c */
		add	#16			/* add 16 pixels */
		ld	b,a			/* store bottom*/
		cp	#MAX_Y			/* exceeds max y? */
		jr	c,rmg_bott_ok
		ld	b,#MAX_Y + 1
rmg_bott_ok:	/* calculate delta b = max_y - y + 1 */
		ld	a,b		
		sub	c
		ld	b,a			/* b is y delta*/
		ld	e,2(iy)			/* e=x */
		call	directg_vmem_addr_raw	/* get initial vmem into hl */

		/* populate alternate regs */		
		exx	
		ld	l,4(iy)			/* hl=glyph address */
		ld	h,5(iy)
		ld	e,6(iy)			/* de=mask address */
		ld	d,7(iy)
		exx		

		/* hl=vmem address, b=row count */	
rmg_loop:	push	bc			/* b is counter */
		
		/* alternate set for this */
		exx

		/* bc = mask */
		ex	de,hl
		ld	c,(hl)
		inc	hl
		ld	b,(hl)
		inc	hl
		push	hl			/* store de ... current mask address */

		/* de = glyph */
		ex	de,hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		inc	hl
		push	hl			/* store hl ... current glyph address */

		/* how many bits to shift? */
		ld	a,2(iy)			/* a <- x */
		and	#0x07			/* shift bits */
		jr	z,rmg_dont_shift		
	
rmg_shift:	or	a			/* clear carry */
		rr	e			
		rr	d
		scf				/* set carry for mask */
		rr	c
		rr	b
		dec	a
		jr	nz,rmg_shift

rmg_dont_shift:	
		/*
		 * bc has shifted mask
		 * de has shifted glyph
		 * transfer both to alt. register set
		 */
		push	bc
		push	de
		exx
		pop	de
		pop	bc
		exx
		pop	hl
		pop	de		

		/* and back to reg set */
		exx

		ld	a,(hl)			/* get vmem contents */
		and	c
		or	e
		ld	(hl),a

		ld	a,2(iy)			/* a=x */
		cp	#247			/* edge of screen? */
		jr	nc,rmg_no_second

		inc	hl
		ld	a,(hl)
		and	b
		or	d
		ld	(hl),a
		dec	hl

rmg_no_second:	
		/* new line into hl */
		call	directg_vmem_nextrow_addr_raw
		pop	bc
		djnz	rmg_loop
rmg_done:
		ret

	__endasm;

}
