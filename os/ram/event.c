/*
 *	event.c
 *	events
 *
 *	tomaz stih tue may 29 2012
 */
#include "yx.h"

event_t *evt_first=NULL;

/*
 * creates new event, adds to the list of events
 */
event_t *evt_create(void *owner) {
	event_t *e;
	if ( e = (event_t *)syslist_add((void **)&evt_first, sizeof(event_t), owner) )
		e->state=nonsignaled;
	return e;
}

/*
 * destroys existing event, removes from the list of events
 */
event_t *evt_destroy(event_t *e) {
	return (event_t *)syslist_delete((void **)&evt_first, (void *)e);
	
}

/*
 * set event state
 */
event_t *evt_set(event_t *e, event_state_t newstate) {
	list_header_t *prev;
	if ( e = (event_t *)list_find((list_header_t *)evt_first, &prev, list_match_eq, (word)e) ) 
		e->state=newstate;
	return e;
}
