/*
 *	lores.h
 *	low resolution graphics (text mode)
 *
 *	tomaz stih wed mar 20 2013
 */
#ifndef _LORES_H
#define _LORES_H

extern byte lores_x, lores_y;

extern void lores_putc_xy(byte c, byte x, byte y) __naked;
extern void lores_puts(string s);
extern void lores_scrollup() __naked;
extern word lores_vmem_addr(byte x, byte y) __naked;

#endif
