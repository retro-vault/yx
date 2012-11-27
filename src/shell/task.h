/*
 *	task.h
 *	task management
 *
 *	tomaz stih sat may 26 2012
 */
#ifndef _TASK_H
#define _TASK_H
 
#define TASK_STATE_RUNNING		0
#define TASK_STATE_WAITING		1

#define CONTEXT_SIZE			22

struct task_s {

	/* header compatible with list */
	struct task_s *next;
	word owner;	

	word sp; 		/* stack pointer. task context is stored on stack. */
	event_t **wait;		/* event list or null */
	byte num_events;	/* number of events in event list */
	byte state;		/* task state (bits 0-1), bits 2-7 are reserved */
	word heap_size;		/* heap size */	
};

typedef struct task_s task_t;

extern task_t *tsk_current;
extern task_t *tsk_first_running;
extern task_t *tsk_first_waiting;

extern task_t * tsk_create(void (*entry_point)(), word heap_size, word stack_size);
extern result tsk_wait4events(struct event_s **events, byte num_events);
extern void tsk_roundrobin();
extern void tsk_switch() __naked;

/* to be implemented */
extern void tsk_exit(byte exitcode);
extern void tsk_destroy(task_t *t); 

#endif
