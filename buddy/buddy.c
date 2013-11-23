/*
 *	buddy.c
 *	desktop for zx spectrum
 *
 *	tomaz stih mon oct 14 2013
 */
/* Includes */
#include "graphics.h"
#include "rect.h"

void harvest_events() {

#ifdef SDL
	SDL_Event ev;
	int active;
	active = 1;
	while(active)
	{
		/* Handle events */
		while(SDL_PollEvent(&ev))
		{
			if(ev.type == SDL_QUIT)
				active = 0; /* End */
		}
	}
#endif

}

int main(int argn,char **argv)
{
	graphics_t* g=graphics_create(NULL,0);

	byte midx=256/2;
	byte midy=192/2;

	for (byte i=0; i<96; i=i+4)
		graphics_draw_circle(g, midx, midy, i);

	rect_t rectangle;
	rectangle.x=10;
	rectangle.y=10;
	rectangle.w=100;
	rectangle.h=50;
	graphics_draw_rect(g, &rectangle);

	harvest_events();
	
	graphics_destroy(g);

	return 0;
}
