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

	/*
	 * gui
	 */
	welcome();
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
