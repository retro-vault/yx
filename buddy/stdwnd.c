/*
 *	stdwnd.c
 *	standard windows implementation
 *
 *	tomaz stih tue jul 20 2015
 */
#include "stdwnd.h"
#include "errors.h"

result desktop_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	static byte desktop_pattern[]={0x55,0xaa,0x55,0xaa,0x55,0xaa,0x55,0xaa};

	id,param1, param2;

	switch(id) {
		case MSG_WND_PAINT:
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,desktop_pattern, MODE_COPY);
		break;
	}

	return SUCCESS;
}

result app_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	static byte empty_mask[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
	static byte lines_mask[]={0x00,0xff,0x00,0xff,0x00,0xff,0x00};
	static byte fill_mask[]={0xf8, 0x70, 0x20};
	
	rect_t *wrct;
	rect_t tmprct;

	id, param1, param2;

	switch(id) {

	case MSG_WND_PAINT:	
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,empty_mask, MODE_COPY);
		/* window border */
		if (wnd->flags & WF_HASBORDER) {
			/* draw first rect */
			graphics_draw_rect(wnd->graphics,wnd->rect,0xff, MODE_COPY);
		
			/* draw inner rect */
			tmprct.x0=wnd->rect->x0+2;
			tmprct.y0=wnd->rect->y0+2;
			tmprct.x1=wnd->rect->x1-2;
			tmprct.y1=wnd->rect->y1-2;
			graphics_draw_rect(wnd->graphics,&tmprct,0xff, MODE_COPY);
		}
		/* window title */
		if (wnd->flags & WF_HASTITLE) {
			/* first big title */
			tmprct.x0=wnd->rect->x0+2;
			tmprct.y0=wnd->rect->y0+2;
			tmprct.x1=wnd->rect->x1-2;
			tmprct.y1=wnd->rect->y0+10;
			graphics_draw_rect(wnd->graphics,&tmprct,0xff, MODE_COPY);			

			tmprct.x1=wnd->rect->x0+10;
			graphics_draw_rect(wnd->graphics,&tmprct,0xff, MODE_COPY);	

			tmprct.x0=wnd->rect->x0+4;
			tmprct.y0=wnd->rect->y0+6;
			tmprct.x1=wnd->rect->x0+8;
			tmprct.y1=wnd->rect->y0+6;
			graphics_fill_rect(wnd->graphics,&tmprct,fill_mask, MODE_COPY);

			tmprct.x0=wnd->rect->x1-10;
			tmprct.y0=wnd->rect->y0+2;
			tmprct.x1=wnd->rect->x1-2;
			tmprct.y1=wnd->rect->y0+10;
			graphics_draw_rect(wnd->graphics,&tmprct,0xff, MODE_COPY);	

			tmprct.x0=wnd->rect->x1-8;
			tmprct.y0=wnd->rect->y0+5;
			tmprct.x1=wnd->rect->x1-4;
			tmprct.y1=wnd->rect->y0+7;
			graphics_fill_rect(wnd->graphics,&tmprct,fill_mask, MODE_COPY);
		}
		break;

	case MSG_WND_SIZE:
		/* enforce minimal size */
		wrct=(rect_t*)param1;
		if (wrct->x1-wrct->x0+1 < MINAPPWNDW)
			wrct->x1=wrct->x0+MINAPPWNDW-1;
		if (wrct->y1-wrct->y0+1 < MINAPPWNDH)
			wrct->y1=wrct->y0+MINAPPWNDH-1;
		break;
	}

	return SUCCESS;
}

result control_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	static byte empty_mask[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};

	id, param1, param2;

	switch(id) {

	case MSG_WND_PAINT:	
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,empty_mask, MODE_COPY);
		/* window border */
		if (wnd->flags & WF_HASBORDER)
			graphics_draw_rect(wnd->graphics,wnd->rect,0xaa, MODE_COPY);
		break;	
	}

	return SUCCESS;
}
