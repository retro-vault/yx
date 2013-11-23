/*
 *	queue.h
 *	fifo queue
 *
 *	tomaz stih thu jul 26 2012
 */
#ifndef _QUEUE_H
#define _QUEUE_H

#define QUE_FL_NORMAL	0x00

typedef struct queue_s {
	byte *buffer;
	word size;
	word head;
	word tail;
	byte flags;
} queue_t; 

extern void que_init(queue_t *q, byte *buffer, word size, byte flags);
extern byte que_put(queue_t *q, byte el);
extern byte que_get(queue_t *q, byte *el);

#endif
