/*
 *	mouse.h
 *	mouse routines header
 *
 *	tomaz stih sat aug 1 2015
 */
#ifndef _MOUSE_H
#define _MOUSE_H

#include "types.h"

#define	MOUSE_RBUTTON	0x01 /* bit 0 */
#define MOUSE_LBUTTON	0x02 /* bit 1 */
#define MOUSE_MBUTTON	0x04 /* bit 2 */

#define MOUSE_CURSOR_WIDTH	8
#define MOUSE_CURSOR_HEIGHT	10

/* mouse info */
typedef struct mouse_info_s mouse_info_t;
struct mouse_info_s {
	byte x;
	byte y;
	byte button;
	byte button_change;
};

extern void mouse_init();
extern void mouse_calibrate(byte x, byte y);
extern void mouse_scan(mouse_info_t *mi);
extern void calc_mouse_rect(mouse_info_t *mi);
extern void mouse_show_cursor(byte x, byte y, void *cursor);
extern void mouse_hide_cursor();

/* mouse cursors */
extern void* current_cursor;
extern void* cur_classic;
extern void* cur_std;
extern void* cur_hand;
extern void* cur_hourglass;
extern void* cur_caret;

/* mouse global vars */
extern mouse_info_t mi;
extern rect_t mouse_rect;

#endif /* _MOUSE_H */
