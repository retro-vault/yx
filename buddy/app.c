/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu apr 16 2015
 */
#include "app.h"
#include "window.h"
#include "stdwnd.h"
#include "message.h"
#include "mouse.h"

void *current_task=NULL; /* will be real in OS environment */
word heap_size; /* normally calculated inside crt0 */

yx_t *yx;

void main() {

	/* init OS wrapper */	
	heap_size=0xffff - (word)&heap; /* calc heap size */
	register_interfaces();
	yx=(yx_t *)query_interface("yx");

	/* init buddy */
	buddy_init();

	/* main loop */
	while (TRUE) {
		buddy_harvest_events();
		message_dispatch();
	}
}
