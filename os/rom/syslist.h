/*
 *	syslist.h
 *	system list is a linked list of system objects
 *
 *	tomaz stih tue jun 5 2012
 */
#ifndef _SYSLIST_H
#define _SYSLIST_H

#include "types.h"

extern void *syslist_add(void **first, word size, void *owner);
extern void *syslist_delete(void **first, void *e);

#endif /* _SYSLIST_H */
