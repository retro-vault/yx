/*
 *	event.h
 *	events
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _EVENT_H
#define _EVENT_H

typedef enum event_state_e {
	nonsignaled,
	signaled
} event_state_t;

typedef struct event_s {
	/* list_header_t compatible header */
	struct event_s *next;
	word owner;

	event_state_t state;
} event_t;

extern event_t *evt_first;
extern event_t *evt_create(word owner);
extern result evt_destroy(event_t *e);
extern result evt_set(event_t *e, event_state_t newstate);

#endif
