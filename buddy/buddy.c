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
	glyph_t *glyph;
	byte i;

	rect.x=rect.y=20;
	rect.w=200;
	rect.h=100;

	video_cls(BLACK,WHITE,BLACK,CM_NONE);

	g=graphics_create(NULL,NONE);

	graphics_draw_circle(g, 100, 100, 40);
	graphics_draw_rect(g, &rect);

	glyph=(glyph_t *)logo();

	for(i=3;i<200;i+=7)
		glyph_draw(g, glyph, i, 0);

	graphics_destroy(g);

	return 0;
}
