/*
 *	message.h
 *	message header
 *
 *	tomaz stih sun oct 27 2013
 */
#ifndef _MESSAGE_H
#define _MESSAGE_H

#include "yx.h"
#include "window.h"

#define MSG_SYS_IDLE	0
#define	MSG_SYS_QUIT	1
#define MSG_SYS_PAINT	2 /* system paint */
#define MSG_WND_CREATE	3
#define MSG_WND_DESTROY	4
#define	MSG_WND_CLOSE	5
#define MSG_WND_MOVE	6
#define MSG_WND_SIZE	7 /* param1 ... rect_t* to change */
#define MSG_WND_PAINT	8 /* user paint */
#define MSG_MOUSE_MOVE	9
#define MSG_MOUSE_LDOWN	10 /* param1 ... x, param2 ... y */
#define MSG_MOUSE_LUP	11 /* param1 ... x, param2 ... y */
#define MSG_MOUSE_RDOWN	12 /* param1 ... x, param2 ... y */
#define MSG_MOUSE_RUP	13 /* param1 ... x, param2 ... y */
#define MSG_WND_CREATED	14 /* window successfully created */
#define MSG_MOUSE_CLICK	15 /* param1 ... x, param2 ... y */
#define MSG_WND_HITTEST	16 /* hit test for system areas, param1=byte* result */

#define WND_HIT_NONE	0
#define WND_HIT_TITLE	1
#define WND_HIT_CLOSE	2
#define WND_HIT_RESIZE	3

typedef struct message_s message_t;
typedef struct message_s {
	message_t* next;
	word reserved;
	window_t *window;
	byte id;
	word param1;
	word param2;	
};

extern message_t *message_first;

extern result message_send(window_t *wnd, byte id, word param1, word param2);
extern result message_post(window_t *wnd, byte id, word param1, word param2);
extern void message_dispatch();

#endif /* _MESSAGE_H */
