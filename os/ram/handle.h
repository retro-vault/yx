/*
 *	handle.h
 *	handle management
 *
 *	tomaz stih sun apr 21 2013
 */
#ifndef _HANDLE_H
#define _HANDLE_H

typedef struct handle_s {
	/* list_header_t compatible header */
	list_header_t hdr;
	/* terminate function */
	void ((*terminate)(struct handle_s *me));
} handle_t;

extern handle_t *handle_first;
extern handle_t *handle_create(
	void *owner, 
	void ((*terminate)(struct handle_s *me)), 
	word size);
extern handle_t *handle_destroy(handle_t *e);

#endif
