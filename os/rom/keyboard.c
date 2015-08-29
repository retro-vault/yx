/*
 *	keyboard.c
 *	keyboard scanning (hw code is in kbd.s)
 *
 *	tomaz stih thu jul 26 2012
 */
#include "types.h"
#include "keyboard.h"

kbd_buff_t kbd_buff;
char kbd_prev_scan[8];
