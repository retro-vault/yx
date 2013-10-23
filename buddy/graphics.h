/*
 *	graphics.h
 *	graphics context
 *
 *	tomaz stih mon oct 7 2013
 */
#ifndef _GRAPHICS_H
#define _GRAPHICS_H

#include "types.h"
#include "rect.h"
#include "glyph.h"
#include "window.h"

#define WORKSPACE	1	/* just workspace area */
#define WINDOW		2	/* entire window */

typedef struct graphics_s {
	rect_t *area;
	rect_t *clip;
} graphics_t;

extern graphics_t* graphics_create(window_t *wnd, byte flags);
extern void graphics_destroy(graphics_t* graphics);

/* state functions */
extern void graphics_set_pen();
extern void graphics_set_fill_mask();
extern void graphics_set_combine_mode();

/* draw functions */
extern void graphics_draw_pixel(graphics_t* graphics, byte x, byte y);
extern void graphics_draw_line(graphics_t* graphics, byte x0, byte y0, byte x1, byte y1);
extern void graphics_draw_circle(graphics_t* graphics, byte xm, byte ym, byte r);
extern void graphics_draw_ellipse(graphics_t* graphics, rect_t* rect);
extern void graphics_draw_bezier(graphics_t* graphics, byte x0, byte y0, byte x1, byte y1, byte x2, byte y2);
extern void graphics_draw_rect(graphics_t* graphics, rect_t* rect);

/* fill functions */
extern void graphics_fill_rect(graphics_t* graphics, rect_t* rect);

/* glyph functions, also used by the font engine */
extern void graphics_draw_glyph(graphics_t *graphics, glyph_t *mask, glyph_t* glyph, byte x0, byte y0);

#endif /* _GRAPHICS_H */