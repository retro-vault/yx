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


typedef struct message_s {
	window_t *window;
	byte id;
	word param1;
	word param2;	
} message_t;

extern result message_send(window_t *wnd, byte id, word param1, word param2);
extern result message_post(window_t *wnd, byte id, word param1, word param2);
extern void message_harvest();

#endif /* _MESSAGE_H */
