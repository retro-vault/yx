/*
 *	memory.h
 *	memory management (mem_allocate, mem_free)
 *
 *	tomaz stih fri may 25 2012
 */
#ifndef _MEMORY_H
#define _MEMORY_H

#include "types.h"
#include "list.h"

#ifndef NONE
#define NONE		0
#endif

#ifndef SYS
#define SYS		0
#endif

#define BLK_SIZE	(sizeof(struct block_s) - sizeof(byte[1]))
#define MIN_CHUNK_SIZE	4

/* block status, use as bit operations */
#define NEW             0x00
#define ALLOCATED       0x01

typedef struct block_s {
        list_header_t   hdr;
        byte            stat;
	word 		size;
	byte            data[1];
} block_t;

extern void *heap;

extern void mem_init(void *heap, word size);
extern void *mem_allocate(void *heap, word size, void *owner);
extern void *mem_free(void *heap, void *p);
extern void mem_copy(byte *src, byte *dest, word count) __naked;

#endif
