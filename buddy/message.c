/*
 *	message.c
 *	message
 *
 *	tomaz stih sun oct 27 2013
 */
#include "window.h"
#include "message.h"

/* call wnd_proc directly */
result message_send(window_t *wnd, byte id, word param1, word param2) {
	return wnd->wnd_proc(wnd, id, param1, param2);
}

/* queue message */
result message_post(window_t *wnd, byte id, word param1, word param2) {
	wnd, id, param1, param2;
	return 0;
}

/* find new events */
void message_harvest() {
	/* first mouse events */
	
}
