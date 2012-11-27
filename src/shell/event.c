/*
 *	event.c
 *	events
 *
 *	tomaz stih tue may 29 2012
 */
#include "yeah.h"

event_t *evt_first=NULL;

/*
 * creates new event, adds to the list of events
 */
event_t *evt_create(word owner) {
	event_t *e;
	di();
	e=(event_t *)lst_insert((list_header_t **)&evt_first, sizeof(event_t),owner);
	e->state=nonsignaled;
	ei();
	return e;
}

/*
 * destroys existing event, removes from the list of events
 */
result evt_destroy(event_t *e) {
	result r;
	di();
	r=lst_delete((list_header_t **)&evt_first, (list_header_t *)e, 1);
	ei();
	return r;
}

/*
 * set event state
 */
result evt_set(event_t *e, event_state_t newstate) {

	void * last;
	result r;

	di();
	r=lst_find((list_header_t *)evt_first, (list_header_t **)last, (list_header_t *)e);
	if (r==RESULT_SUCCESS)
		e->state=newstate;
	ei();
	return r;
}
