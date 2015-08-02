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

extern void buddy_init();
extern void buddy_harvest_events();
extern void buddy_dispatch(byte id, word param1, word param2);
extern window_t *buddy_get_window_xy(window_t* root, byte absx, byte absy);

#endif /* _BUDDY_H */
