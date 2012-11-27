/*
 *	memory.c
 *	memory management (mem_allocate, mem_free)
 *	
 *	tomaz stih fri may 25 2012
 */
#include "yeah.h"

#pragma disable_warning 85
#pragma disable_warning 154

extern word get_heap();

word brk_addr;
block_t *mem_first=NULL;
block_t *mem_last=NULL;

/*
 * ---------- private (helpers) ----------
 */
block_t *find_block(word size) {
	block_t *b;
	if (mem_first==NULL) /* virgin heap */
		return NULL;
	else {
		b=mem_first;
		while (b && !(b->owner==NULL && b->size >= size ))
			b = b->next;
	}
	return b;
}

void * sbrk (word incr) {
	word old_brk=brk_addr;
	if (0xffff - brk_addr < incr )
		return NULL; /* safe value for zx spectrum, but not standard! */
	else {
		brk_addr += incr;
		return (void *)old_brk;
	}
}

void brk(void *addr) {
	brk_addr=(word)addr;
}

void split ( block_t *b, word size) {
	
	block_t *new;
	new = (word) b->data + (word) size;
	new->owner=NULL;
	new->size = b->size - (size + BLK_SIZE);
	new->next = b->next;
	new->prev=b;
	
	b->size = size;
	if (b->next) 
		b->next->prev=new;
	else
		mem_last=new;
	b->next = new;
}

block_t * merge_with_next ( block_t *b ) {

	b->size += ( BLK_SIZE + b->next->size );
	b->next = b->next->next;
	if (b->next)
		b->next->prev=b;
	else
		mem_last=b;

	return b;
}


/*
 * ---------- public ----------
 */

/*
 * initialize memory management
 */
void mem_init() {
	brk_addr=get_heap();
}

/*
 * allocate memory block
 */
void *mem_allocate(word size, word owner) {
	block_t *b;
	if (!mem_first) {
		mem_first = mem_last = b = (block_t *)sbrk(size + BLK_SIZE);
		b->prev=b->next=NULL;
		b->owner=owner;		
		b->size=size;
	} else {
		b=find_block(size);
		if (b) {
			if (b->size > BLK_SIZE + MIN_CHUNK_SIZE)
				split(b, size);
			b->owner=owner;
		} else {
			b = (block_t *)sbrk(size + BLK_SIZE);
			mem_last->next=b;
			b->prev=mem_last;
			b->owner=owner;
			b->size=size;
			b->next=NULL;
			mem_last=b;
		}
	}
	if (!b)
		return NULL;
	else 
		return (void *)(b->data);
}

/*
 * free memory block
 */
void mem_free(void *p) {

	block_t *b;
	word baddr;

	/* calculate block address from pointer */
	baddr=(word)p;
	baddr-=BLK_SIZE;
	b=baddr;

	b->owner=NULL; /* release block */

	/* 
	 * merge 3 blocks if possible
	 */
	if (b->prev && b->prev->owner==NULL) /* try previous */
		b = merge_with_next(b->prev);
	if (b->next && b->next->owner==NULL) /* try next */
		merge_with_next(b);

	if (b->next==NULL) { /* are we at the end of the heap? */
		if (b->prev==NULL) /* mem_first? */
			mem_first=mem_last=NULL;
		else {
			b->prev->next = NULL;
			mem_last=b->prev;
		}
		brk(b);
	}
}


