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

void *current_task=NULL; /* will be real in OS environment */
word heap_size; /* normally calculated inside crt0 */

yx_t *yx;

void main() {

	window_t* w1;
	window_t* w2;
	window_t* w11;
	window_t* w21;
	window_t* wactive;

	heap_size=0xffff - (word)&heap; /* calc heap size */
	register_interfaces();
	yx=(yx_t *)query_interface("yx");
	window_init();

	w1=window_create(
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		2,
		2,
		80,
		40);
	
	w11=window_create(
		w1,
		WF_HASBORDER,
		app_wnd_proc,
		0,
		0,
		10,
		10);

	w2=window_create(
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		20,
		20,
		120,
		80);

	w21=window_create(
		w2,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		0,
		0,
		5,
		100);
	
	wactive=w2;
	while (TRUE) {
		window_draw(window_desktop);
		if (wactive==w2) wactive=w1; else wactive=w2;
		yx->sleep(1000);
		window_select(wactive);
		window_move(w1,w1->rect->x0+4, w1->rect->y0);
		window_move(w2,w2->rect->x0, w2->rect->y0+2);
	}
}
