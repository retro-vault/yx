/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu apr 16 2015
 */
#include "app.h"
#include "window.h"
#include "stdwnd.h"
#include "message.h"
#include "mouse.h"

void *current_task=NULL; /* will be real in OS environment */
word heap_size; /* normally calculated inside crt0 */

yx_t *yx;

void main() {

	window_t* w1;
	window_t* w2;
	
	mouse_info_t mi;
	byte mx,my;

	byte curndx=0;
	void* cursors[]={ &cur_std, &cur_classic, &cur_hourglass, &cur_caret, &cur_hand };

	heap_size=0xffff - (word)&heap; /* calc heap size */
	register_interfaces();
	yx=(yx_t *)query_interface("yx");
	window_init();
	mouse_calibrate(SCREEN_MAXX>>1,SCREEN_MAXY>>1);

	w1=window_create(
		"Editor",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		2,
		2,
		80,
		50);
	
	w2=window_create(
		"Clock",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		60,
		35,
		200,
		160);

	window_draw(window_desktop);

	mouse_scan(&mi);
	mx=mi.x;
	my=mi.y;
	mouse_show_cursor(mi.x, mi.y, &cur_std);
	while (TRUE) {
		mouse_scan(&mi);
		if (mx!=mi.x || my!=mi.y) { 
			mouse_hide_cursor();
			mouse_show_cursor(mi.x, mi.y, cursors[curndx]);
			mx=mi.x;
			my=mi.y;
		}
		if (mi.button_change) {
			curndx++;
			if (curndx==5) curndx=0;
		}
	}
}
