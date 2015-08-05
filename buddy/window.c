/*
 *	window.c
 *	basic window
 *
 *	tomaz stih mon oct 14 2013
 */
#include "window.h"
#include "stdwnd.h"
#include "mouse.h"

extern yx_t *yx;

window_t *window_desktop;

graphics_t* window_graphics(window_t* wnd) {
	return wnd->graphics;
}

void window_init() {
	window_desktop=window_create(
		NULL,
		NULL,
		WF_DESKTOP,
		desktop_wnd_proc,
		0,
		0,
		SCREEN_MAXX,
		SCREEN_MAXY);
}

window_t *window_create(
	string title,
	window_t* parent, 
	byte flags, 
	result ((*wnd_proc)(window_t* wnd, byte id, word param1, word param2)), 
	byte x0, 
	byte y0, 
	byte x1, 
	byte y1) {
	
	window_t* wnd;
	byte w,h;

	/* allocate memory for window */
	wnd=(window_t*)yx->allocate(sizeof(window_t));

	/* flags and title */
	wnd->flags=flags;
	wnd->title=title;

	/* wnd proc */
	wnd->wnd_proc=wnd_proc;

	/* parent and child windows */
	wnd->parent=parent;
	wnd->first_child=NULL;
	if (parent)
		yx->linsert((void **)&(wnd->parent->first_child), (void *)wnd);

	/* send create message */
	message_send(wnd, MSG_WND_CREATE, 0, 0);

	/* create windows graphics */
	wnd->graphics=yx->allocate(sizeof(graphics_t));
	wnd->graphics->area=yx->allocate(sizeof(rect_t));
	wnd->graphics->clip=yx->allocate(sizeof(rect_t));
	wnd->graphics->area->x0=x0;
	wnd->graphics->area->y0=y0;
	wnd->graphics->area->x1=x1;
	wnd->graphics->area->y1=y1;
	message_send(wnd, MSG_WND_SIZE, (word)wnd->graphics->area, 0);
	w=wnd->graphics->area->x1 - wnd->graphics->area->x0;
	h=wnd->graphics->area->y1 - wnd->graphics->area->y0;
	if (parent!=NULL)
		rect_rel2abs(parent->graphics->area,wnd->graphics->area,wnd->graphics->area);

	/* now relative window and its clipping */
	wnd->rect=yx->allocate(sizeof(rect_t));
	wnd->rect->x0=0;
	wnd->rect->y0=0;
	wnd->rect->x1=w;
	wnd->rect->y1=h;
	yx->copy((void *)(wnd->graphics->area),(void *)(wnd->graphics->clip),sizeof(rect_t));

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
	message_send(wnd, MSG_WND_DESTROY, 0, 0);
	yx->free(wnd->graphics->clip);
	yx->free(wnd->graphics->area);
	yx->free(wnd->graphics);
	if (wnd->parent) 
		yx->lremove((void**)&(wnd->parent->first_child), (void *)wnd);
	yx->free(wnd->rect);
	yx->free(wnd);
}

void window_draw_next(window_t *wnd) {
	if (wnd->next) window_draw_next(wnd->next);
	window_draw(wnd);
}

void window_draw(window_t *wnd) {
	byte hide;
	window_t *child=wnd->first_child;
	hide=rect_overlap(wnd->graphics->area,&mouse_rect);
	if (hide) mouse_hide_cursor();
	message_send(wnd, MSG_WND_PAINT, 0, 0); /* draw parent */
	if (hide) mouse_show_cursor(mouse_rect.x0, mouse_rect.y0, current_cursor);
	if (child) window_draw_next(child);
}

void window_select(window_t *wnd) { /* bring window to the front */
	if (wnd->parent==NULL) return; /* nothing to do for desktop */
	yx->lremove((void**)&(wnd->parent->first_child), (void *)wnd);
	yx->linsert((void **)&(wnd->parent->first_child), (void *)wnd);
}

void window_invalidate(window_t* first, rect_t *area) {

	rect_t intersect;
	rect_t smaller[4];
	byte num;

	if (rect_overlap(area, first->rect)) {
		rect_intersect(area, first->rect, &intersect);
		message_send(first, MSG_SYS_PAINT, (word)&intersect, 0);
		first=first->next;
	}
	if (first==NULL) return;
	rect_subtract(area, &intersect, smaller, &num);
	while(num) {
		window_invalidate(first, &(smaller[num-1]));
		num--;
	}
}
