/*
 *	ukernel.c
 *	yx micro kernel (incl. os entry point)
 *
 *	tomaz stih thu mar 21 2013
 */
#include "yx.h"

void main() {

	/* 
	 * initialize operating system and user heap 
	 */
	mem_init(get_sysheap(), SYSHEAP_TOP - get_sysheap() + 1);
	mem_init(get_usrheap(), USRHEAP_TOP - get_usrheap() + 1);
	
	/*
	 * register device drivers
	 */

	/*
	 * initialize scheduler
	 */
	tmr_install(ball,EVERYTIME,SYS);
	tmr_install(set_ball_timeout,3,SYS);
	tmr_install(set_ball2_timeout,8,SYS);

	/*
	 * gui
	 */
	welcome();

	ball_timeout=evt_create(SYS);
	ball2_timeout=evt_create(SYS);

	//tsk_create(ball_task,256);
	//tsk_create(ball2_task,256);

	dbg_memdump(get_usrheap());
	dbg_evtdump();
	dbg_tmrdump();
	dbg_taskdump();
}

/* 
 * display welcome message 
 */	
void welcome() {
	hires_cls(BLACK, GREEN, BLACK, CM_BRIGHT);
	lores_puts("yx 1.0.0.0 (build mar 22 2013)\nready?\n_\n");
}

/*
 * kernel panic function
 */
void panic(string s) {
	int i;
	hires_cls(BLUE, YELLOW, BLUE, CM_NONE); /* yes, it is the BOD */
	lores_x=lores_y=0;
	lores_puts("kernel panic:\n\n\"");
	lores_puts(s);
	lores_puts("\"");
}

/*
 * scheduler
 */
void scheduler() __naked {
	__asm
		jp	_tsk_switch_improved 	/* switch task */
	__endasm;
}
