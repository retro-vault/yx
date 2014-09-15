/*
 *	app.c
 *	sample app for yx
 *
 *	tomaz stih sun sep 14 2014
 */
#include "app.h"

int main() {
	yx_t *yx=query_api("yx");
	void* memblk=yx->malloc(1024);
	yx->free(memblk);	
	yx->exit(0);
}
