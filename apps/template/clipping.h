/*
 *	clipping.h
 *	clipping math and util functions
 *
 *	tomaz stih tue jun 9 2015
 */
#ifndef _CLIPPING_H
#define _CLIPPING_H

#include "types.h"

extern void clip_1d(byte l0, byte l1, byte r0, byte r1, byte *c0, byte *c1);
extern void clip_offset(byte ofsx, byte ofsy, byte* maskin, byte* maskout);

#endif /* clipping.h */
