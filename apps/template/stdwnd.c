/*
 *	stdwnd.c
 *	standard windows implementation
 *
 *	tomaz stih tue jul 20 2015
 */
#include "stdwnd.h"

result desktop_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	static byte desktop_pattern[]={0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};

	id,param1, param2;

	switch(id) {
		case MSG_WND_PAINT:
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,desktop_pattern);
		break;
	}

	return 0;
}

result app_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	static byte empty_mask[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
	static byte lines_mask[]={0x00,0xff,0x00,0xff,0x00,0xff,0x00};

	id, param1, param2;

	switch(id) {
	case MSG_WND_PAINT:	
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,empty_mask);
		/* window border */
		if (wnd->flags & WF_HASBORDER)
			graphics_draw_rect(wnd->graphics,wnd->rect,0xff);
		/* window title */
		if (wnd->flags & WF_HASTITLE) {
		}
		break;
	}

	return 0;
}
