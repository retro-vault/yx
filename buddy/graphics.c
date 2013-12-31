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
		graphics==&screen;
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

void graphics_draw_pixel(graphics_t* graphics, byte x, byte y) __naked {

	/* make sure you are in clipping region */
	
	/* now draw */
	__asm
		/* get function parameters from stack */
		ld	iy,#0x0000
		add	iy,sp		/* iy=sp */
		ld	b,4(iy)		/* b=x */
		ld	c,5(iy)		/* c=y */
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
