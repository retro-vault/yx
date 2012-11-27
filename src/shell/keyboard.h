/*
 *	keyboard.h
 *	keyboard device driver 
 *
 *	tomaz stih wed may 30 2012
 */
#ifndef _KEYBOARD_H
#define _KEYBOARD_H

/*
 * special key codes
 */
#define CAPS			0x01	/* caps shift */
#define SYM			0x02	/* symbol shift */
#define CAPSSYM			0x03	/* caps shift + symbol shift */
#define CAPSBRK			0x04	/* caps shift + break */
#define SYMBRK			0x05	/* symbol shift + break */
#define LEFT			0x08
#define RIGHT			0x09
#define DOWN			0x0a
#define UP			0x0b
#define DELETE			0x0c
#define ENTER			0x0d
#define SPACE			0x20
#define PROGR			0xfe	/* programmable key */
#define NOMAP			0xff	/* no mapping for key combination */

#define CAPSOFFS		0x00
#define SYMOFFS			0x24
#define KBD_BUFF_SIZE		32

extern byte kbd_buffer[];
extern byte kbd_buff_head;
extern byte kbd_buff_tail;

typedef struct kbd_handle_s {
	driver_t *driver;
	task_t *owner;
	byte *ret_char;
	event_t *read_done;
} kbd_handle_t;

extern word kbd_open(struct driver_s *drv, uint8_t *hint, uint16_t attr);
extern void kbd_close(word handle);
extern result kbd_read_async(word handle, uint8_t *buffer, uint16_t count, event_t *done);
extern void kbd_timer_hook();

#endif
