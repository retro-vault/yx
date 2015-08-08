/*
 *	buddy.h
 *	main buddy loop, mostly event harvesting
 *	and message dispatching.
 *
 *	tomaz stih sun jul 2 2015
 */
#ifndef _BUDDY_H
#define _BUDDY_H

#include "types.h"
#include "window.h"

/* 
 * operation in progress (multiple mouse events comms) 
 */
#define BUDDY_OP_NONE	0
#define	BUDDY_OP_MOVE	1
#define BUDDY_OP_MOVING	2
#define BUDDY_OP_SIZE	3
#define BUDDY_OP_SIZING	4
typedef struct buddy_op_s buddy_op_t;
struct buddy_op_s {
	boolean op;		/* op code */
	rect_t rect;		/* affected  */
	window_t *wnd;		/* affected wnd */
	byte mx;		/* for generic op */
	byte my;		/* for generic op */
	byte ix;		/* initial x */
	byte iy;		/* initial y */
};

extern buddy_op_t buddy_op;

extern void buddy_init();
extern void buddy_harvest_events();
extern void buddy_dispatch(byte id, word param1, word param2);
extern void buddy_xor_op_rect();

#endif /* _BUDDY_H */
