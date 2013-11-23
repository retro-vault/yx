/*
 *	queue.c
 *	fifo queue
 *
 *	TODO: write in assembly if it takes too much space.
 *
 *	tomaz stih thu jul 26 2012
 */
#include "yx.h"

word increase_pos(word pos, word size) {	
	pos++;
	if (pos==size)
		return 0;
	else
		return pos;
}

void que_init(queue_t *q, byte *buffer, word size, byte flags) {
	q->buffer=buffer;
	q->size=size + 1;
	q->head=q->tail=0;
	q->flags=flags;
}

byte que_put(queue_t *q, byte el) {
	q->buffer[q->tail] = el;
	q->tail=increase_pos(q->tail,q->size);
	if (q->head == q->tail) {
		q->head=increase_pos(q->head,q->size);
		return -1; /* overflow */
	} else
		return 0;
}

byte que_get(queue_t *q, byte *el) {
	if (q->head != q->tail) {
		(*el) = q->buffer[q->head];
		q->head=increase_pos(q->head,q->size);
		return 0;
	} else 
		return -1; /* empty queue */
}
