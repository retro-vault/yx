/*
 *	handle.c
 *	handle management
 *
 *	tomaz stih sun apr 21 2013
 */
#include "yx.h"

/* initialize linked list */
handle_t *handle_first = NULL;

/* create new handle */
handle_t *handle_create(
	void *owner, 
	void ((*terminate)(struct handle_s *me)), 
	word size) {

	handle_t *h;
	if ( h = (handle_t *)syslist_add((void **)&handle_first, size, owner) )
		h->terminate=terminate;
	return h;
}

/* destroy handle, call terminate function on it */
handle_t *handle_destroy(handle_t *h) {
	if (h->terminate) h->terminate(h); /* call terminate if not null */
	return (handle_t *)syslist_delete((void **)&handle_first, (void *)h);
}
