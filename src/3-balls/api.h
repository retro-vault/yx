/*
 *	api.h
 *	access to operating system application programming interfaces
 *
 *	tomaz stih mon jun 4 2012
 */
#ifndef _API_H
#define _API_H

typedef struct api_s {
	word (*version)();
	void* (*query)(string name);
} api_t;

extern api_t fn_table;
extern word api() __naked;
extern void api_init();

#endif
