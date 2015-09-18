/*
 *	keyboard.h
 *	keyboard scanning (hw code is in kbd.s)
 *
 *	tomaz stih thu jul 26 2012
 */
#ifndef _KEYBOARD_H
#define _KEYBOARD_H

#include "types.h"

#define KEY_DOWN_BIT	0b01000000

typedef struct kbd_buff_s {
	byte start;
	byte end;
	byte count;
	byte buffer[32];
} kbd_buff_t;

extern void *kbd_map;
extern void *kbd_map_symbol;
extern void *kbd_map_shift;

extern void kbd_init() __naked;
extern void kbd_scan() __naked;
extern byte kbd_read() __naked;

#endif /* _KEYBOARD_H */
