/*
 *	syslist.c
 *	system list is a linked list of system objects
 *
 *	tomaz stih tue jun 5 2012
 */
#include "types.h"
#include "list.h"
#include "memory.h"
#include "system.h"

/*
 * adding to system list
 */
void *syslist_add(void **first, word size, void *owner) {
	list_header_t *p;
	if( p = (list_header_t *)mem_allocate(&sys_heap, size, owner) ) {
		list_insert((list_header_t**)first,p);
		p->owner=owner;
	}
	return (void *)p;
}

/*
 * removing from system list
 */
void *syslist_delete(void **first, void *e) {
	if ( e = list_remove( (list_header_t **)first, (list_header_t *)e) ) {
		e = mem_free(&sys_heap, e);
	}
	return e;
}
