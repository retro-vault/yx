/*
 *	graphics.c
 *	graphics context
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

graphics_t* graphics_create(window_t *wnd, byte flags) {
	return NULL;
}

void graphics_destroy(graphics_t* graphics) {
}

void graphics_set_pen() {
}

void graphics_set_fill_mask() {
}

void graphics_set_combine_mode() {
}

void graphics_draw_pixel(graphics_t* graphics, byte x, byte y) {	
}

void graphics_draw_line(graphics_t* graphics, byte x0, byte y0, byte x1, byte y1) {
	byte dx =  abs(x1-x0), sx = x0<x1 ? 1 : -1;
	byte dy = -abs(y1-y0), sy = y0<y1 ? 1 : -1; 
	byte err = dx+dy, e2; /* error value e_xy */
 
	for(;;){  /* loop */
		graphics_draw_pixel(graphics, x0, y0);
		if (x0==x1 && y0==y1) break;
		e2 = 2*err;
		if (e2 >= dy) { err += dy; x0 += sx; } /* e_xy+e_x > 0 */
		if (e2 <= dx) { err += dx; y0 += sy; } /* e_xy+e_y < 0 */
	}
}

void graphics_draw_circle(graphics_t* graphics, byte xm, byte ym, byte r) {
	byte x = -r, y = 0, err = 2-2*r; /* II. Quadrant */ 
	do {
		graphics_draw_pixel(graphics, xm-x, ym+y); /*   I. Quadrant */
		graphics_draw_pixel(graphics, xm-y, ym-x); /*  II. Quadrant */
		graphics_draw_pixel(graphics, xm+x, ym-y); /* III. Quadrant */
		graphics_draw_pixel(graphics, xm+y, ym+x); /*  IV. Quadrant */
		r = err;
		if (r <= y) err += ++y*2+1;           /* e_xy+e_y < 0 */
		if (r > x || err > y) err += ++x*2+1; /* e_xy+e_x > 0 or no 2nd y-step */
	} while (x < 0);
}

void graphics_draw_ellipse(graphics_t* graphics, rect_t* rect)
{
	byte x0=rect->x;
	byte y0=rect->y;
	byte x1=rect->x + rect->w;
	byte y1=rect->y + rect->h;

	byte a = abs(x1-x0), b = abs(y1-y0), b1 = b&1; /* values of diameter */
	int dx = 4*(1-a)*b*b, dy = 4*(b1+1)*a*a; /* error increment */
	int err = dx+dy+b1*a*a, e2; /* error of 1.step */

	if (x0 > x1) { x0 = x1; x1 += a; } /* if called with swapped points */
	if (y0 > y1) y0 = y1; /* .. exchange them */
	y0 += (b+1)/2; y1 = y0-b1;   /* starting pixel */
	a *= 8*a; b1 = 8*b*b;

	do {
		graphics_draw_pixel(graphics, x1, y0); /*   I. Quadrant */
		graphics_draw_pixel(graphics, x0, y0); /*  II. Quadrant */
		graphics_draw_pixel(graphics, x0, y1); /* III. Quadrant */
		graphics_draw_pixel(graphics, x1, y1); /*  IV. Quadrant */
		e2 = 2*err;
		if (e2 <= dy) { y0++; y1--; err += dy += a; }  /* y step */ 
		if (e2 >= dx || 2*err > dy) { x0++; x1--; err += dx += b1; } /* x step */
	} while (x0 <= x1);

	while (y0-y1 < b) {  /* too early stop of flat ellipses a=1 */
		graphics_draw_pixel(graphics, x0-1, y0); /* -> finish tip of ellipse */
		graphics_draw_pixel(graphics, x1+1, y0++); 
		graphics_draw_pixel(graphics, x0-1, y1);
		graphics_draw_pixel(graphics, x1+1, y1--); 
	} /* while */
}

void graphics_draw_bezier(graphics_t* graphics, byte x0, byte y0, byte x1, byte y1, byte x2, byte y2)
{                            
	byte sx = x2-x1, sy = y2-y1;
	int xx = x0-x1, yy = y0-y1, xy;         /* relative values for checks */
	float dx, dy, err, cur = xx*sy-yy*sx;                    /* curvature */

	if (sx*(int)sx+sy*(int)sy > xx*xx+yy*yy) { /* begin with longer part */ 
		x2 = x0; x0 = sx+x1; y2 = y0; y0 = sy+y1; cur = -cur;  /* swap P0 P2 */
	}  
	
	if (cur != 0) {                                    /* no straight line */
		xx += sx; xx *= sx = x0 < x2 ? 1 : -1;           /* x step direction */
		yy += sy; yy *= sy = y0 < y2 ? 1 : -1;           /* y step direction */
		xy = 2*xx*yy; xx *= xx; yy *= yy;          /* differences 2nd degree */
		if (cur*sx*sy < 0) {                           /* negated curvature? */
			xx = -xx; yy = -yy; xy = -xy; cur = -cur;
		}
		dx = 4.0*sy*cur*(x1-x0)+xx-xy;             /* differences 1st degree */
		dy = 4.0*sx*cur*(y0-y1)+yy-xy;
		xx += xx; yy += yy; err = dx+dy+xy;                /* error 1st step */    
		do {                              
			graphics_draw_pixel(graphics, x0, y0);	             /* plot curve */
			if (x0 == x2 && y0 == y2) return;  /* last pixel -> curve finished */
			y1 = 2*err < dx;                  /* save value for test of y step */
			if (2*err > dy) { x0 += sx; dx -= xy; err += dy += yy; } /* x step */
			if (    y1    ) { y0 += sy; dy -= xy; err += dx += xx; } /* y step */
		} while (dy < dx );             /* gradient negates -> algorithm fails */
	}
	graphics_draw_line(graphics, x0, y0, x2, y2);  /* plot remaining part to end */
}  

void graphics_draw_rect(graphics_t* graphics, rect_t* rect) {

	byte x0=rect->x;
	byte y0=rect->y;
	byte x1=rect->x + rect->w;
	byte y1=rect->y + rect->h;
	
	graphics_draw_line(graphics, x0, y0, x1, y0);
	graphics_draw_line(graphics, x0, y0, x0, y1);
	graphics_draw_line(graphics, x0, y1, x1, y1);
	graphics_draw_line(graphics, x1, y0, x1, y1);
}

void graphics_fill_rect(graphics_t* graphics, rect_t* rect) {
}

void graphics_draw_glyph(graphics_t *graphics, glyph_t *mask, glyph_t* glyph, byte x0, byte y0) {
}