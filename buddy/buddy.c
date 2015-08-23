/*
 *	buddy.c
 *	main buddy loop, mostly event harvesting
 *	and message dispatching.
 *
 *	tomaz stih sun jul 2 2015
 */
#include "yx.h"
#include "buddy.h"
#include "window.h"
#include "message.h"
#include "mouse.h"
#include "stdwnd.h"

extern yx_t *yx;

buddy_op_t buddy_op;

void temp_shit() {
	static window_t *w1, *w2, *w3, *w4, *w5, *w6, *w7, *w8;

	w1=window_create(
		"Window 1",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		2,
		2,
		80,
		50);
	w2=window_create(
		"Window 2",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		52,
		35,
		213,
		160);
	
	w3=window_create(
		"Window 3",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		0,
		80,
		60,
		132);
	
	w4=window_create(
		"Window 4",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		35,
		20,
		65,
		160);
	w5=window_create(
		"Window 5",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		205,
		50,
		250,
		100);
	w6=window_create(
		"Window 6",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		25,
		95,
		218,
		115);
	w7=window_create(
		"Window 7",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		40,
		140,
		70,
		190);
	w8=window_create(
		"Window 8",
		window_desktop,
		WF_HASTITLE|WF_HASBORDER,
		app_wnd_proc,
		200,
		150,
		250,
		180);
}

void buddy_init() {

	/* init messaging */
	message_init();

	/* init windows system */
	window_init();

	temp_shit();

	/* buddy vars */
	buddy_op.op = BUDDY_OP_NONE;

	/* draw desktop */
	window_draw(window_desktop);

	/* init mouse */
	mouse_init();

	/* show mouse cursor for the first time */
	mouse_show_cursor(mi.x, mi.y, current_cursor);
}

void buddy_harvest_events() {
	
	/* MSG_MOUSE_MOVE */
	mouse_scan(&mi);
	if (mouse_rect.x0!=mi.x || mouse_rect.y0!=mi.y) { /* coord changed */

		/* operation in progress? */
		if (buddy_op.op==BUDDY_OP_MOVING || buddy_op.op==BUDDY_OP_SIZING)
			buddy_xor_op_rect(); /* del old rect */
		
		/* first repaint mouse */ 
		mouse_hide_cursor();
		mouse_show_cursor(mi.x, mi.y, current_cursor);

		/* remember new coords */
		calc_mouse_rect(&mi);

		/* and post message */
		buddy_dispatch(MSG_MOUSE_MOVE, mouse_rect.x0, mouse_rect.y0);
	}

	if (mi.button_change) { /* is it worth looking at? */
		/* is it the left button? */
		if (mi.button_change & MOUSE_LBUTTON) {
			/* is it down? */			
			if (mi.button & MOUSE_LBUTTON) 
				buddy_dispatch(MSG_MOUSE_LDOWN, mouse_rect.x0, mouse_rect.y0);
			else
				buddy_dispatch(MSG_MOUSE_LUP, mouse_rect.x0, mouse_rect.y0);
		}
	}
}

void buddy_dispatch(byte id, word param1, word param2) {

	window_t *affectedwnd, *appwnd;
	boolean lr,ud;
	byte dx,dy;
	byte hit=WND_HIT_NONE;
	rect_t affectedrect;
	rect_t client;
	byte num;
	rect_t smaller[4];

	switch (id) {

		case MSG_MOUSE_LDOWN:
			/* find affected window */
			affectedwnd=window_find_xy(window_desktop,(byte)param1,(byte)param2); 

			if (affectedwnd==window_desktop) { /* desktop i.e. root */
				message_post(window_desktop,id,param1,param2);	
			} else { /* not desktop */

				/* if child window of non active desktop window then
				   activate first */
				if ((appwnd=window_get_app_wnd(affectedwnd))!=window_desktop->first_child) {
					window_select(appwnd); /* bring to front */
					window_draw(appwnd);
				}
		
				/* hit test window for system areas? */
				message_send(affectedwnd,MSG_WND_HITTEST,(word)&hit,(word)param1<<8|(word)param2);

				/* store mouse to current operation (whatever) */
				buddy_op.mx=(byte)param1;
				buddy_op.my=(byte)param2;

				switch(hit) {
					case WND_HIT_NONE: /* just forward message */
						message_post(affectedwnd,id,param1,param2);
						break;
					case WND_HIT_TITLE: /* start window drag operation */
						buddy_op.op=BUDDY_OP_MOVE;
						buddy_op.wnd=appwnd;
						buddy_op.ix=buddy_op.mx;
						buddy_op.iy=buddy_op.my;
						yx->copy(
							(void*)affectedwnd->graphics->area,
							(void*)&(buddy_op.rect),
							sizeof(rect_t)
						);
						break;
					case WND_HIT_RESIZE: /* start window resize operation */
						buddy_op.op=BUDDY_OP_SIZE;
						buddy_op.wnd=appwnd;
						buddy_op.ix=buddy_op.mx;
						buddy_op.iy=buddy_op.my;
						yx->copy(
							(void*)affectedwnd->graphics->area,
							(void*)&(buddy_op.rect),
							sizeof(rect_t)
						);
						break;
					case WND_HIT_CLOSE:
						/* hide mouse */
						mouse_hide_cursor();

						/* remember the rectangle */
						yx->copy(
							(void*)appwnd->graphics->area,
							(void*)&(affectedrect),
							sizeof(rect_t)
						);
						message_send(appwnd,MSG_WND_CLOSE,0,0);
						window_destroy(appwnd);			
						window_invalidate(&affectedrect, window_desktop, window_desktop->first_child);
						
						/* show mouse */
						mouse_show_cursor(mi.x, mi.y, current_cursor);
						break;
				}
			}
			break;

		case MSG_MOUSE_LUP:
			if (buddy_op.op==BUDDY_OP_MOVING) { /* the end of the draw event */

				/* clean last drag */
				buddy_xor_op_rect(); 

				/* store affected rect */
				yx->copy(
					(void*)((buddy_op.wnd)->graphics->area),
					(void*)&affectedrect,
					sizeof(rect_t)
				);

				/* move window */
				if (lr=(buddy_op.ix > (byte)param1)) 
					dx=buddy_op.ix - (byte)param1;
				else
					dx=(byte)param1 - buddy_op.ix;
				if (ud=(buddy_op.iy > (byte)param2))
					dy=buddy_op.iy - (byte)param2;
				else 
					dy=(byte)param2 - buddy_op.iy;
				window_move(buddy_op.wnd, dx, lr, dy, ud);

				/* invalidate affected rect */
				window_invalidate(&affectedrect, window_desktop, window_desktop->first_child);

				/* redraw window at new position */
				window_draw(buddy_op.wnd);

			} else if (buddy_op.op==BUDDY_OP_SIZING) {

				/* clean last drag */
				buddy_xor_op_rect(); 

				/* get difference between xor rect and window rect */
				rect_intersect(&(buddy_op.rect), (buddy_op.wnd)->graphics->area, &affectedrect);
				rect_subtract((buddy_op.wnd)->graphics->area, &affectedrect, smaller, &num);
						
				/* and invalidate "the difference" */
				while(num) {
					window_invalidate(&(smaller[num-1]), window_desktop, window_desktop->first_child); 
					num--;
				}

			} else {
				/* find affected window */
				affectedwnd=window_find_xy(window_desktop,(byte)param1,(byte)param2); 

				/* post message */
				message_post(affectedwnd,id,param1,param2);

				/* if on the same location, then it is click */
				if (buddy_op.mx==(byte)param1 && buddy_op.my==(byte)param2) 
					message_post(affectedwnd,MSG_MOUSE_CLICK,param1,param2);
			}

			/* end of all operations */
			buddy_op.op=BUDDY_OP_NONE;

			break;

		case MSG_MOUSE_MOVE:

			if (buddy_op.op==BUDDY_OP_MOVE) /* initial move */
				buddy_op.op=BUDDY_OP_MOVING;

			if (buddy_op.op==BUDDY_OP_SIZE) /* initial resize */
				buddy_op.op=BUDDY_OP_SIZING;

			if (buddy_op.op==BUDDY_OP_MOVING) {
				/* calculate new position */
				rect_delta_offset(&(buddy_op.rect), buddy_op.mx, (byte)param1, buddy_op.my, (byte)param2, FALSE);

				/* store new coords */
				buddy_op.mx=(byte)param1;
				buddy_op.my=(byte)param2;

				/* and draw */
				buddy_xor_op_rect();
			}

			if (buddy_op.op==BUDDY_OP_SIZING) {
				/* calculate new size */
				rect_delta_offset(&(buddy_op.rect), buddy_op.mx, (byte)param1, buddy_op.my, (byte)param2, TRUE);

				/* store new coords */
				buddy_op.mx=(byte)param1;
				buddy_op.my=(byte)param2;

				/* and draw */
				buddy_xor_op_rect();
			}

			break;
	}
}


void buddy_xor_op_rect() {
	/* draw on desktop */
	graphics_draw_rect(window_desktop->graphics, &(buddy_op.rect), 0xff, MODE_XOR);
}
