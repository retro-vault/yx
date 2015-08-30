/*
 *	system.c
 *	operating system header file
 *
 *	tomaz stih thu mar 21 2013
 */
#ifndef _SYSTEM_H
#define _SYSTEM_H

#include "types.h"

#define SYS_HEAP_END	0x8000
#define USR_HEAP_START	SYS_HEAP_END
#define USR_HEAP_END	0xFFFF

extern void *sys_stack;
extern void *sys_heap;

extern void sys_tarpit(); /* the tar pit, primordial soup */

#endif /* _SYSTEM_H */
