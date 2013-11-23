/*
 *	debug.h
 *	diagnostics
 *
 *	tomaz stih wed apr 3 2013
 */
#ifndef _DEBUG_H
#define _DEBUG_H

extern void dbg_wtox(word w, string destination);
extern void dbg_memdump(void *heap);
extern void dbg_evtdump();
extern void dbg_tmrdump();

#endif
