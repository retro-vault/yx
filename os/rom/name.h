/*
 *	name.h
 *	named resources management
 *
 *	NOTE: no convention is forced but yx uses first four characters
 *	      of name for type and next four for name i.e. /dev/kbd,
 *	      /dev/232, /wnd/top
 *	
 *	TODO: binary tree if rom space available
 *
 *	tomaz stih wed apr 10 2013
 */
#ifndef _NAME_H
#define _NAME_H

#define MAX_NAME_LEN	8

typedef struct name_s {
	list_header_t hdr;		/* compatible with list_header_t */
	byte name[MAX_NAME_LEN+1];	/* max sys name length */
	void *resource;			/* pointer to named resource */	
} name_t;

extern name_t *name_first;

extern name_t *name_link(
	void *owner, 
	string name,
	void *resource);
extern name_t *name_unlink(name_t *n);
extern name_t *name_find(string name);

#endif
