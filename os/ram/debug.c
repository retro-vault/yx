/*
 *	debug.c
 *	diagnostics
 *
 *	tomaz stih wed apr 3 2013
 */
#include "yx.h"

void dbg_wtox(word w, string destination) {
	byte *p;
	int i;

	byte hex[16]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};

	p=(byte *)&w;

	for(i = 0; i < 2; i++)	{
		destination[i*2] = hex[((p[1-i] >> 4) & 0x0F)];
		destination[(i*2) + 1] = hex[(p[1-i]) & 0x0F];
	}
	destination[i*2]=0;
}

void dbg_memdump(void *heap) {

	byte buff[6];
	block_t *b;

	buff[0]=0;

	lores_puts("MEMORY DUMP:\n");
	lores_puts("block owner stat data size next\n");
	lores_puts("===== ===== ==== ==== ==== ====\n");

	b=heap;
	while (b) {
	
		dbg_wtox((word)b,buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->hdr.owner),buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox(b->stat,buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->data),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->size),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(b->hdr.next),buff);
		lores_puts(buff); lores_puts("\n");
		b=b->hdr.next;
	}
	 
}

void dbg_evtdump() {
	byte buff[6];
	event_t *e;

	buff[0]=0;

	lores_puts("EVENT DUMP:\n");
	lores_puts("event owner stat next\n");
	lores_puts("===== ===== ==== ====\n");

	e=evt_first;
	while (e) {
		dbg_wtox((word)e,buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(e->hdr.owner),buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		if (e->state==signaled)
			lores_puts("SIGN ");
		else
			lores_puts("NOSI ");
		dbg_wtox((word)(e->hdr.next),buff);
		lores_puts(buff); lores_puts("\n");
		e=e->hdr.next;
	}
}

void dbg_tmrdump() {
	byte buff[6];
	timer_t *t;

	buff[0]=0;

	lores_puts("TIMER DUMP:\n");
	lores_puts("timer owner tcks tcnt hook\n");
	lores_puts("===== ===== ==== ==== ====\n");

	t=tmr_first;
	while (t) {
		dbg_wtox((word)t,buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(t->hdr.owner),buff);
		lores_puts(" "); lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(t->ticks),buff);
		lores_puts(buff); lores_puts(" "); 
		dbg_wtox((word)(t->_tick_count),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(t->hook),buff);
		lores_puts(buff);
		lores_puts("\n");
		
		t=t->hdr.next;
	}
}

void dbg_namedump() {
	byte buff[6];
	name_t *n;

	buff[0]=0;

	lores_puts("NAME DUMP:\n");
	lores_puts("ptr  own  ref  next name\n");
	lores_puts("==== ==== ==== ==== ========\n");

	n=name_first;
	while (n) {
		dbg_wtox((word)n,buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(n->hdr.owner),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(n->resource),buff);
		lores_puts(buff); lores_puts(" "); 
		dbg_wtox((word)(n->hdr.next),buff);
		lores_puts(buff); lores_puts(" ");
		lores_puts(n->name);
		lores_puts("\n");
		
		n=n->hdr.next;
	}
}

void dbg_handledump() {
	byte buff[6];
	handle_t *h;

	buff[0]=0;

	lores_puts("HANDLE DUMP:\n");
	lores_puts("hndl own  term next\n");
	lores_puts("==== ==== ==== ====\n");

	h=handle_first;
	while (h) {
		dbg_wtox((word)h,buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(h->hdr.owner),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(h->terminate),buff);
		lores_puts(buff); lores_puts(" "); 
		dbg_wtox((word)(h->hdr.next),buff);
		lores_puts(buff); lores_puts(" ");
		lores_puts("\n");
		
		h=h->hdr.next;
	}
}

void dbg_taskdump() {
	byte buff[6];
	task_t *t;

	buff[0]=0;

	lores_puts("TASK DUMP:\n");
	lores_puts("task ownr sp   next\n");
	lores_puts("==== ==== ==== ====\n");

	t=tsk_first_running;
	while (t) {
		dbg_wtox((word)t,buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(t->hdr.owner),buff);
		lores_puts(buff); lores_puts(" ");
		dbg_wtox((word)(t->sp),buff);
		lores_puts(buff); lores_puts(" "); 
		dbg_wtox((word)(t->hdr.next),buff);
		lores_puts(buff); lores_puts(" ");
		lores_puts("\n");
		
		t=t->hdr.next;
	}
}
