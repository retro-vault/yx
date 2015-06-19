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
	rect_rel2abs(g->area, clip_rect, g->clip);
}

void graphics_fill_rect(graphics_t *g, rect_t *rect, byte* mask) {
	rect_t abs_rect, clipped_rect;
	byte row, mskndx, ofx, ofy;
	byte maskout[8];
	if (!rect_rel2abs(g->area, rect, &abs_rect)) return;
	if (!rect_intersect(&abs_rect,g->clip,&clipped_rect)) return;
	/* clip mask */
	ofx=( clipped_rect.x0 - abs_rect.x0 ) & 0x07;
	ofy=( clipped_rect.y0 - abs_rect.y0 ) & 0x07;
	clip_offset(ofx, ofy, mask, maskout);
	/* just draw the intersect */
	mskndx=0;
	for (row=clipped_rect.y0; row<=clipped_rect.y1; row++) {
		vector_horzline(row,clipped_rect.x0,clipped_rect.x1,maskout[mskndx]);
		mskndx++;
		if (mskndx==8) mskndx=0;			
	}
}
