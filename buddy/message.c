/*
 *	message.c
 *	message
 *
 *	tomaz stih sun oct 27 2013
 */
#include "errors.h"
#include "window.h"
#include "message.h"
#include "mouse.h"

extern yx_t *yx;

message_t *message_first;

/* initialize messaging system */
void message_init() {
	message_first=NULL;
}

/* remove from queue and free space */
void message_destroy(message_t *m) {
	yx->free((void *)m);
}

/* call wnd_proc directly */
result message_send(window_t *wnd, byte id, word param1, word param2) {
	return wnd->wnd_proc(wnd, id, param1, param2);
}

/* queue message */
result message_post(window_t *wnd, byte id, word param1, word param2) {
	
	/* create message */
	message_t *m=yx->allocate(sizeof(message_t));
	if (!m)
		return(last_error=OUT_OF_MEMORY);

	/* populate it */
	m->window=wnd;
	m->id=id;
	m->param1=param1;
	m->param2=param2;

	/* add it to the msg queue */
	yx->lappend((void **)&message_first, (void *)m);

	/* we did it! */
	return (last_error=SUCCESS);
}

/* dispatch new events */
void message_dispatch() {

	message_t *m;

	/* no messages? */
	if (message_first==NULL) return; 
	m = yx->lremfirst((void **)&message_first);
	if (m!=NULL) {
		message_send(m->window,m->id,m->param1,m->param2);	
		message_destroy(m);
	}
}
