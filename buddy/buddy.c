/*
 *	buddy.c
 *	main buddy loop, mostly event harvesting
 *	and message dispatching.
 *
 *	tomaz stih sun jul 2 2015
 */
#include "yx.h"
#include "buddy.h"
#include "window.h"
#include "message.h"
#include "mouse.h"
#include "stdwnd.h"


void temp_shit() {
	static window_t *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8;

	w1=window_create(
		"Window 1",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		2,
		2,
		80,
		50);
	w2=window_create(
		"Window 2",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		52,
		35,
		213,
		160);
	w3=window_create(
		"Window 3",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		0,
		80,
		60,
		132);
	w4=window_create(
		"Window 4",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		35,
		20,
		65,
		160);
	w5=window_create(
		"Window 5",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		205,
		50,
		250,
		100);
	w6=window_create(
		"Window 6",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		25,
		95,
		218,
		115);
	w7=window_create(
		"Window 7",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		40,
		140,
		70,
		190);
	w8=window_create(
		"Window 8",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		200,
		150,
		250,
		180);

}

void buddy_init() {

	/* init messaging */
	message_init();

	/* init windows system */
	window_init();

	temp_shit();

	/* draw desktop */
	window_draw(window_desktop);

	/* init mouse */
	mouse_init();

	/* show mouse cursor for the first time */
	mouse_show_cursor(mi.x, mi.y, current_cursor);
}

void buddy_harvest_events() {
	
	/* MSG_MOUSE_MOVE */
	mouse_scan(&mi);
	if (mouse_rect.x0!=mi.x || mouse_rect.y0!=mi.y) { /* coord changed */

		/* first repaint mouse */ 
		mouse_hide_cursor();
		mouse_show_cursor(mi.x, mi.y, current_cursor);

		/* remember new coords */
		calc_mouse_rect(&mi);

		/* and post message */
		buddy_dispatch(MSG_MOUSE_MOVE, mouse_rect.x0, mouse_rect.y0);
	}

	if (mi.button_change) { /* is it worth looking at? */
		/* is it the left button? */
		if (mi.button_change & MOUSE_LBUTTON) {
			/* is it down? */			
			if (mi.button & MOUSE_LBUTTON) 
				buddy_dispatch(MSG_MOUSE_LDOWN, mouse_rect.x0, mouse_rect.y0);
			else
				buddy_dispatch(MSG_MOUSE_LUP, mouse_rect.x0, mouse_rect.y0);
		}
	}
}

void buddy_dispatch(byte id, word param1, word param2) {
	
	window_t *w;

	switch (id) {
		case MSG_MOUSE_LUP:
			if (w=buddy_get_window_xy(
				window_desktop,
				(byte)param1,
				(byte)param2)) {

				if (w!=window_desktop && w!=window_desktop->first_child) {
					window_select(w);
					window_draw(w);
				}
				message_post(w,id,param1,param2);	
			}
			break;	
	}
}

window_t *buddy_get_window_xy(window_t* root, byte absx, byte absy) {

	window_t *child; 
	window_t *result=NULL;

	child=root->first_child;
	while (child) { 
		if (!(result=buddy_get_window_xy(child, absx, absy)))
			child=child->next;
		else
			return result;
	}
	/* not found */
	if (rect_contains(root->graphics->area, absx, absy))
		return root;
	else
		return NULL;
}
