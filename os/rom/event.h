/*
 *	event.h
 *	events
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _EVENT_H
#define _EVENT_H

#include "types.h"
#include "list.h"

typedef enum event_state_e {
	nonsignaled,
	signaled
} event_state_t;

typedef struct event_s {
	/* list_header_t compatible header */
	list_header_t hdr;
	/* event state */
	event_state_t state;
} event_t;

extern event_t *evt_first;
extern event_t *evt_create(void *owner);
extern event_t *evt_destroy(event_t *e);
extern event_t *evt_set(event_t *e, event_state_t newstate);

#endif
