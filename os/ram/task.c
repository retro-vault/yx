/*
 *	task.c
 *	task management
 *
 *	tomaz stih sat may 26 2012
 */
#include "yx.h"

/* current task */
task_t *tsk_current=NULL;

/* running and waiting lists */
task_t *tsk_first_running=NULL;
task_t *tsk_first_waiting=NULL;


/* ----- PRIVATE HELPERS ----- */

/*
 * check if waiting task is signalled
 */
byte has_signaled_events(task_t *t) {
	byte n;
	for (n=0;n<t->num_events;n++)
		if (((t->wait)[n])->state==signaled)
			return 1;
	return 0;
}

/*
 * find next task to switch to and set tsk_current to it
 */
void select_next() {

	byte n;
	task_t *curr, *t;

	/* 
	 * release all waiting tasks 
         */
	curr=tsk_first_waiting;
	while (curr) {
		t=curr;
		curr=curr->hdr.next;
		if (has_signaled_events(t)) {	
			/* move task from running to waiting list... */
			t->state = TASK_STATE_RUNNING;
			list_remove((list_header_t**)&tsk_first_waiting, (list_header_t *)t);
			list_insert((list_header_t**)&tsk_first_running, (list_header_t *)t);
		} 
	}

	/*
	 * select next running task
	 */
	if (tsk_first_running!=NULL) /* there are running tasks */ {
		/* simple round robin... */
		if (tsk_current==NULL || 
			tsk_current->state==TASK_STATE_WAITING || 
			tsk_current->hdr.next==NULL) 
			tsk_current=tsk_first_running;
		else 
			tsk_current=tsk_current->hdr.next;
	} else
		tsk_current=NULL;
}


/* ----- PUBLIC INTERFACE ----- */

/*
 * create task. 
 * 1) allocate slot, 
 * 2) allocate stack, 
 * 3) create empty context and put it on stack incl. entry_point as return address, 
 * 4) store sp, 
 * 5) set state to running.
 */
task_t * tsk_create(void (*entry_point)(), uint16_t stack_size) {

	task_t *t;
	void *stack;
	word *ret_addr;

	if ( t = (task_t *)syslist_add((void **)&tsk_first_running, sizeof(task_t), SYS) ) {
		/* allocate stack for the task */
		stack=mem_allocate(get_usrheap(), stack_size, (void *)t); 
		if (!stack) {
			/* was allocated - so free it */
			syslist_delete((void **)&tsk_first_running, (void *)t);
			t=NULL;
		} else {
			t->wait=NULL;
			t->state=TASK_STATE_RUNNING;
			/* prepare stack */
			t->sp=(word)stack + stack_size - CONTEXT_SIZE;
			/* top two bytes are the return address */
			ret_addr=t->sp + CONTEXT_SIZE - 2;
			(*ret_addr)=(word)entry_point;	 
		} 
	}
	return t;
}

/*
 * block current task until (any) of events is raised. 
 */
void tsk_wait4events(event_t **e, byte num_events) {

	__asm
		di			/* must disable */
	__endasm;

	/* set task flags to waiting */
	tsk_current->wait=e;
	tsk_current->num_events=num_events;
	tsk_current->state = TASK_STATE_WAITING;

	/* move task from running to waiting list... */
	list_remove((list_header_t**)&tsk_first_running, (list_header_t *)tsk_current);
	list_insert((list_header_t**)&tsk_first_waiting, (list_header_t *)tsk_current);

	/* ...and switch */
	tsk_switch_improved();
}

void tsk_switch_improved() __naked {

	__asm
		/* tsk_current == NULL? */
		push	af
		push	hl
		ld	hl,#_tsk_current
		ld	a,(hl)
		inc	hl
		or	(hl)
		jr	z,no_current_task

		/* store tsk_current, reuse push af and push hl */
store_current_task:
		push	de
		ld	d,(hl)
		dec	hl
		ld	e,(hl)			/* de=tsk_current */
		ld	hl,#-14			/* value of sp+regs space to hl */
		add	hl,sp
		ex	de,hl			/* de=sp, hl=value of tsk_current */
		inc	hl			/* move to 4th word of task_t structure */
		inc	hl
		inc	hl
		inc	hl
		ld	(hl),e			/* store sp there */
		inc	hl
		ld	(hl),d
		
		/* store task context */
		push	bc
		push	ix
		push	iy
		ex	af,af'
		exx
		push	af
		push	bc
		push	de
		push	hl

		call	_tmr_chain		/* chain timers */
		call	_select_next		/* select next task */

		/* tsk_current==NULL? */
		ld	hl,#_tsk_current	
		ld	a,(hl)
		inc	hl
		or	(hl)
		jr	z,no_next_task

restore_task:	
		/* restore context for next task */
		ld	d,(hl)			/* de=value of tsk_current */
		dec	hl
		ld	e,(hl)
		ex	de,hl			/* hl=value of tsk_current */
		inc	hl
		inc	hl
		inc	hl
		inc	hl			/* hl points to task_t sp member */
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl			/* new sp to hl */
		ld	sp,hl

		/* ...and restore regs */
		pop	hl
		pop	de
		pop	bc
		pop	af
		ex	af,af' 
		exx
		pop	iy
		pop	ix
		pop	bc
		pop	de
		pop	hl
		pop	af

		/* and switch */
		ei
		reti

no_next_task:
		ld	sp,#sysstack		/* use sys stack */
		ld	hl,#tarpit
		push	hl			/* jump to tar pit */
		ei
		reti

no_current_task:
		call	_tmr_chain		/* chain timers */
		call	_select_next		/* select next task */

		/* tsk_current==NULL? */
		ld	hl,#_tsk_current	
		ld	a,(hl)
		inc	hl
		or	(hl)
		jr	z,no_next_task		/* return to tar pit */

		/* we have current task, restore it */
		jr	restore_task

	__endasm;

}

/*
 * do the actual context switch
 * TODO: one day timer chain should be separated and triggered when called by the executive only
 */
void tsk_switch() __naked {

	/*
	 * store context, we're in di mode
	 */
	__asm
		/* store registers */
		push	af		
		push	bc
		push	de
		push	hl
		push	ix
		push	iy
		ex	af,af'
		exx
		push	af
		push	bc
		push	de
		push	hl

		/* store stack pointer */
		ld	iy,#_tsk_current	/* address of tsk_current to iy */
		ld	l,(iy)			/* value of tsk_current to hl */
		ld	h,1(iy)
		ld	a,l			/* is tsk_current==NULL? */
		or	h
		jr	z,no_tsk_current	/* no tsk_current, don't store sp */
		ex	de,hl			/* store value of tsk_current to de */
		ld	hl,#0			/* value of sp to hl */
		add	hl,sp
		ex	de,hl			/* de=sp, hl=value of tsk_current */
		inc	hl			/* move to 4th word of task_t structure */
		inc	hl
		inc	hl
		inc	hl
		ld	(hl),e			/* store sp there */
		inc	hl
		ld	(hl),d
		jr	has_tsk_current

		/* there is no current task
		   clean stack, chain timer, select next task */
no_tsk_current:
		ld	hl,#0
		add	hl,sp
		ld	d,#0
		ld	e,#20
		add	hl,de
		ld	sp,hl
		
has_tsk_current:
	__endasm;

	tmr_chain(); /* call timer hooks (mostly device drivers) */
	select_next(); /* round robin to next task */
	
	/*
	 * restore context
	 */

	__asm
		/* restore stack pointer */
		ld	iy,#_tsk_current
		ld	l,(iy)
		ld	h,1(iy)
		ld	a,h			
		or	l			/* tsk_current==NULL? */
		jr	z,end_switch
		inc	hl
		inc	hl
		inc	hl
		inc	hl
		ld	e,(hl)
		inc	hl
		ld	d,(hl)
		ex	de,hl
		ld	sp,hl

		/* restore registers */
		pop	hl
		pop	de
		pop	bc
		pop	af
		ex	af,af' 
		exx
		pop	iy
		pop	ix
		pop	hl
		pop	de
		pop	bc
		pop	af

end_switch:
		ei
		reti

	__endasm;
}
