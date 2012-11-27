/*
 *	api.c
 *	access to operating system application programming interfaces
 *
 *	tomaz stih mon jun 4 2012
 */
#include "yeah.h"

api_t fn_table;

/*
 * rst 10 handler
 * returns function table
 */
word api() __naked {
	__asm
		ld	hl,#_fn_table
		reti
	__endasm;
	
}

/*
 * query api
 */
void *api_query(string name) {
	/*
	 * release "retro" can do yeah, buddy, net, and filesys 
	 */
	if (!strcmp(name,"yeah"))
		return NULL;
	else if (!strcmp(name,"buddy"))
		return NULL;
	else if (!strcmp(name,"net"))
		return NULL;
	else if (!strcmp(name,"filesys"))
		return NULL;
}

/*
 * return api version
 */
word api_version() {
	return VERSION; 
}

/*
 * initialize api function table
 */
void api_init() {
	fn_table.version=api_version;
	fn_table.query=api_query;
}
