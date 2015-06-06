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

#define NONE		0
#define WORKSPACE	1	/* just workspace area */
#define WINDOW		2	/* entire window */

#define SCREEN_MAXX	255
#define SCREEN_MAXY	191

typedef struct graphics_s {
	rect_t *area; /* abs coord. */
	rect_t *clip; /* ...in abs. coord. and reduced to fit area */
} graphics_t;

/* create graphics */
extern graphics_t* graphics_create(byte flags);
extern void graphics_destroy(graphics_t* g);
extern void graphics_set_clipping(graphics_t* g, rect_t *clip_rect);

#endif /* _GRAPHICS_H */
