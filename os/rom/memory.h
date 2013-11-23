/*
 *	memory.h
 *	memory management (mem_allocate, mem_free)
 *
 *	tomaz stih fri may 25 2012
 */
#ifndef _MEMORY_H
#define _MEMORY_H

#define BLK_SIZE	(sizeof(struct block_s) - sizeof(byte[1]))
#define MIN_CHUNK_SIZE	4

/* block status, use as bit operations */
#define NEW             0x00
#define ALLOCATED       0x01

struct block_s {
        list_header_t   hdr;
        byte            stat;
	word 		size;
	byte            data[1];
};

typedef struct block_s block_t;

extern void mem_init(void *heap, word size);
extern void *mem_allocate(void *heap, word size, void *owner);
extern void *mem_free(void *heap, void *p);

#endif
