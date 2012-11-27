/*
 *	debug.h
 *
 *	debugging
 *
 */
#ifndef _DEBUG_H
#define _DEBUG_H
 
extern void dbg_say(string msg);
extern void dbg_putc_xy(byte c, byte x, byte y) __naked;
extern void dbg_cls() __naked;
extern void dbg_scroll() __naked;
#ifdef DEBUG
extern void dbg_wtox(word w, string destination);
extern void dbg_memdump();
extern void dbg_taskdump();
#endif

#endif
