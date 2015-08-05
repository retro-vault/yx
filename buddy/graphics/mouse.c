/*
 *	mouse.c
 *	rectangle type implementation
 *
 *	tomaz stih mon oct 7 2013
 */
#include "types.h"
#include "graphics.h"
#include "mouse.h"

void* current_cursor;
mouse_info_t mi;
rect_t mouse_rect;

void calc_mouse_rect(mouse_info_t *mi) {
	mouse_rect.x0=mi->x;
	mouse_rect.y0=mi->y;
	if (SCREEN_MAXX-mi->x<MOUSE_CURSOR_WIDTH) mouse_rect.x1=SCREEN_MAXX; else mouse_rect.x1=mi->x+MOUSE_CURSOR_WIDTH;
	if (SCREEN_MAXY-mi->y<MOUSE_CURSOR_HEIGHT) mouse_rect.y1=SCREEN_MAXY; else mouse_rect.y1=mi->y+MOUSE_CURSOR_HEIGHT;
}

void mouse_init() {
	/* calibrate */
	mouse_calibrate(SCREEN_MAXX>>1,SCREEN_MAXY>>1);

	/* scan for the first time */
	mouse_scan(&mi);

	/* remember coords */
	calc_mouse_rect(&mi);
	

	/* current cursor */
	current_cursor=&cur_std;
}
