/*
 *	window.h
 *	basic window
 *
 *	tomaz stih mon oct 7 2013
 */
#ifndef _WINDOW_H
#define _WINDOW_H

#include "yx.h"
#include "rect.h"
#include "graphics.h"

/* window flags */
#define WF_NONE			0x00
#define	WF_HASTITLE		0x01
#define	WF_HASBORDER		0x02
#define WF_DESKTOP		0x04

/* window sizes */
#define	WMETR_TITLEHEIGHT	12
#define WMETR_BORDERWIDTH	1

/* window structure */
typedef struct window_s window_t;
struct window_s {
	window_t	*next;
	word		reserved;
	struct window_s	*parent;
	struct window_s *first_child;
	byte		flags;
	rect_t		*rect;
	graphics_t 	*graphics;
	result ((*wnd_proc)(window_t* wnd, byte id, word param1, word param2));
	string		title;
};

/* window drawing */
extern window_t *window_desktop;
extern void window_init();
extern graphics_t* window_graphics(window_t* wnd);
extern window_t *window_create(
	string title,
	window_t* parent, 
	byte flags, 
	result ((*wnd_proc)(window_t* wnd, byte id, word param1, word param2)), 
	byte x0, 
	byte y0, 
	byte x1, 
	byte y1);
extern void window_destroy(window_t *wnd);
extern void window_draw(window_t *wnd);
extern void window_select(window_t *wnd);
extern window_t* window_get_app_wnd(window_t *wnd);
extern window_t *window_find_xy(window_t* root, byte absx, byte absy);
extern void window_move(window_t *wnd, byte dx, boolean lr, byte dy, boolean ud);
extern void window_invalidate(rect_t *area, window_t *root, window_t *first);

#endif /* _WINDOW_H */
