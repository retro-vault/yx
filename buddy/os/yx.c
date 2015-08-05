/*
 *	yx.c
 *	operating system wrapper.
 *
 *	tomaz stih sun jul 26 2015
 */
#include "yx.h"
#include "list.h"
#include "memory.h"


/* fixed api pointer */
yx_t yx_api;


/* expected OS externals */
extern void *current_task;
extern void *heap;
extern word heap_size;


/* wrapper functions */
void *allocate(word size) {
	return mem_allocate(&heap,size,&current_task);
}

void free(void *p) {
	mem_free(&heap,p);
}

void *lappend(void **first, void *el) {
	return (void*)list_append((list_header_t**) first, (list_header_t*) el);
}

void *linsert(void **first, void *el) {
	return (void*)list_insert((list_header_t**) first, (list_header_t*) el);
}

void *lremove(void **first, void *el) {
	return (void*)list_remove((list_header_t**) first, (list_header_t*) el);
}

void *lremfirst(void **first) {
	return (void*)list_remove_first((list_header_t**) first);
}

void sleep(word _50) {
	int i;
	while (_50--)
		for(i=0;i<100;i++);
}

/* yx interface */
void register_interfaces() {

	mem_init(&heap,heap_size);

	yx_api.lappend=lappend;
	yx_api.lremove=lremove;
	yx_api.lremfirst=lremfirst;
	yx_api.linsert=linsert;

	yx_api.allocate=allocate;
	yx_api.free=free;
	yx_api.copy=mem_copy;

	yx_api.sleep=sleep;
}

void *query_interface(string api) {
	api;
	return (void *)(&yx_api);
}
