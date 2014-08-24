/*
 *	yx.c
 *	yx api.
 *
 *	tomaz stih sun mon 26 2014
 */
#include "yx.h"
#include "string.h"

yx_t yx;

/* fake sys call */
void *query_api(string api) {
	if (!strcmp(api,"yx")) {
		yx.malloc=NULL;
		yx.free=NULL;
		return &yx;
	}
	else
		return NULL;
}
