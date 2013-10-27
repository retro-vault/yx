/*
 *	window.h
 *	basic window
 *
 *	tomaz stih mon oct 7 2013
 */
#ifndef _WINDOW_H
#define _WINDOW_H

#include "types.h"
#include "rect.h"

typedef struct window_s {
	result (*wnd_proc)(byte id, word param1, word param2);
	
} window_t;

extern window_t *window_get_screen(); /* screen window */

#endif /* _WINDOW_H */
