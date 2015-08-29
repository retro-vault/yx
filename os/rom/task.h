/*
 *	task.h
 *	task management
 *
 *	tomaz stih sat may 26 2012
 */
#ifndef _TASK_H
#define _TASK_H

#include "types.h"
#include "list.h"
#include "event.h"

#define TASK_STATE_RUNNING		0
#define TASK_STATE_WAITING		1

#define CONTEXT_SIZE			22

typedef struct task_s {
	/* list_header_t compatible header */
	list_header_t hdr;
	/* task properties */
	word sp; 		/* stack pointer. task context is stored on stack. */
	event_t **wait;		/* event list or null */
	byte num_events;	/* number of events in event list */
	byte state;		/* task state (bits 0-1), bits 2-7 are reserved */
} task_t;

extern task_t *tsk_current;
extern task_t *tsk_first_running;
extern task_t *tsk_first_waiting;

extern task_t * tsk_create(void (*entry_point)(), word stack_size);
extern void tsk_wait4events(event_t **events, byte num_events);
extern void tsk_switch() __naked;

#endif
