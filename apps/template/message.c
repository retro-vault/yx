/*
 *	message.c
 *	message
 *
 *	tomaz stih sun oct 27 2013
 */
#include "window.h"
#include "message.h"

result message_send(window_t *wnd, byte id, word param1, word param2) {
	/* call wnd_proc directly */
	return wnd->wnd_proc(wnd, id, param1, param2);
}

result message_post(window_t *wnd, byte id, word param1, word param2) {
	wnd, id, param1, param2;
	/* queue message */
	return 0;
}
