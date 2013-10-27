/*
 *	message.h
 *	message header
 *
 *	tomaz stih sun oct 27 2013
 */
#ifndef _MESSAGE_H
#define _MESSAGE_H

#include "types.h"
#include "window.h"

#define	MSG_IDLE	0
#define	MSG_QUIT	1
#define	MSG_WND_CLOSE	2
#define MSG_WND_MOVE	3
#define MSG_WND_SIZE	4

typedef struct message_s {
	window_t *window;
	byte id;
	word param1;
	word param2;	
} message_t;

extern result message_send(window_t *wnd, byte id, word param1, word param2);
extern result message_post(window_t *wnd, byte id, word param1, word param2);

#endif /* _MESSAGE_H */
