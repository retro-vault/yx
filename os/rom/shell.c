/*
 *	shell.c
 *	simple shell
 *
 *	tomaz stih sun sep 14 2014
 */
#include "yx.h"

void shell() {
	welcome();
	while (1);
}

/* 
 * display welcome message 
 */	
void welcome() {
	hires_cls(BLACK, GREEN, BLACK, CM_BRIGHT);
	lores_puts("yx 1.0.0.0 (build mar 22 2013)\n");
}
