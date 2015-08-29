/*
 *	timer.c
 *	timer management
 *
 *	tomaz stih tue may 29 2012
 */
#include "types.h"
#include "syslist.h"
#include "timer.h"

timer_t *tmr_first=NULL;

/* 
 * install timer hook 
 */
timer_t *tmr_install(void (*hook)(), word ticks, void *owner) {
	timer_t *t;

	if ( t = (timer_t *)syslist_add((void **)&tmr_first, sizeof(timer_t), owner) ) {
		t->hook=hook;
		t->_tick_count=t->ticks=ticks;	
	}

	return t;
}

/*
 * remove timer hook
 */
timer_t *tmr_uninstall(timer_t *t) {
	return (timer_t *)syslist_delete((void **)&tmr_first, (void *)t);
}

/*
 * chain timers
 * note:	this is done inside 50 hz interrupt 
 *		so no di/ei calls are needed.
 */
void tmr_chain() {
	timer_t *t=tmr_first;
	while(t) {
		if (t->_tick_count==0) { /* trig it */
			t->_tick_count=t->ticks;			
			t->hook();
		} else t->_tick_count--;
		t=t->hdr.next;
	}
}
