/*
 *	yx.h
 *	yx include file.
 *
 *	tomaz stih sun mon 26 2014
 */
#ifndef _YX_H
#define _YX_H

#include "types.h"

/* api */
typedef struct yx_s {
	void* (*malloc());
	void (*free(void *p));
} yx_t;

/* syscall */
extern yx_t yx;
extern void *query_api(string api);

#endif /* _YX_H */
