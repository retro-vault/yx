/*
 *	app.c
 *	backbone of yeah application
 *
 *	tomaz stih thu apr 16 2015
 */
#include "app.h"
#include "window.h"
#include "message.h"

void *current_task=NULL; /* will be real in OS environment */
word heap_size; /* normally calculated inside crt0 */

yx_t *yx;

void main() {
	heap_size=0xffff - (word)&heap; /* calc heap size */
	register_interfaces();
	yx=(yx_t *)query_interface("yx");
	window_init();
	message_send(window_desktop, MSG_WND_PAINT, 0, 0);
}
