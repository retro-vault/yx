/*
 *	buddy.c
 *	desktop for zx spectrum
 *
 *	tomaz stih mon oct 14 2013
 */
#include "buddy.h"

void harvest_events() {

}

int main(int argn,char **argv)
{
	graphics_t *g;
	rect_t rect;
	rect.x=rect.y=0;
	rect.w=200;
	rect.h=100;

	video_cls(BLACK,WHITE,BLACK,CM_NONE);

	g=graphics_create(NULL,NONE);

	graphics_draw_circle(g, 100, 100, 40);
	graphics_draw_rect(g, &rect);

	graphics_destroy(g);

	return 0;
}
