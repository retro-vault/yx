/*
 *	memory.h
 *	memory management (mem_allocate, mem_free)
 *	
 *	tomaz stih fri may 25 2012
 */
#ifndef _MEMORY_H
#define _MEMORY_H

#define BLK_SIZE	sizeof(struct block_s) - 1
#define MIN_CHUNK_SIZE	4

#define KALLOC		0x0100

extern word brk_addr;

extern struct task_s;
extern struct task_s *current;

struct block_s {
	struct task_s	*owner;
	word 		size;
	struct block_s	*next;
	struct block_s	*prev;
	byte		data[1];
};

typedef struct block_s block_t;

extern block_t *mem_first;
extern block_t *mem_last;

extern void *mem_allocate(word size, word owner);
extern void mem_free(void *);

#endif
