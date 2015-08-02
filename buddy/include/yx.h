/*
 *	yx.h
 *	os header file
 *
 *	tomaz stih sun jul 26 2015
 */
#ifndef _YX_H
#define _YX_H

#include "types.h"

/* API */
typedef struct yx_s yx_t;
struct yx_s {

	/* system lists */
	void* (*lappend)(void **first, void *el);
	void* (*lremove)(void **first, void *el);
	void* (*lremfirst)(void **first);

	/* memory management */
	void* (*allocate)(word size);
	void (*free)(void *p);
	void (*copy)(byte *src, byte *dst, word count);

	/* tasks, events */
	void (*sleep)(word _50);
};

extern void *query_interface(string api);

#endif /* _YX_H */
