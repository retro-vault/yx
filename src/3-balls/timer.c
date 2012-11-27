/*
 *	timer.c
 *	timer management
 *
 *	tomaz stih tue may 29 2012
 */
#include "yeah.h"

timer_t *tmr_first=NULL;

/* 
 * install timer hook 
 */
timer_t *tmr_install(void (*hook)(), word ticks) {
	timer_t *t;
	di();
	t=(timer_t *)lst_insert((list_header_t **)&tmr_first, sizeof(timer_t), KERNEL);
	t->hook=hook;
	t->_tick_count=t->ticks=ticks;
	last_error=RESULT_SUCCESS;
	ei();
	return t;
}

/*
 * remove timer hook
 */
result tmr_uninstall(timer_t *t) {
	result r;
	di();
	r=lst_delete((list_header_t **)&tmr_first, (list_header_t *)t, 1);
	ei();
	return r;
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
		t=t->next;
	}
	last_error=RESULT_SUCCESS;
}
