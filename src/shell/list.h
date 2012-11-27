/*
 *	list.h
 *	linked list
 *
 *	tomaz stih tue jun 5 2012
 */
#ifndef _LIST_H
#define _LIST_H

/* each linked list must start with list_header */
typedef struct list_header_s {
	void *next;
	void* owner;
} list_header_t;

extern list_header_t* lst_insert(list_header_t** first, word size, void* owner);
extern result lst_delete(list_header_t **first, list_header_t *element, byte free);
extern result lst_find(list_header_t *first, list_header_t **last, list_header_t *element);
extern list_header_t* lst_match(list_header_t *first, list_header_t **last, byte (*match)(list_header_t *element));

#endif
