/*
 *	buddy.c
 *	desktop for zx spectrum
 *
 *	tomaz stih mon oct 14 2013
 */
#include "buddy.h"

extern void glyph_draw(graphics_t *g, glyph_t *glyph, byte x, byte y);

int main(int argn,char **argv)
{
	graphics_t *g;
	rect_t rect;
	rect_t clip_rect;
	glyph_t *glyph;
	byte i;

	rect.x=0;
	rect.y=0;
	rect.w=100;
	rect.h=100;

	clip_rect.x=0;
	clip_rect.y=0;
	clip_rect.w=101;
	clip_rect.h=101;

	video_cls(BLACK,GREEN,BLACK,CM_NONE);

	g=graphics_create(NULL,NONE);

	graphics_set_clip_rect(g,&clip_rect);

	graphics_draw_circle(g, 100, 100, 50);
	graphics_draw_rect(g, &rect);

	glyph=(glyph_t *)logo();

	for(i=3;i<200;i+=7)
		glyph_draw(g, glyph, i, 0);

	graphics_destroy(g);

	return 0;
}
