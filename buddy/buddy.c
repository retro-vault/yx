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
	graphics_t *g=graphics_create(NULL,NONE);

	graphics_draw_circle(g, 100, 100, 50);
	graphics_draw_rect(g, g->area);

	graphics_destroy(g);
	return 0;
}
