/*
 *	timer.h
 *	timer management
 *
 *	tomaz stih tue may 29 2012
 */
#ifndef _TIMER_H
#define _TIMER_H

#define EVERYTIME 0

/*
 * timer ticks 50 times per second
 */
struct timer_s {
	/* list_header_t compatible header */
	struct timer_s *next;
	word owner;

	void (*hook)();		/* hook routine */
	word ticks;		/* trigger after ticks */
	word _tick_count;	/* count ticks (internal) */
};

typedef struct timer_s timer_t;

extern timer_t *tmr_first;
extern timer_t *tmr_install(void (*hook)(), word ticks);
extern result tmr_uninstall(timer_t *t);
extern void tmr_chain();

#endif
