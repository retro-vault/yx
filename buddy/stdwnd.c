/*
 *	stdwnd.c
 *	standard windows implementation
 *
 *	tomaz stih tue jul 20 2015
 */
#include "stdwnd.h"
#include "errors.h"
#include "masks.h"
#include "message.h"

extern yx_t* yx;

result desktop_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	
	rect_t clip_rect;
	param2; /* unused */

	switch(id) {
	case MSG_SYS_PAINT:
		/* set clip */
		if (param1) {
			yx->copy((void*)wnd->graphics->clip,(void*)&clip_rect,sizeof(rect_t));
			yx->copy((void*)param1,(void*)wnd->graphics->clip,sizeof(rect_t));
		}			
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,(byte*)&msk_percent50_8x8, MODE_COPY);
		/* restore clip */
		if (param1) 
			yx->copy((void*)&clip_rect,(void*)wnd->graphics->clip,sizeof(rect_t));
	}

	return SUCCESS; /* we are the desktop!!! */
}

void draw_double_frame(window_t *wnd, rect_t *rect) {
	rect_t temp_rect;

	yx->copy((void*)rect,(void*)&temp_rect,sizeof(rect_t)); 
	graphics_draw_rect(wnd->graphics, &temp_rect, 0xff, MODE_COPY);
	rect_inflate(&temp_rect,-1,-1);
	graphics_draw_rect(wnd->graphics, &temp_rect, 0x00, MODE_COPY);
	rect_inflate(&temp_rect,-1,-1);
	graphics_draw_rect(wnd->graphics, &temp_rect, 0xff, MODE_COPY);
}
 
result app_wnd_proc(window_t* wnd, byte id, word param1, word param2) {

	rect_t *wrct;
	rect_t title_rect;
	rect_t clip_rect;
	rect_t client;
	byte *hit_result;
	byte x,y;

	id, param1, param2;

	switch(id) {

	case MSG_WND_CREATED:
		/* create client */
		window_create(
			NULL,
			wnd,
			WF_NONE,
			client_wnd_proc,
			APP_WND_BORDER_WIDTH,
			APP_WND_BORDER_HEIGHT + APP_WND_TITLE_HEIGHT - 1,
			wnd->rect->x1 - APP_WND_BORDER_WIDTH,
			wnd->rect->y1 - APP_WND_BORDER_HEIGHT);
		return SUCCESS;

	case MSG_SYS_PAINT:	
		/* set clip */
		if (param1) {
			yx->copy((void*)wnd->graphics->clip,(void*)&clip_rect,sizeof(rect_t));
			yx->copy((void*)param1,(void*)wnd->graphics->clip,sizeof(rect_t));
		}

		/* window border */
		if (wnd->flags & WF_HASBORDER) draw_double_frame(wnd, wnd->rect);

		/* window title */
		if (wnd->flags & WF_HASTITLE) {
			title_rect.x0=APP_WND_BORDER_WIDTH;
			title_rect.y0=APP_WND_BORDER_HEIGHT;
			title_rect.x1=wnd->rect->x1 - APP_WND_BORDER_WIDTH;
			title_rect.y1=APP_WND_TITLE_HEIGHT;
			graphics_fill_rect(wnd->graphics,&title_rect,(byte *)&msk_empty_8x8, MODE_COPY);
			rect_inflate(&title_rect,1,1);
			graphics_draw_rect(wnd->graphics,&title_rect,0xff, MODE_COPY);
		}

		/* client window */
		if (param1) {
			rect_intersect(wnd->first_child->graphics->clip, (rect_t*)param1, &client);
			message_send(wnd->first_child, MSG_WND_PAINT, (word)&client, 0);
		} else
			message_send(wnd->first_child, MSG_WND_PAINT, 0, 0);
		
		/* restore clip */
		if (param1) 
			yx->copy((void*)&clip_rect,(void*)wnd->graphics->clip,sizeof(rect_t));		
	
		return SUCCESS;

	case MSG_WND_SIZE:
		/* enforce minimal size */
		wrct=(rect_t*)param1;
		if (wrct->x1-wrct->x0+1 < APP_WND_MIN_WIDTH)
			wrct->x1=wrct->x0+APP_WND_MIN_WIDTH-1;
		if (wrct->y1-wrct->y0+1 < APP_WND_MIN_HEIGHT)
			wrct->y1=wrct->y0+APP_WND_MIN_HEIGHT-1;
		/* update client rect 
		if (wnd->first_child) {
			client.x0=wrct->x0 + APP_WND_BORDER_WIDTH;
			client.y0=wrct->y0 + APP_WND_BORDER_HEIGHT + APP_WND_TITLE_HEIGHT - 1;
			client.x1=wrct->x1 - APP_WND_BORDER_WIDTH;
			client.y1=wrct->y1 - APP_WND_BORDER_HEIGHT;
			yx->copy((void*)&client,(void*)wnd->first_child->graphics->area,sizeof(rect_t));
			yx->copy((void*)&client,(void*)wnd->first_child->graphics->clip,sizeof(rect_t));
			//message_send(wnd->first_child,MSG_WND_SIZE,(word)&client,0);
		}
		*/
		return SUCCESS;

	case MSG_WND_HITTEST:
		/* these are absolute coordinates */
		hit_result=(byte *)param1;
		y=param2&0x00ff;
		x=param2>>8;

		if (x > wnd->graphics->area->x1 - 5 && y > wnd->graphics->area->y1-5)
			*hit_result=WND_HIT_RESIZE; 
		else if (x < wnd->graphics->area->x0 + 8 && y < wnd->graphics->area->y0 + 8)
			*hit_result=WND_HIT_CLOSE;
		else
			*hit_result=WND_HIT_TITLE;

		return SUCCESS;
	}
	

	return NOT_PROCESSED;
}

result client_wnd_proc(window_t* wnd, byte id, word param1, word param2) {

	rect_t clip_rect;

	param2;
	
	switch(id) {

	case MSG_WND_PAINT:
		/* set clip */
		if (param1) {
			yx->copy((void*)wnd->graphics->clip,(void*)&clip_rect,sizeof(rect_t));
			yx->copy((void*)param1,(void*)wnd->graphics->clip,sizeof(rect_t));
		}	
		graphics_fill_rect(wnd->graphics,wnd->rect,(byte*)&msk_empty_8x8, MODE_COPY);
		/* restore clip */
		if (param1) 
			yx->copy((void*)&clip_rect,(void*)wnd->graphics->clip,sizeof(rect_t));		
		return SUCCESS;
	case MSG_WND_SIZE:
		break;
	}

	return NOT_PROCESSED;
}

result control_wnd_proc(window_t* wnd, byte id, word param1, word param2) {
	id, param1, param2;

	switch(id) {

	case MSG_SYS_PAINT:	
		/* clear screen space */
		graphics_fill_rect(wnd->graphics,wnd->rect,(byte*) &msk_empty_8x8, MODE_COPY);
		/* window border */
		if (wnd->flags & WF_HASBORDER)
			graphics_draw_rect(wnd->graphics,wnd->rect,0xaa, MODE_COPY);
		return SUCCESS;	
	}

	return NOT_PROCESSED;
}
