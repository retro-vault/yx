/*
 *	stdwnd.h
 *	standard windows implementation
 *
 *	tomaz stih tue jul 20 2015
 */
#ifndef _STDWND_H
#define _STDWND_H

#include "yx.h"
#include "window.h"
#include "message.h"

#define APP_WND_MIN_WIDTH	35
#define APP_WND_MIN_HEIGHT	15
#define APP_WND_TITLE_HEIGHT	10
#define APP_WND_BORDER_WIDTH	3
#define APP_WND_BORDER_HEIGHT	3

/* default wnd proc */
extern result desktop_wnd_proc(window_t* wnd, byte id, word param1, word param2);
extern result app_wnd_proc(window_t* wnd, byte id, word param1, word param2);
extern result control_wnd_proc(window_t* wnd, byte id, word param1, word param2);
extern result client_wnd_proc(window_t* wnd, byte id, word param1, word param2);

#endif /* _STDWND_H */
