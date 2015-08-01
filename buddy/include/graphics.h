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
#include "bitmap.h"
#include "vector.h"
#include "clipping.h"

#define NONE		0
#define WORKSPACE	1	/* just workspace area */
#define WINDOW		2	/* entire window */

#define SCREEN_MAXX	255
#define SCREEN_MAXY	191

typedef struct graphics_s {
	rect_t *area; /* abs coord. */
	rect_t *clip; /* ...in abs. coord. and reduced to fit area */
} graphics_t;

/* constants */
extern graphics_t screen_graphics;
extern rect_t screen_area;
extern rect_t screen_clip;

/* init graphics system */
extern void graphics_init();

/* create graphics */
extern graphics_t* graphics_create(byte flags);
extern void graphics_destroy(graphics_t* g);

/* clipping */
extern void graphics_set_clipping(graphics_t* g, rect_t *clip_rect);

/* rectangle */
extern void graphics_fill_rect(graphics_t *g, rect_t *rect, byte* mask);
extern void graphics_draw_rect(graphics_t *g, rect_t *rect, byte linemask);

/* bitmaps */
extern bitmap_t* graphics_get_bitmap(graphics_t *g, rect_t *rect);
extern void graphics_destroy_bitmap(bitmap_t *bmp);
extern void graphics_put_bitmap(graphics_t *g, byte x, byte y, bitmap_t *bmp);

#endif /* _GRAPHICS_H */
