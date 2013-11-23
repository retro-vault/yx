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
	byte i;
	rect_t rectangle;

	graphics_t* g=graphics_create(NULL,0);

	byte midx=256/2;
	byte midy=192/2;

	for (i=0; i<96; i=i+4)
		graphics_draw_circle(g, midx, midy, i);

	rectangle.x=10;
	rectangle.y=10;
	rectangle.w=100;
	rectangle.h=50;
	graphics_draw_rect(g, &rectangle);

	harvest_events();
	
	graphics_destroy(g);

	return 0;
}
