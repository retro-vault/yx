/*
 *	graphics.c
 *	graphics context
 *
 *	notes:	graphics primitives by Alois Zingl
 *		http://members.chello.at/easyfilter/bresenham.html
 *
 *	tomaz stih mon oct 14 2013
 */
#include "graphics.h"

graphics_t* graphics_create(window_t *wnd, byte flags) {

	graphics_t* g=malloc(sizeof(graphics_t));

#ifdef SDL
	/* initialize SDL */
	if(SDL_Init(SDL_INIT_VIDEO) != 0)
		fprintf(stderr,"Could not initialize SDL: %s\n",SDL_GetError());

	/* open main window */
	g->screen = SDL_SetVideoMode(
		SCREEN_WIDTH,
		SCREEN_HEIGHT,
		24,
		SDL_SWSURFACE);

	if(!g->screen)
		fprintf(stderr,"Could not set video mode: %s\n",SDL_GetError());

	/* clear screen */
	SDL_FillRect(g->screen,NULL,SDL_MapRGB(g->screen->format,255,255,255));
	SDL_Flip(g->screen);

#endif 
	return g;
}

void graphics_destroy(graphics_t* graphics) {
	free(graphics);
#ifdef SDL
	/* Exit */
	SDL_Quit();
#endif
}

void graphics_draw_pixel(graphics_t* graphics, byte x, byte y) {	
#ifdef SDL
	int bpp = graphics->screen->format->BytesPerPixel;
	/* Here p is the address to the pixel we want to set */
	Uint8 *p = 
		(Uint8 *)graphics->screen->pixels + 
		y * graphics->screen->pitch + x * bpp;

        p[0] = p[1] = p[2] = 0;
#endif
}

void graphics_draw_circle(graphics_t* graphics, byte xm, byte ym, byte r) {
	byte x = r;
	byte y = 0;
	int e = 0;

	for (;;) {
		graphics_draw_pixel(graphics, xm+x, ym+y);
		graphics_draw_pixel(graphics, xm+x, ym-y);
		graphics_draw_pixel(graphics, xm-x, ym+y);
		graphics_draw_pixel(graphics, xm-x, ym-y);
		graphics_draw_pixel(graphics, xm+y, ym+x);		
		graphics_draw_pixel(graphics, xm+y, ym-x);	
		graphics_draw_pixel(graphics, xm-y, ym+x);
		graphics_draw_pixel(graphics, xm-y, ym-x);
		if (x <= y) break;
	  	e += 2*y++ + 1;
	  	if (e > x) e += 1 - 2*x--;
	}

#ifdef SDL
	SDL_Flip(graphics->screen);
#endif
} 

void graphics_draw_rect(graphics_t* graphics, rect_t* rect) {

	byte x0=rect->x;
	byte y0=rect->y;
	byte x1=rect->x + rect->w;
	byte y1=rect->y + rect->h;

	while (x0 <= x1) {
		graphics_draw_pixel(graphics, x0, y0);
		graphics_draw_pixel(graphics, x0, y1);
		x0++;
	}

	x0=rect->x;
	while (y0 <= y1) {
		graphics_draw_pixel(graphics, x0, y0);
		graphics_draw_pixel(graphics, x1, y0);
		y0++;
	}
#ifdef SDL
	SDL_Flip(graphics->screen);
#endif
}
