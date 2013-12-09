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

#define NONE		0
#define WORKSPACE	1	/* just workspace area */
#define WINDOW		2	/* entire window */

#define SCREEN_WIDTH	256
#define SCREEN_HEIGHT	192

typedef struct graphics_s {
	rect_t *area;
	rect_t *clip;
} graphics_t;

/* create graphics */
extern graphics_t* graphics_create(window_t *wnd, byte flags);
extern void graphics_destroy(graphics_t* graphics);

/* draw functions */
extern void graphics_draw_pixel(graphics_t* graphics,byte x, byte y);
extern void graphics_draw_circle(graphics_t* graphics, byte xm, byte ym, byte r);
extern void graphics_draw_rect(graphics_t* graphics, rect_t* rect);

#endif /* _GRAPHICS_H */
