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
	 * scheduler RST38
	 */
	setvect(RST38, tsk_switch, NULL);

	/*
	 * register device drivers
	 */

	/*
	 * initialize scheduler
	 */

	/*
	 * shell, stack size=512
	 */
	tsk_create(shell, 512); 
}

/*
 * kernel panic function
 */
void panic(string s) {
	hires_cls(BLUE, YELLOW, BLUE, CM_NONE); /* yes, it is the BOD */
	lores_x=lores_y=0;
	lores_puts("kernel panic:\n\n\"");
	lores_puts(s);
	lores_puts("\"");
}
