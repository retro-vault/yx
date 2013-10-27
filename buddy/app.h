/*
 *	app.h
 *	application
 *
 *	tomaz stih sun oct 27 2013
 */
#ifndef _APP_H
#define _APP_H

#include "types.h"
#include "window.h"

typedef struct app_s {
	window_t *top_window;
} app_t;

#endif /* _APP_H */
