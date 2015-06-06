/*
 *	graphics.c
 *	graphics context
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

graphics_t g;
rect_t a;
rect_t c;

graphics_t* graphics_create(byte flags) {

	/* TODO: allocate objects 
	graphics_t *graphics=malloc(sizeof(graphics_t));
	graphics.area=malloc(sizeof(rect_t));
	graphics.clip=malloc(sizeof(rect_t));
	*/

	graphics_t *graphics=&g;
	graphics->area=&a;
	graphics->clip=&c;

	/* TODO: initialize */
	a.x0=c.x0=a.y0=c.y0=0;
	a.x1=c.x1=SCREEN_MAXX;
	a.y1=c.y1=SCREEN_MAXY;

	return graphics;
}

void graphics_destroy(graphics_t* g) {
	/* TODO: free objects
	free(graphics.clip);
	free(graphics.area);
	free(graphics);
	*/
}

/* notes: clip_rect is in relative coordinates */
void graphics_set_clipping(graphics_t* g, rect_t *clip_rect) {
	
	/* convert relative coordinates to absolute coordinates */
	int x0 = g->area->x0 + clip_rect->x0;
	int x1 = g->area->x0 + clip_rect->x1;
	int y0 = g->area->y0 + clip_rect->y0;
	int y1 = g->area->y0 + clip_rect->y1;

	/* check overflows */
	if (x0 > g->area->x1) x0 = g->area->x1;
	if (x1 > g->area->x1) x1 = g->area->x1;
	if (y0 > g->area->y1) y0 = g->area->y1;
	if (y1 > g->area->y1) y1 = g->area->y1;

	/* and set the new abs. clip rect */
	g->clip->x0=(byte)x0;
	g->clip->x1=(byte)x1;
	g->clip->y0=(byte)y0;
	g->clip->y1=(byte)y1;
}

void graphics_draw_rect(graphics_t *g, rect_t *rect, byte* mask) {
	/* convert rect to abs. coordinates */
	/* get clip_rect intersect */
}
