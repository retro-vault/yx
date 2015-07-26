/*
 *	app.h
 *	application
 *
 *	tomaz stih wed apr 29 2015
 */
#ifndef _APP_H
#define _APP_H

#include "yx.h"

extern void register_interfaces(); 
extern void *current_task;
extern word heap_size;
extern yx_t *yx;
extern void *heap;

#endif /* _APP_H */
