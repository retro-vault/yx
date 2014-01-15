/*
 *	graphics.c
 *	graphics context
 *
 *	notes:	graphics primitives by Alois Zingl
 *		http://members.chello.at/easyfilter/bresenham.html
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

/* TODO: multiple screen graphics contexts */
graphics_t screen;
rect_t screen_area;
rect_t screen_clip;

graphics_t* graphics_create(window_t *wnd, byte flags) {

	graphics_t *graphics;

	if (wnd==NULL)  { /* TODO: else */
		graphics=&screen;
		screen.area=&screen_area;
		screen.clip=&screen_clip;
		screen_area.x=screen_area.y=screen_clip.x=screen_clip.y=0;
		screen_area.w=screen_clip.w=SCREEN_WIDTH;
		screen_area.h=screen_clip.h=SCREEN_HEIGHT;
	}

	return graphics;

}

void graphics_destroy(graphics_t* graphics) {
	/* TODO: mem_free graphics context */
}

void graphics_set_clip_rect(graphics_t* graphics, rect_t *rect) __naked {
	__asm
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */

		ld	l,2 (iy)	/* graphics to hl */
		ld	h,3 (iy)
		ld	a,(hl)
		inc	hl
		ld	d,(hl)
		ld	e,a		/* de=area pointer */
		inc	hl
		ld	a,(hl)
		inc	hl
		ld	h,(hl)
		ld	l,a		/* hl=clip pointer */

		push	hl
		ld	l,4(iy)
		ld	h,5(iy)		/* hl=rect */
		pop	iy		/* iy = clip pointer */		

		ex	de,hl		

		/* at this point:
		 * iy = clip pointer
		 * hl = area pointer
		 * de = rect pointer 
		 */
		ld	a,(de)		/* a=rect x */
		add	(hl)		/* a=rect x + area x */
		ld	(iy),a		/* clip x = rect x + area x */
		inc	de
		inc	hl
		ld	a,(de)		/* a=rect y */
		add	(hl)		/* a=rect y + area y */
		ld	1(iy),a		/* clip y = rect y + area y */
		inc	de
		ld	a,(de)		/* a=rect w */	
		ld	2(iy),a		/* clip w = rect w */
		inc	de
		ld	a,(de)		/* a=rect h */
		ld	3(iy),a		/* clip h = rect h */

		ret
	__endasm;
}

void graphics_draw_pixel(graphics_t* graphics, byte x, byte y) __naked {
	__asm
		/* get function parameters from stack */
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */
		
		/* 
		 * convert x and y 
		 * to absolute coordinates 
		 */	
		ld	l,2 (iy)	/* graphics to hl */
		ld	h,3 (iy)
		push	hl		/* store for later */
		ld	a,(hl)		/* pointer to area to hl */
		inc	hl
		ld	h,(hl)
		ld	l,a

		/* increase x... */
		ld	a,(hl)
		add	4 (iy)
		ld	4 (iy),a
		
		/* ...and y */
		inc	hl
		ld	a,(hl)
		add	5 (iy)
		ld	5 (iy), a
		
		/* handle clipping */
		pop	hl		/* get hl back */
		inc	hl
		inc	hl		/* hl points to clip pointer */		
		ld	a,(hl)		
		inc	hl
		ld	h,(hl)
		ld	l,a		/* hl points to clip structure */
		ld	b,4(iy)		/* b=x */
		ld	c,5(iy)		/* c=y */
		ld	a,(hl)		/* a=clip x */
		cp	b		/* compare to x */
		ret	nc		/* must be larger */
		inc	hl		
		ld	e,a		/* store a */
		ld	a,(hl)		/* a=clip y */
		ld	d,a		/* store clip y */
		cp	c		/* compare to y */
		ret	nc		/* must be larger */
		ld	a,e		/* a = x */
		inc	hl
		add	(hl)		/* a = x + w - 1 = x2 */
		dec	a		
		cp	b		/* compare to x */
		ret	c		/* must be smaller */
		ld	a,d		/* a=y */
		inc	hl
		add	(hl)		/* a = y + h - 1 = y2 */
		dec	a
		cp	c		/* compare to y */
		ret	c		/* must be smaller */

		/* draw point */
		call	video_addr_raw
		ld	a,b		/* pixel number to a */
		and	#0b00000111
		ld	b,#0b10000000	/* store pixel to b */
shift_pixel:			
		or	a
		jr	z, b_to_screen
		srl	b
		dec	a
		jr	shift_pixel

b_to_screen:
		ld	a,b
		or	(hl)		/* or screen contents */
		ld	(hl),a		/* and push to screen */
		ret
	__endasm;
}

void graphics_draw_circle(graphics_t* graphics, byte xm, byte ym, byte r) {

	byte x = r;
	byte y = 0;
	int e = 0;

	for (;;) {
		graphics_draw_pixel(graphics, xm+x, ym+y);
		graphics_draw_pixel(graphics, xm+x, ym-y);
		graphics_draw_pixel(graphics, xm-x, ym+y);
		graphics_draw_pixel(graphics, xm-x, ym-y);
		graphics_draw_pixel(graphics, xm+y, ym+x);		
		graphics_draw_pixel(graphics, xm+y, ym-x);	
		graphics_draw_pixel(graphics, xm-y, ym+x);
		graphics_draw_pixel(graphics, xm-y, ym-x);
		if (x <= y) break;
	  	e += 2*y++ + 1;
	  	if (e > x) e += 1 - 2*x--;
	}
} 

void graphics_draw_rect(graphics_t* graphics, rect_t* rect) {

	byte x0=rect->x;
	byte y0=rect->y;
	byte x1=rect->x + rect->w;
	byte y1=rect->y + rect->h;

	while (x0 <= x1) {
		graphics_draw_pixel(graphics, x0, y0);
		graphics_draw_pixel(graphics, x0, y1);
		x0++;
	}

	x0=rect->x;
	while (y0 <= y1) {
		graphics_draw_pixel(graphics, x0, y0);
		graphics_draw_pixel(graphics, x1, y0);
		y0++;
	}
}
