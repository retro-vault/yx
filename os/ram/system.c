/*
 *	system.c
 *	system specifics 
 *
 *	tomaz stih wed apr 3 2013
 */
#include "yx.h"

/*
 * system heap 
 */
word get_sysheap() __naked {
	__asm
		ld	hl,#sysheap
		ret
	__endasm;
}

/*
 * user heap
 */
word get_usrheap() __naked {
	__asm
		ld	hl,#0x8000
		ret
	__endasm;
}

/*
 * adding to system list
 */
void *syslist_add(void **first, word size, void *owner) {
	list_header_t *p;
	if( p = (list_header_t *)mem_allocate(get_sysheap(), size, owner) ) {
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
		e = mem_free(get_sysheap(), e);
	}
	return e;
}
