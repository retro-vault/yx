/*
 *	task.c
 *	task management
 *
 *	tomaz stih sat may 26 2012
 */
#include "yeah.h"

/* current tasks */
task_t *tsk_current=NULL;

/* running and waiting lists */
task_t *tsk_first_running=NULL;
task_t *tsk_first_waiting=NULL;

/*
 * create task. 
 * 1) allocate slot, 
 * 2) allocate heap and stack, 
 * 3) create empty context and put it on stack incl. entry_point as return address, 
 * 4) store sp, 
 * 5) set state to running.
 */
task_t * tsk_create(void (*entry_point)(), uint16_t heap_size, uint16_t stack_size) {

	task_t *t;
	void *stack;
	word *ret_addr;

	t=(task_t *)lst_insert((list_header_t **)&tsk_first_running, sizeof(task_t), KERNEL);
	if (!t) {
		last_error=RESULT_NO_MEMORY_LEFT;
		t=NULL;
	} else { /* initialize task structure. */
		stack=mem_allocate(stack_size,(word)t); 
		if (!stack) {
			lst_delete((list_header_t **)&tsk_first_running, (list_header_t *)t, 1); /* was allocated so free it. */
			last_error=RESULT_NO_MEMORY_LEFT;
			t=NULL;
		} else {
			t->wait=NULL;
			t->state=TASK_STATE_RUNNING;
			t->heap_size=heap_size;
			
			/* prepare stack */
			t->sp=(word)stack + stack_size - CONTEXT_SIZE;

			/* top two bytes are the return address */
			ret_addr=t->sp + CONTEXT_SIZE - 2;
			(*ret_addr)=(word)entry_point;	
		
			last_error=RESULT_SUCCESS; 
		} 
	} 
	return t;
}

/*
 * block current task until (any) of events is raised. 
 */
result tsk_wait4events(event_t **e, byte num_events) {

	/* disable interrupts */
	di();

	/* set task flags to waiting */
	tsk_current->wait=e;
	tsk_current->num_events=num_events;
	tsk_current->state = TASK_STATE_WAITING;

	/* move task from running to waiting list */
	lst_delete((list_header_t **)&tsk_first_running, (list_header_t *)tsk_current, 0);
	tsk_current->next=tsk_first_waiting;
	tsk_first_waiting=tsk_current;

	/* ...and switch */
	tsk_switch();

	/* enable interrupts */
	ei();

	return last_error=RESULT_SUCCESS;
}



/*
 * find next task to switch to. 
 */
void tsk_roundrobin() {

	byte n;
	task_t *curr;
	task_t *found;

	/* first chekck all waiting tasks */
	curr=tsk_first_waiting;
	while (curr) {
		found=NULL;
		for (n=0;n < curr->num_events && !found;n++)
			if (((curr->wait)[n])->state==signaled)
				found=curr;
		curr=curr->next;

		if (found) { /* move to running list */
			lst_delete((list_header_t **)&tsk_first_waiting, (list_header_t *)found, 0);
			found->next=tsk_first_running;
			found->state = TASK_STATE_RUNNING;
			tsk_first_running=found;
		}
	}

	/* now select one of running tasks */
	if (tsk_first_running==NULL) return; /* no running tasks yet */

	/* do round robin... */
	if (tsk_current==NULL || 
		tsk_current->state==TASK_STATE_WAITING || 
		tsk_current->next==NULL) 
		tsk_current=tsk_first_running;
	else 
		tsk_current=tsk_current->next;
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
		;; store registers
		push	af		
		push	bc
		push	de
		push	hl
		push	ix
		push	iy
		;; store alternative registers
		ex	af,af'
		exx
		push	af
		push	bc
		push	de
		push	hl

		;; store stack pointer
		ld	iy,#_tsk_current	; address of tsk_current to iy
		ld	l,(iy)			; value of tsk_current to hl
		ld	h,1(iy)
		ld	a,l			; is tsk_current==NULL?
		or	h
		jr	z,no_tsk_current	; no tsk_current, don't store sp
		ex	de,hl			; store value of tsk_current to de
		ld	hl,#0			; value of sp to hl
		add	hl,sp
		ex	de,hl			; de=sp, hl=value of tsk_current
		inc	hl			; mote to 4th word of task_t structure
		inc	hl
		inc	hl
		inc	hl
		ld	(hl),e			; store sp there
		inc	hl
		ld	(hl),d
		jr	has_tsk_current

		;; there is no current task
		;; clean stack and return
no_tsk_current:
		ld	hl,#0
		add	hl,sp
		ld	d,#0
		ld	e,#20
		sbc	hl,de
		ld	sp,hl
		
has_tsk_current:
	__endasm;

	tmr_chain(); /* call timer hooks (mostly device drivers) */
	tsk_roundrobin(); /* round robin to next task */
	
	/*
	 * restore context
	 */

	__asm
		;; restore stack pointer
		ld	iy,#_tsk_current
		ld	l,(iy)
		ld	h,1(iy)
		ld	a,h			
		or	l			; tsk_current==NULL?
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

		;; restore alternate registers
		pop	hl
		pop	de
		pop	bc
		pop	af
		;; restore registers
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
