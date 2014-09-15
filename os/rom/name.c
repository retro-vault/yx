/*
 *	name.c
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
#include "yx.h"

/* initialize linked list */
name_t *name_first = NULL;


/* ----- private helpers ----- */
byte match_name(list_header_t *p, word name) {
        name_t *n = (name_t *)p;
        return !strcmp(n->name, (string)name);
}


/* ----- public interface ----- */

/* 
 * link name with resource 
 * TODO: exclude duplicates to prevent disaster
 */
name_t *name_link(
	void *owner, 
	string name,
	void *resource) {

	name_t *n;

	/* check max length */
	if (strlen(name) > MAX_NAME_LEN)
		return NULL;

	if ( n = (name_t *)syslist_add((void **)&name_first, sizeof(name_t), owner) ) {
		strcpy(n->name, name);
		n->resource=resource;
	}
	return n;
}

/*
 * unlink name and resource 
 */
name_t *name_unlink(name_t *n) {
	return (name_t *)syslist_delete((void **)&name_first, (void *)n);
}

/* 
 * find a name
 */
name_t *name_find(string name) {
	name_t *prev;
	return (name_t *)list_find(
		(list_header_t *)name_first, 
		(list_header_t **)&prev, 
		match_name, 
		(word)name
	);
}
