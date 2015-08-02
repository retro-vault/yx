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
	static window_t *w1, *w2;

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
	if (mx!=mi.x || my!=mi.y) { /* coord changed */

		/* first repaint mouse */ 
		mouse_hide_cursor();
		mouse_show_cursor(mi.x, mi.y, current_cursor);

		/* remember new coords */
		mx=mi.x;
		my=mi.y;

		/* and post message */
		buddy_dispatch(MSG_MOUSE_MOVE, mx, my);
	}

	if (mi.button_change) { /* is it worth looking at? */
		/* is it the left button? */
		if (mi.button_change & MOUSE_LBUTTON) {
			/* is it down? */			
			if (mi.button & MOUSE_LBUTTON) 
				buddy_dispatch(MSG_MOUSE_LDOWN, mx, my);
			else
				buddy_dispatch(MSG_MOUSE_LUP, mx, my);
		}
	}
}

void buddy_dispatch(byte id, word param1, word param2) {
	
	window_t *w;

	switch (id) {
		case MSG_MOUSE_MOVE:
		case MSG_MOUSE_LDOWN:
		case MSG_MOUSE_LUP:
			if (w=buddy_get_window_xy(
				window_desktop,
				(byte)param1,
				(byte)param2)) {

				if (id!=MSG_MOUSE_MOVE && w!=window_active(window_desktop)) {
					window_select(w);
					window_draw(window_desktop); /* TODO: optimal redraw */
				}
				message_post(w,id,param1,param2);	
			}
			break;	
	}
}

window_t *buddy_get_window_xy(window_t* root, byte absx, byte absy) {

	window_t *child; 
	window_t *result;

	child=root->first_child;
	while (child) 
		if (!(result=buddy_get_window_xy(child,absx,absy)))
			child=child->next;
		else
			return result;

	if (rect_contains(root->graphics->area,absx,absy))
		return root;
	else
		return NULL;	
}
