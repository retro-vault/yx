/*
 *	window.c
 *	basic window
 *
 *	tomaz stih mon oct 14 2013
 */
#include "window.h"
#include "stdwnd.h"

extern yx_t *yx;

window_t *window_desktop;

graphics_t* window_graphics(window_t* wnd) {
	return wnd->graphics;
}

void window_init() {
	window_desktop=window_create(
		NULL,
		WF_DESKTOP,
		desktop_wnd_proc,
		0,
		0,
		SCREEN_MAXX,
		SCREEN_MAXY);
}

window_t *window_create(
	window_t* parent, 
	byte flags, 
	result ((*wnd_proc)(window_t* wnd, byte id, word param1, word param2)), 
	byte x0, 
	byte y0, 
	byte x1, 
	byte y1) {
	
	window_t* wnd;
	window_t* iter;	

	/* allocate memory for window */
	wnd=(window_t*)yx->allocate(sizeof(window_t));

	/* flags */
	wnd->flags=flags;

	/* create and populate window rectangle */
	wnd->rect=yx->allocate(sizeof(rect_t));
	wnd->rect->x0=x0;
	wnd->rect->y0=y0;
	wnd->rect->x1=x1;
	wnd->rect->y1=y1;

	/* wnd proc */
	wnd->wnd_proc=wnd_proc;

	/* parent and child windows */
	wnd->parent=parent;
	wnd->first_child=NULL;
	if (parent)
		yx->linsert((void **)&(wnd->parent->first_child), (void *)wnd);

	/* create windows graphics */
	wnd->graphics=yx->allocate(sizeof(graphics_t));
	wnd->graphics->area=yx->allocate(sizeof(rect_t));
	wnd->graphics->clip=yx->allocate(sizeof(rect_t));
	yx->copy((void *)(wnd->rect),(void *)(wnd->graphics->area),sizeof(rect_t));
	iter = wnd->parent;
	while (iter) {
		rect_rel2abs(iter->graphics->area,wnd->graphics->area,wnd->graphics->area);
		iter = iter->parent;
	}	
	yx->copy((void *)(wnd->rect),(void *)(wnd->graphics->clip),sizeof(rect_t));

	/* and return */
	return wnd;
}

void window_destroy(window_t *wnd) {
	
	/* destroy all child windows first */
	window_t *child=wnd->first_child;
	window_t *next;
	while(child) {
		next=child->next;
		window_destroy(child);
		child=next;
	}

	/* now destroy window */
	yx->free(wnd->graphics->clip);
	yx->free(wnd->graphics->area);
	yx->free(wnd->graphics);
	if (wnd->parent) 
		yx->lremove((void**)&(wnd->parent->first_child), (void *)wnd);
	yx->free(wnd->rect);
	yx->free(wnd);
}


