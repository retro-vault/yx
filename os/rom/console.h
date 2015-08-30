/*
 *	console.h
 *	console
 *
 *	tomaz stih wed aug 26 2015
 */
#ifndef _CONSOLE_H
#define _CONSOLE_H

#include "types.h"

extern void* con_font6x6;
extern byte* con_x;
extern byte* con_y;

extern void con_putcharxy(byte x, byte y, byte ascii);
extern void con_clrscr();
extern void con_scroll_up();
extern void con_puts(string s);
extern void con_back();

#endif /* _CONSOLE_H */
