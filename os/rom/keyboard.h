/*
 *	keyboard.h
 *	keyboard scanning (hw code is in kbd.s)
 *
 *	tomaz stih thu jul 26 2012
 */
#ifndef _KEYBOARD_H
#define _KEYBOARD_H

typedef struct kbd_buff_s {
	char head;
	char tail;
	char buffer[32];
} kbd_buff_t;

extern kbd_buff_t kbd_buff;
extern char kbd_prev_scan[];

extern void kbd_scan() __naked;
extern void kbd_init() __naked;

#endif /* _KEYBOARD_H */
