/*
 *	list.c
 *	linked list
 *
 *	tomaz stih tue jun 5 2012
 */
#include "yx.h"

/*
 * check if arg and pointer are equal
 */
byte list_match_eq(list_header_t *p, word arg) {
        return ( ((word)p) == arg );
}

/*
 * find element using match function
 * this can be used for all sorts of tasks, for example if you want to find last element
 * you seek for element which has element->next==NULL
 */
list_header_t* list_find(
        list_header_t *first,
        list_header_t **prev,
        byte ((*match)(list_header_t *p, word arg)),
        word the_arg)
        {
        /* assume no previous */
        *prev=NULL;
	while (first && !match(first,the_arg)) {
	        *prev=first;
	        first=first->next;
	}
        /* result is in first */
        return first;
}

/*
 * insert element into linked list at begining
 */
list_header_t *list_insert(list_header_t** first, list_header_t *el) {
        el->next=*first;
        *first=el;
	return el;
}

/*
 * removes element from linked list
 */
list_header_t *list_remove(list_header_t **first, list_header_t *el) {
	list_header_t *prev;
	if (el==*first) {
		*first=el->next;
	} else {
		if (!list_find(*first, &prev, list_match_eq, (word) el))
			return NULL;
		else  /* rewire */
			prev->next=el->next;
	}
	return el;
}
