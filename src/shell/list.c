/*
 *	list.c
 *	linked list
 *
 *	tomaz stih tue jun 5 2012
 */
#include "yeah.h"

/*
 * insert element into linked list at beggining
 */
list_header_t* lst_insert(list_header_t** first, word size, void* owner) {
	list_header_t *el=mem_allocate(size, (word)owner);
	if (el==NULL) 
		last_error=RESULT_NO_MEMORY_LEFT;
	else {
		el->next=*first;
		el->owner=owner;
		*first=el;
		last_error=RESULT_SUCCESS;
	}
	return el;
}

/*
 * delete element from linked list, frees memory if free!=0
 */
result lst_delete(list_header_t **first, list_header_t *element, byte free) {
	list_header_t *prev;
	list_header_t *curr;
	if (element==NULL)
		return last_error=RESULT_INVALID_PARAMETER;
	else if (element==*first) {
		*first=element->next;
		if (free) mem_free(element);
	} else {
		prev=*first;
		curr=prev->next;
		while (curr && curr!=element) {
			prev=curr;
			curr=curr->next;
		}
		if (!curr) 
			return last_error=RESULT_NOT_FOUND;
		else { /* rewire */
			prev->next=curr->next;
			if (free) mem_free(element);
		}
	}
	return last_error=RESULT_SUCCESS;
}

/*
 * match linked list element (using match function pointer)
 * this can be used for all sorts of tasks, for example if you want to find last element 
 * you seek for element which has element->next==NULL
 */
list_header_t* lst_match(list_header_t *first, list_header_t **last, byte (*match)(list_header_t *element)) {
	list_header_t *curr;
	byte found=0;

	if (first==NULL)
		last_error=RESULT_NOT_FOUND;
	else {
		curr=first;
		while (curr && !match(curr)) {
			*last=curr;
			curr=curr->next;
		}
		if (!curr)
			last_error=RESULT_NOT_FOUND;
		else
			last_error=RESULT_SUCCESS;
	}
	return curr;
}

/*
 * find element in linked list by pointer
 */
result lst_find(list_header_t *first, list_header_t **last, list_header_t *element) {

	list_header_t *curr;
	byte found=0;

	if (first==NULL)
		return last_error=RESULT_NOT_FOUND;
	else {
		curr=first;
		while (curr && curr!=element) {
			*last=curr;
			curr=curr->next;
		}
		if (!curr)
			return last_error=RESULT_NOT_FOUND;
		else
			return last_error=RESULT_SUCCESS;
		
	}
}	
