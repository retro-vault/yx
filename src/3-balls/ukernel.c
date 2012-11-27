/*
 *	ukernel.c
 *
 *	yeah core
 *
 */
#include "yeah.h"

void executive() __naked {

	/*
	 * we're in di mode, just call switch task
	 */
	__asm
		jp	_tsk_switch
	__endasm;
}

void main() {
	
	/*
	 * ----- take over 50Hz interrupt and install api (sort of bios) -----
	 */
	set_vector(RST38,executive,NULL);
	/*set_vector(RST10,api,api_init);*/ 

	/* 
	 * ----- initialize memory management -----
	 */
	mem_init();
	
	/* 
	 * ----- initialize device drivers -----
	 */

	/* keyboard device driver */
	drv_register('K','B','D',	
		kbd_open,
		kbd_close,
		kbd_read_async,
		NULL,
		NULL,
		kbd_timer_hook,
		NULL);

	/* 
	 * ----- create three balls -----
	 */
	init_balls();
	tsk_create(ball, 1024, 256);
	tsk_create(ball2, 1024, 256);
	tsk_create(ball3, 1024, 256);
	
}
