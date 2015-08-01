/*
 *	graphics.c
 *	graphics context
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

graphics_t screen_graphics;
rect_t screen_area;
rect_t screen_clip;

/* temp */
static byte data[512];

void graphics_init() {
	/* initialize screen graphics */
	screen_graphics.area=&screen_area;
	screen_graphics.clip=&screen_clip;
	screen_area.x0=screen_clip.x0=screen_area.y0=screen_clip.y0=0;
	screen_area.x1=screen_clip.x1=SCREEN_MAXX;
	screen_area.y1=screen_clip.y1=SCREEN_MAXY;
}

graphics_t* graphics_create(byte flags) {
	flags;
	/* TODO: allocate objects 
	graphics_t *graphics=malloc(sizeof(graphics_t));
	graphics.area=malloc(sizeof(rect_t));
	graphics.clip=malloc(sizeof(rect_t));
	*/
	return NULL;
}

void graphics_destroy(graphics_t* g) {
	g;
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

void graphics_draw_rect(graphics_t *g, rect_t *rect, byte linemask) {
	rect_t abs_rect;
	byte x0,y0,x1,y1;
	
	/* convert rel to abs coordinates */
	if (!rect_rel2abs(g->area, rect, &abs_rect)) return;

	/* draw rectangle only if a portion overlaps*/
	if (rect_overlap(&abs_rect,g->clip)) {
		/* clip coordinates */
		x0=MAX(abs_rect.x0,g->clip->x0);
		x1=MIN(abs_rect.x1,g->clip->x1);
		y0=MAX(abs_rect.y0,g->clip->y0);
		y1=MIN(abs_rect.y1,g->clip->y1);
		
		/* now clip lines */
		if (abs_rect.y0 >= g->clip->y0) vector_horzline(y0, x0, x1, linemask);
		if (abs_rect.y1 <= g->clip->y1) vector_horzline(y1, x0, x1, linemask);
		if (abs_rect.x0 >= g->clip->x0) vector_vertline(x0, y0, y1, linemask);
		if (abs_rect.x1 <= g->clip->x1) vector_vertline(x1, y0, y1, linemask);
	}
}

bitmap_t* graphics_get_bitmap(graphics_t *g, rect_t *rect) {

	rect_t abs_rect, clipped_rect;		

	/* convert rel to abs coordinates */
	if (!rect_rel2abs(g->area, rect, &abs_rect)) return NULL;

	/* and clip it */
	if (!rect_intersect(&abs_rect,g->clip,&clipped_rect)) return NULL;

	/* we have the correct clip rect */
	return bmp_get(&clipped_rect, data); /* TODO: allocate data */
}

void graphics_destroy_bitmap(bitmap_t *bmp) {
	bmp;
	/* TODO: destroy data */
}

void graphics_put_bitmap(graphics_t *g, byte x, byte y, bitmap_t *bmp) {	

	rect_t rel_rect, abs_rect, clipped_rect;
	byte *bmp_start;

	/* initial rect */
	rel_rect.x0=x;
	rel_rect.y0=y;
	rel_rect.x1=x+bmp->x1;
	rel_rect.y1=y+bmp->y1;

	/* convert rel to abs coordinates */
	if (!rect_rel2abs(g->area, &rel_rect, &abs_rect)) return;

	/* and clip it */
	if (!rect_intersect(&abs_rect,g->clip,&clipped_rect)) return;

	/* calculate clipped start of bitmap */
	bmp_start=(byte *)bmp;
	bmp_start+=2; /* skip x,y */
	/* and draw it */
	bmp_put(
		bmp_start,		/* data */
		clipped_rect.x0,	/* x */
		clipped_rect.y0,	/* y */
		bmp->y1,		/* rows */
		bmp->x1,		/* cols */
		x%8,			/* shifts */
		0);			/* skip */
}
