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
byte mx,my;

void mouse_init() {
	/* calibrate */
	mouse_calibrate(SCREEN_MAXX>>1,SCREEN_MAXY>>1);

	/* scan for the first time */
	mouse_scan(&mi);

	/* remember coords */
	mx=mi.x;
	my=mi.y;

	/* current cursor */
	current_cursor=&cur_std;
}
